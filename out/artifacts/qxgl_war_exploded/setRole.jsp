<%@ page pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script>
        window.onload = function(){
            var allBtn = document.getElementById('allBtn');
            allBtn.onclick = function(){
                //随着对allbtn点击操作，下面的所有复选框要紧随状态
                var inputs = document.getElementsByTagName('input') ;
                for(var i=0;i<inputs.length;i++){
                    var input = inputs[i] ;
                    if(input.type=='checkbox' && input != this){
                        //设置复选框的状态
                        //复选框的选中选掉状态设置 input.checked=true/false
                        input.checked = this.checked ;
                    }
                }
            }
        }
    </script>
</head>
<body>
    <h2 align="center">为【${param.truename}】设置角色</h2>
    <form action="UserAction.do?method=setRoles" method="post">
        <input type="hidden" name="uid" value="${param.uid}" />
        <h3 align="center">
            <button>保存</button>
        </h3>
        <table align="center" border="1" width="60%">
            <thead>
            <tr>
                <th><input type="checkbox" id="allBtn" /></th>
                <th>角色编号</th>
                <th>角色名称</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${requestScope.roles}" var="role">
                <tr align="center">
                    <td>
                        <c:set var="f" value="flase"></c:set>
                        <c:forEach items="${requestScope.rids}" var="rid">
                            <c:if test="${role.rid == rid}">
                                <c:set var="f" value = "true" ></c:set>
                            </c:if>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${f == true}">
                                <input type="checkbox" name="rid" value="${role.rid}" checked="checked" />
                            </c:when>
                            <c:otherwise>
                                <input type="checkbox" name="rid" value="${role.rid}"  />
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${role.rid}</td>
                    <td>${role.rname}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </form>
</body>
</html>