<%@ page import="com.qxgl.domain.Fn" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>主页</title>
        <style type="text/css">
            body{
                margin: 0;   /*消除body的外边距*/
            }
            .top{
                width: 100%;
                height: 118px;
                top: 0;
                left: 0;
                border-bottom: 2px solid #ccc;
            }
            .left{
                width: 248px;
                position: absolute;
                /*自动填充：让其距离顶部120px，距离底部0，这样中间就填充满了*/
                top: 120px;
                bottom: 0; /*让其高度无限(适应页面内容)*/
                left: 0;  /*让其紧贴左侧*/
                border-right: 2px solid #ccc;
            }
            .right{
                position: absolute;
                /*自动填充：让其距离顶部120px，距离底部0，这样中间就填充满了*/
                top: 120px;
                bottom: 0;
                left: 250px;
                right: 0;
            }
            .title{
                font-size: 40px;
                margin-left: 20px;
                line-height:118px;
            }
            .msg{
                position: absolute;
                right: 100px;
                top: 80px;
            }
            .menuBox{
                margin:20px;
            }
            .menuBox dt{
                margin-top:4px;
                margin-bottom:4px;
            }
        </style>

        <script>
            window.onload = function(){
                //获得登录用户的权限分配的功能菜单
                //原来获得信息是通过ajax
                //但这次不需要了，因为数据在登录时已经查询出来，并装入session
                //我们只需要从session中获取功能菜单。
                //session是java代码(服务器，后台)，现在是js代码需要(浏览器，前台)
                <%
                    //在java代码中，获得session中的菜单集合
                    List<Fn> menus = (List<Fn>) session.getAttribute("menus") ;
                    //在java代码中，将菜单集合json序列化 转换成字符串
                    String json = JSON.toJSONString(menus); //"[{},{},{}]"
                %>
                //jsp拼装网页时，将java的字符串作为值编写在js的代码中
                var json ='<%=json%>'; //浏览器执行65行代码时，才会实现js变量的赋值
                var menus = JSON.parse(json);

                //递归拼装菜单
                var position = document.getElementById('menuBox') ;
                showFn(menus,position);
            }

            //fns 要显示的菜单
            //position 菜单要实现的位置(标签)
            function showFn(fns,position){
                for(var i=0;i<fns.length;i++){
                    //获得一个菜单
                    var fn = fns[i] ;
                    var dt = document.createElement('dt');
                    position.appendChild(dt);
                    if(fn.fhref){
                        //这个菜单需要超链接请求
                        dt.innerHTML = '<a href="'+fn.fhref+'" target="content">'+fn.fname+'</a>'
                    }else{
                        dt.innerHTML = fn.fname ;
                    }

                    //是不是需要显示子菜单
                    if(fn.children && fn.children.length > 0){
                        //有子菜单
                        var dd = document.createElement('dd');
                        position.appendChild(dd);
                        var dl = document.createElement('dl');
                        dd.appendChild(dl);
                        showFn(fn.children,dl);
                    }
                }
            }
        </script>
    </head>
    <body>
        <div class="top">
            <h3 class="title">某企业商业系统</h3>
            <div class="msg">欢迎【<a href="UserAction.do?method=exit">${sessionScope.loginUser.truename}</a>】</div>
        </div>
        <div class="left">
            <dl id="menuBox" class="menuBox">

            </dl>
        </div>
        <div class="right">
            <!-- 内嵌的子窗口 -->
            <iframe name="content" frameborder="0" width="100%" height="100%"></iframe>
        </div>
    </body>
</html>
