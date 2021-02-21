package com.qxgl.dao;

import com.qxgl.comm.SqlFactoryUtil;
import com.qxgl.domain.User;
import jdbc.JdbcFactory;
import jdbc.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * dao层：该层通过jdbc与数据库进行交互，完成CURD操作
 */
public class UserDao {

    /**
     * 该UserDao设计为单例模式
     * 懒汉式
     */
    public static final String s = new String("lzb");
    private UserDao(){};
    private static volatile UserDao dao;
    public static UserDao getDao(){
        //假设10个线程同时访问执行了这行判断，都发现dao为null，都去创建对象
        if(dao == null){  //判断是否需要等待
            //所以发现dao为null准备创建时，需要上锁，保证只有一个线程能执行(创建)
            synchronized (s){  //小括号里的值保证是单实例就行(保证只有一份)，目的是让所有线程使用同一把锁
                //线程获得锁之后，准备创建时还需要再判断一次，看看之前是否被创建过
                if(dao == null){  //判断是否需要创建
                    dao = new UserDao(); //假设 第1个线程再创建dao对象的同时，第11个线程又来了
         // 如果没有使用volatile，表示第1个线程创建dao对象后，把地址装入变量dao里
         // 如果使用volatile，表示第1个线程先把地址装入变量dao里，再创建dao对象
         // 因此使用volatile对单例模式没有影响，但对第11个线程来说有影响，加上volatile，则
         // 表示先将对象地址放入变量dao中，就防止了第11个线程占用变量dao的空间。
                }
            }
        }
        return dao;
    }

    /**
     * 验证登录：通过前面的参数uname和upass，来查询数据库中的数据，查到则返回对象，反则返回null
     * @param uname
     * @param upass
     * @return
     */
    public User findByNameAndPass(String uname,String upass){
        //1.提供sql语句
        String sql = "select * from t_user where uname = #{uname} and upass = #{upass}";
        //2.可以使用原生JDBC六部曲，现在我们使用自己封装的orm框架实现jdbc过程
         //2.1 通过读取配置文件来创建工厂
        //JdbcFactory factory = new JdbcFactory("mysql.properties");
         //2.2 从工厂中获取sqlSession对象
        SqlSession sqlSession = SqlFactoryUtil.getSession();
        //3.将方法中的参数(前面传递过来的)组成一个map集合
        Map<String,Object> param = new HashMap<>();
        param.put("uname",uname);
        param.put("upass",upass);
        //4.使用sqlSession对象中的方法来执行sql语句
        //参数1：sql。表示执行的sql语句
        //参数2：param。表示sql语句中#{key}对应的参数名
        //参数3：User.class。查询语句的查询结果组装对象类型，表示查询结果组成User类型的对象。
        return sqlSession.selectOne(sql,param,User.class);
    }

    /**
     * @return  查询用户信息总记录数
     */
    public long total(){
        String sql = "select count(*) from t_user where del = 1";
        //JdbcFactory factory = new JdbcFactory("mysql.properties");
        SqlSession session = SqlFactoryUtil.getSession();
        return session.selectOne(sql,Long.class);
    }

    /**
     * 查询所有用户信息
     * @param start    从第start行开始查
     * @param length   共查询length条记录
     * @return         所有用户信息
     */
    public List<User> find(int start, int length){
        String sql = "select * from t_user where del = 1 limit #{start},#{length}";
        //JdbcFactory factory = new JdbcFactory("mysql.properties");
        SqlSession session = SqlFactoryUtil.getSession();
        Map<String,Integer> params = new HashMap<>();
        params.put("start",start);
        params.put("length",length);
        return session.selectList(sql,params,User.class);
    }

    /**
     * 保存用户：即向数据库中存入一条用户信息
     * @param user
     */
    public void save(User user){
        //注意：在这条sql语句中，也输入了#{yl1}和#{yl2}这两个数据(传到数据库中是空字符串'')，而没有传null。
        //     是因为如果前端需要用到预留字段，只需要改前端页面就可以了，不需要改后端信息
        String sql = "insert into t_user values(null,#{uname},#{upass},#{truename},#{sex},#{age},1,now(),#{yl1},#{yl2})" ;
        //原来需要自己写jdbc
        //现在使用orm框架实现jdbc
        SqlSession session = SqlFactoryUtil.getSession() ;//确保单实例工厂产生session
        session.insert(sql,user) ;
    }

    /**
     * 删除一个用户信息的操作
     * @param uid  用户的uid
     */
    public void delete(Integer uid){
        String sql = "delete from t_user where uid = #{uid}";
        SqlSession sqlSession = SqlFactoryUtil.getSession();
        sqlSession.delete(sql,uid);
    }

    /**
     * 通过用户id查询单个用户信息
     * @param uid   用户id
     * @return      单个用户对象
     */
    public User findById(Integer uid){
        String sql = "select * from t_user where uid = #{uid}";
        SqlSession sqlSession = SqlFactoryUtil.getSession();
        return sqlSession.selectOne(sql,uid,User.class);
    }

    /**
     * 编辑用户信息操作
     * @param user  用户信息对象
     */
    public void update(User user){
        String sql = "update t_user set uname=#{uname},truename=#{truename},age=#{age},sex=#{sex} where uid=#{uid}";
        SqlSession sqlSession = SqlFactoryUtil.getSession();
        sqlSession.update(sql,user);
    }


    public List<User> findByName(String uname){
        String sql = "select * from t_user where uname = #{uname}" ;
        return null ;
    }

    public void saveRelationship(Integer uid,Integer rid){
        String sql = "insert into t_user_role values(#{uid},#{rid})" ;
        SqlSession session = SqlFactoryUtil.getSession() ;
        Map<String , Integer> param = new HashMap<String,Integer>();
        param.put("uid",uid);
        param.put("rid",rid);
        session.insert(sql,param);
    }

    public void deleteRelationship(Integer uid){
        String sql = "delete from t_user_role where uid = #{uid}" ;
        SqlSession session = SqlFactoryUtil.getSession() ;
        session.delete(sql,uid);
    }

    public List<Integer> findRidsByUser(Integer uid){
        String sql = "select rid from t_user_role where uid = #{uid}" ;
        SqlSession session = SqlFactoryUtil.getSession() ;
        return session.selectList(sql,uid,Integer.class) ;
    }
}
