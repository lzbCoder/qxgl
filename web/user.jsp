<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Title</title>
        <script type="text/javascript">
            //点击删除超链接，触发当前函数功能，实现去删除的操作
            //可以在删除之前，给与一个询问框
            function toDelete(uid,uname) {
                //显示一个询问框，根据选择的确定或取消，获得一个boolean结果赋值给f
                var f = confirm('是否确认删除【'+uname+'】');
                if(f == true){
                    //点击确定，要删除
                    //所谓的删除就是发送请求
                    //js如何发送请求呢?
                    // location.href=? , window.open(?) , ajax
                    location.href = 'UserAction.do?method=delete&uid='+uid;
                }else {
                    //点击取消，什么都不做了
                }
            }
        </script>
    </head>
    <body>
        <h2 align="center">用户列表</h2>
        <h4 align="center">
            <a href="userAdd.jsp">新建用户</a>
            <a href="userimport.jsp">导入用户</a>
        </h4>
        <table align="center" width="90%" border="1">
            <thead>
                <tr>
                    <th>用户编号</th>
                    <th>用户名</th>
                    <th>真实姓名</th>
                    <th>用户性别</th>
                    <th>用户年龄</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${requestScope.page.list}" var="user">
                    <tr align="center">
                        <td>${user.uid}</td>
                        <td>${user.uname}</td>
                        <td>${user.truename}</td>
                        <td>${user.sex}</td>
                        <td>${user.age}</td>
                        <td>
                            <a href="UserAction.do?method=edit&uid=${user.uid}">编辑</a> |
                            <a href="javascript:toDelete(${user.uid},'${user.uname}')">删除</a> |
                            <a href="UserAction.do?method=toSetRole&uid=${user.uid}&truename=${user.truename}">设置角色</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <table width="90%" align="center">
            <tr>
                <td align="left">
                    第${requestScope.page.page}页/共${requestScope.page.max}页
                </td>
                <td align="right">
                    <a href="UserAction.do?method=list&page=1">首页</a>
                    <c:if test="${requestScope.page.page > 1}">
                        <a href="UserAction.do?method=list&page=${requestScope.page.page-1}">上一页</a>
                    </c:if>
                    <c:if test="${requestScope.page.page < requestScope.page.max}">
                        <a href="UserAction.do?method=list&page=${requestScope.page.page+1}">下一页</a>
                    </c:if>
                    <a href="UserAction.do?method=list&page=${requestScope.page.max}">末页</a>
                </td>
            </tr>
        </table>
    </body>
</html>
