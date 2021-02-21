<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>新建用户界面</title>
        <style type="text/css">
            .userAddBox{
                width:400px;
                background: #cfc;
                border:4px solid #ccc ;
                border-radius: 10px;
                box-shadow: 5px 5px 10px #000;  /*阴影*/
                margin:50px auto ;  /*外边距，盒子与盒子之间的距离*/
                padding-bottom:10px; /*内边距， 盒子内容与盒子之间的距离*/
            }

            .userAddBox input{
                width:250px;
                height:30px;
            }
            .userAddBox select{
                width:250px;
                height:30px;
            }

            .userAddBox tr{
                height:45px;
            }

            .userAddBox button{
                width:50px;
                height:30px;
            }
        </style>
        <script type="text/javascript">
            function check(){ //function 表示是一个方法(函数)
                //获得密码和确认密码，比较
                //js中的变量是弱类型变量，定义变量时不能确定变量存储数据的类型，用var定义
                //java 用 int i ;  js 用 var i ;
                var upass = document.getElementById('upass');
                var repass = document.getElementById('repass') ;
                if(upass.value === repass.value){
                    return true ;//继续提交
                }
                alert('两次密码不一致');
                return false ;//终止提交
            }
        </script>
    </head>
    <body>
        <div class="userAddBox">
            <h2 align="center">新建用户</h2>
            <!--提交请求时，调用check()函数，检验两次输出的密码是否成功,成功才能提交请求-->
            <form action="UserAction.do?method=add" method="post" onsubmit="return check()">
                <table align="center">
                    <tr>
                        <td>用户名：</td>
                        <%--属性required是H5才出现的，它的作用是该文本框不能为空，必须有值--%>
                        <td><input name="uname" type="text" required="required"></td>
                    </tr>

                    <tr>
                        <td>密码：</td>
                        <td><input id="upass" name="upass" type="password" required="required"></td>
                    </tr>

                    <tr>
                        <td>确认密码：</td>
                        <%--由于确认密码该行并不需要获取到后端，并不写入数据库，因此不需要用name属性--%>
                        <td><input id="repass" type="password" required="required"></td>
                    </tr>

                    <tr>
                        <td>真实姓名：</td>
                        <td><input name="truename" required="required"></td>
                    </tr>

                    <tr>
                        <td>性别：</td>
                        <td>
                            <select name="sex">
                                <option>男</option>
                                <option>女</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>年龄：</td>
                        <%--type属性为number，表示限制该输入框只能输入数字。--%>
                        <td><input name="age" type="number" required="required"></td>
                    </tr>

                    <tr>
                        <td colspan="2" align="center">
                            <button>保存</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
