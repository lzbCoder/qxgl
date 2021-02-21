package com.qxgl.action;

import com.qxgl.domain.Fn;
import com.qxgl.domain.Page;
import com.qxgl.domain.Role;
import com.qxgl.domain.User;
import com.qxgl.service.RoleService;
import com.qxgl.service.UserService;
import mymvc.ModelAndView;
import mymvc.RequestParam;
import mymvc.ResponseBody;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 控制层对象：用来接收与用户相关的请求
 */
public class UserAction {

    private static final Integer PAGE_ROW = 10; //表示每页显示的记录数

    /**
     *属性：需要一个service层对象作为属性
     */
    private UserService service = UserService.getService();
    private RoleService roleService = RoleService.getService();

    /**
     * 登录方法
     * @param uname   前端页面传递过来的uname
     * @param upass   前端页面传递过来的upass
     * @return    处理完请求，返回相应的响应信息
     */
    public String login(@RequestParam("uname") String uname, @RequestParam("upass") String upass, HttpServletRequest request){
        //1.接收请求参数信息
        //System.out.println(uname+"--"+upass);
        //2.让service层做事
        User user = service.checkLogin(uname,upass);
        //3.根据service层返回的处理结果，做出相应的响应
        if(user == null){
            //表示登录失败
            return "index.jsp?status=9";
        }else{
            //表示登录成功
            //登录成功,显示主页面，还需要在主页面上显示登录成功的用户信息。
            //如何使得在登录成功时查询出来的用户信息，可以在主页面或其他页面使用呢。
            //需要将此次请求获得的user对象装入session
            HttpSession session = request.getSession();
            session.setAttribute("loginUser",user);

            //还需要额外的信息： 登录的这个user用户所具有的权限菜单
            List<Fn> menus = service.findMenuFnByUser(user.getUid());

            List<Fn> buttonList = service.findButtonFnByUser(user.getUid());
            Map<String,Fn> buttons = new HashMap<String,Fn>();
            for(Fn button : buttonList){
                buttons.put(button.getFname(),button);
            }
            session.setAttribute("menus",menus);
            session.setAttribute("buttons",buttons);

            return "main.jsp" ;
        }
    }

    /**
     * 注销，退出
     * 清空session中的数据
     * 重新展示(访问)登录页面
     */
    public String exit(HttpServletRequest request){
        request.getSession().invalidate();  //清空session数据
        return "/";  //表示返回到首页(index.jsp)
    }

    /**
     * 用户管理按钮：查询用户信息
     * 采用分页查询的业务功能
     * @param page 此次分页查询时的页码
     *
     * 阿拓老师的框架中使用 request.getParemeter("page"); 帮我们获得参数，阿拓老师怎么知道要接收哪个参数呢
     * 使用@RequestParam告诉阿拓老师帮我们获得指定名字的参数
     */
    public ModelAndView list(@RequestParam("page") Integer page){
        //freemarker thymeleaf 动态网页模板，类似于jsp，但比jsp更优秀
        UserService service = UserService.getService();
        Page p = service.find(page,PAGE_ROW);
        //查询完毕，需要访问展示jsp页面，同时传递page数据
        //怎么实现又可以访问页面，又可以传递数据，转发
        //mvc框架如何实现转发，ModelAndView
        ModelAndView mv = new ModelAndView();
        mv.setViewName("user.jsp");
        mv.addAttribute("page",p);
        return mv;
    }

    /**
     * 新建用户的请求
     * @param user     将userAdd.jsp页面中输入的用户信息组成一个User对象(自动注入)
     * @param response 向页面返回响应信息
     */
    public void add(User user, HttpServletResponse response) throws IOException {
        //这就是保存之前，这就可以实现登录认证，一定需要使用filter
        //保存操作，交给业务层处理
        service.save(user);
        //不考虑特殊情况，应该保存成功。
        //页面实现一个保存成功的提示，响应一句话提示语 (直接响应)
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().write("保存成功");
    }

    /**
     * 删除一个用户信息
     * @param uid    用户的id
     * @return       返回一个视图
     */
    public String delete(@RequestParam("uid") Integer uid){
        //让业务层去处理
        service.delete(uid);
        //不考虑特殊情况，删除成功
        //此次操作完成，不想直接返回成功提示，想直接重新显示列表，列表中没有数据了就算是删除成功了。
        //想显示数据列表，数据列表是由list方法处理的
        return "redirect:UserAction.do?method=list" ;
    }

    /**
     * 编辑用户信息的操作
     * @param uid   用户的id
     * @return      返回视图和数据
     */
    public ModelAndView edit(@RequestParam("uid") Integer uid){
        //所谓的编辑请求，就是根据uid，查找要编辑的原始数据
        User user = service.edit(uid);
        //获得了编辑用户时的原始数据。
        //需要将这个原始数据带到页面去拼装：转发 ， mvc框架如何实现转发
        ModelAndView mv = new ModelAndView();
        mv.addAttribute("user",user);
        mv.setViewName("userEdit.jsp");
        return mv;
    }

    /**
     * 编辑完之后保存操作
     * @param user  编辑的用户信息
     * @return      重定向到另一个请求(到显示列表信息的页面)
     */
    public String update(User user){
        //修改
        service.update(user);
        return "redirect:UserAction.do?method=list" ;
    }

    /**
     * 文件上传: 批量导入数据
     * @return
     */
    @ResponseBody
    public String saves(HttpServletRequest request) throws FileUploadException, IOException {
        //任务1：获得上传的excel文件
        // 前提：需要两个jar包：commons-fileupload-1.4、commons-io
        //任务2：将excel表格中的结构与java代码对应
        // 前提：需要jar包：poi
        //任务3：将excel表格中的数据写入数据库中

        //1.创建一个DiskFileItemFactory工厂对象
        //负责将上传的信息重新组装成FileItem对象，这些FileItem对象存放在factory工厂内
        DiskFileItemFactory factory = new DiskFileItemFactory();
        //2.使用factory创建ServletFileUpload对象
        // ServletFileUpload对象是一个工具，作用是从工厂中获得上传的信息
        ServletFileUpload fileUpload = new ServletFileUpload(factory);
        //3.fileUpload工具会使用内部的factory处理request携带的数据。
        List<FileItem> fis = fileUpload.parseRequest(request);
        /*
          以上三步总结：(前三步是应用型代码，固定)
            先创建一个DiskFileItemFactory工厂对象，作用是存放FileItem对象，但工厂不能将
            请求的数据解析成FileItem对象(即工厂不做事)；因此需要再创建一个ServletFileUpload对象，
            该对象的作用是将请求发送过来的数据解析成List<FileItem>集合，里面存放FileItem对象，这些
            解析后的对象是放在工厂中。
            原来请求的参数是在request对象中，现在这些参数信息是在fis集合中，
            如果需要获取参数就去集合中获取 (可以循环获取)。
            针对本次操作，只传递过来一个文件参数(即fis集合中的第一个FileItem对象)
         */
        //获取文件参数对应的FileItem对象
        FileItem fi = fis.get(0);
        //获取该上传文件的输入流，然后就可以通过输入流来获取文件内容
        InputStream is = fi.getInputStream();

        //根据is输入流指向的excel文件，读取、处理、创建出一个jvm(虚拟机)版本的excel对象
        //File -> 文件
        //Workbook -> excel文件
        Workbook book = WorkbookFactory.create(is);
        //在excel文件中获取一个数据表
        Sheet sheet = book.getSheetAt(0);
        //在数据表中获取数据行(循环)
        //由于第0行(数据表中的第一行)是标题，因此要从第1行(数据表中的第二行)开始
        //从下标为1的第二行开始获取，获取到最后一行。
        for(int i=1; i<=sheet.getLastRowNum(); i++){
            //从工作表中获取一个行对象(对应数据表中的一行)
            Row row = sheet.getRow(i);
            //从数据行中获取单元
            Cell c1 = row.getCell(0);
            Cell c2 = row.getCell(1);
            Cell c3 = row.getCell(2);
            Cell c4 = row.getCell(3);
            Cell c5 = row.getCell(4);

            //接下来就要获取单元中的数据啦
            /*
            获取单元数据时注意：
             可以使用ceil.toString方法获得单元中的数据值
             如果单元中的数据是数字形式，获得的字符串是浮点形式的
             */
            String uname = c1.toString();
            String upass = c2.toString().replace(".0","");   //"123.0"
            String truename = c3.toString();
            String sex = c4.toString();
            Integer age = Integer.parseInt(c5.toString().replace(".0",""));    //"18.0"

            //将上面从excel表格中获得的一行数据组成java中的一个User对象
            User user = new User();
            user.setUname(uname);
            user.setUpass(upass);
            user.setTruename(truename);
            user.setSex(sex);
            user.setAge(age);

            //实现保存操作
            service.save(user);
        }
        //完成了批量保存操作
        return "导入成功";
        //return "redirect:UserAction.do?method=list" ;
    }

    /**
     * 文件下载
     */
    public void down(HttpServletResponse response) throws IOException {
        //1.读取要下载的文件
        //简单的理解成读取src目录下的文件
        InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("users.xlsx");
        //2.将读取到的文件装入byte[]数组中
        byte[] bs = IOUtils.toByteArray(is);
        //3.将文件内容响应给浏览器
        //response对象可以实现响应
        //响应时注意：要设置一个响应头(固定代码)
        response.setHeader("content-disposition","attachment;filename=users.xlsx");
        //response对象获取文件输出流，将byte[]数组中的内容写回浏览器
        response.getOutputStream().write(bs);
        //刷新输出流
        response.getOutputStream().flush();
    }

    /**
     *设置角色
     */
    public ModelAndView toSetRole(@RequestParam("uid") Integer uid,@RequestParam("truename") String truename){
        //查询获得所有的角色列表
        List<Role> roles = roleService.list() ;
        //还需要额外查询获得uid这个用户上一次分配的角色信息
        List<Integer> rids = service.findRidsByUser(uid) ;
        ModelAndView mv = new ModelAndView();
        mv.setViewName("setRole.jsp");
        mv.addAttribute("roles",roles);
        mv.addAttribute("rids",rids);
        //mv.addAttribute("uid",uid);
        //mv.addAttribute("truename",truename);
        return mv ;
    }


    @ResponseBody
    public String setRoles(@RequestParam("uid") Integer uid, HttpServletRequest request){
        String[] ridArray = request.getParameterValues("rid") ;
        service.setRoles(uid,ridArray);
        return "角色分配成功" ;
    }
}
