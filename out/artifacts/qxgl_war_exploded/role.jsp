<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>角色管理</title>
        <script type="text/javascript">
            window.onload = function () {
                //网页加载完毕后，执行操作，加载数据，因为要保留原内容，所以使用ajax发请求
                toFind(1);  //表示网页加载完毕，访问第1页
            }

            function toFind(page) {
                //ajax发送请求，查询分页的列表数据
                //1.创建xhr对象
                var xhr = new XMLHttpRequest();  //可以发送请求的对象
                //2.设置连接
                xhr.open('get','RoleAction.do?method=list&page='+page+'&rows=2');
                //3.监听响应状态
                xhr.onreadystatechange = function () {
                    if(xhr.readyState == 4 && xhr.status == 200){
                        //获得了完整的正确的响应
                        //调用回调函数
                        doBack(xhr.responseText);
                    }
                }
                //4.发送请求
                xhr.send();

                //设置回调函数
                function doBack(result) {
                    //告诉ajax如何操作响应回来的内容
                    //alert(result);
                    //result是一个json格式的字符串，需要json反序列化转换成js格式的对象
                    var p = JSON.parse(result).jsonObject;  //p就是js版的Page
                    //p中包含一个list，max，page
                    //使用js的dom将数据拼装在tbody中
                    //所谓的dom就是使用js编写html代码
                    var list = p.list;
                    var tbody = document.getElementById('roleBody');
                    tbody.innerHTML = ''; //将原来里面的内容清空，局部刷新表格数据
                    for(var i=0; i<list.length; i++){
                        var role = list[i];
                        var tr = document.createElement('tr'); //创建一个tr标签
                        tbody.appendChild(tr); //将tr标签写在tbody中
                        tr.align = 'center';

                        var td1 = document.createElement('td');
                        var td2 = document.createElement('td');
                        var td3 = document.createElement('td');
                        tr.appendChild(td1);
                        tr.appendChild(td2);
                        tr.appendChild(td3);

                        td1.innerHTML = role.rid;
                        td2.innerHTML = role.rname;
                        td3.innerHTML = '<a href="">删除</a> | <a href="">编辑</a> | <a href="setFn.jsp?rid='+role.rid+'&rname='+role.rname+'">设置功能</a>'
                    }
                    //数据表格拼装完毕
                    //拼装分页栏
                    var left = document.getElementById('left');
                    left.innerHTML = '第'+p.page+'页/共'+p.max+'页';

                    var right = document.getElementById('right');
                    right.innerHTML = '<a href="javascript:toFind(1)">首页</a>';
                    if(p.page > 1){
                        right.innerHTML += '<a href="javascript:toFind('+ (p.page-1) +')">上一页</a>';
                    }
                    if(p.page < p.max){
                        right.innerHTML += '<a href="javascript:toFind('+ (p.page+1) +')">下一页</a>';
                    }
                    right.innerHTML += '<a href="javascript:toFind('+ p.max +')">末页</a>';
                }
            }
        </script>
    </head>
    <body>
        <h2 align="center">角色列表</h2>
        <table align="center" border="1" width="60%">
            <thead>
                <tr>
                    <th>角色编号</th>
                    <th>角色名称</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="roleBody">
                <!--需要拼装动态角色数据，发现没有数据，请求数据-->
            </tbody>
        </table>
        <table align="center" width="60%">
            <tr>
                <td align="left" id="left"></td>
                <td align="right" id="right"></td>
            </tr>
        </table>
    </body>
</html>
