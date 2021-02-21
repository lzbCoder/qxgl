<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        ul,li{
            margin:0;
            padding:0;
            list-style: none;
        }
        dt,dd,dl{
            clear:both ;
        }
        dd,dl{
            margin-top:0;
            margin-bottom:0;
        }
        .menuBox{
            width:250px;
            border:1px solid #ccc ;
            padding:20px;
            margin:0 auto ;
        }
        dt{
            cursor: default;
            height:30px;
        }
        li{
            height:30px;
            float:left;
            line-height:30px;

        }
        li.title{
            float:left;
        }
        li.flag{
            width:100px;
            float:right;
        }
        li.link{
            width:200px;
            float:right;
        }
    </style>
    <script>
        window.onload = function(){
            //网页加载完毕后，ajax请求加载功能信息
            initLoadFn();

            //网页加载完毕，ajax请求当前角色上一次分配的功能
            initLoadRoleFn();

        }

        function initLoadRoleFn(){
            //ajax请求当前角色上一次分配的功能id，默认勾选
            var xhr = new XMLHttpRequest() ;

            xhr.open("get","RoleAction.do?method=findFidsByRole&rid=${param.rid}",true);

            xhr.onreadystatechange = function(){
                if(xhr.readyState == 4 && xhr.status == 200){
                    doBack(xhr.responseText) ;
                }
            }

            xhr.send() ;

            function doBack(result){
               var fids = JSON.parse(result).jsonObject;
               //循环找到复选框中value in fids  默认选中
                for(var i=0;i<fids.length;i++){
                    var fid = fids[i];//这就是之前分配的一个fid
                    //需要在所有的复选框中找
                    var cbs = document.getElementsByName('fid');
                    for(var j=0;j<cbs.length;j++){
                        var cb = cbs[j] ;
                        if(cb.value == fid){
                            cb.checked = true;
                        }
                    }
                }
            }
        }

        function initLoadFn(){
            //网页加载完毕后，指定的操作
            //ajax发送请求，获得所有的功能信息
            var xhr = new XMLHttpRequest() ;//可以发送ajax形式的请求

            xhr.open('get','FnAction.do?method=list',false);

            xhr.onreadystatechange = function(){
                //ajax请求-响应过程分成5个状态，使用01234
                if(xhr.readyState == 4 && xhr.status == 200){
                    //获得了完整的，正确的响应
                    doBack(xhr.responseText);
                }
            }

            xhr.send();

            function doBack(result){
                var fns = JSON.parse(result).jsonObject ;
                var box = document.getElementById('menuBox') ;
                showFn(fns,box) ;//将后台响应回来的一堆菜单fns，显示在box这个标签中。

            }

            function showFn(fns,position){
                for(var i=0;i<fns.length;i++){
                    var fn = fns[i] ;
                    //每一个功能即使一个dt
                    var dt = document.createElement("dt");
                    dt.setAttribute('fid',fn.fid) ;
                    position.appendChild(dt) ;

                    var ul = document.createElement("ul");
                    var li1 = document.createElement("li");

                    dt.appendChild(ul);
                    ul.appendChild(li1);

                    li1.className = 'title';

                    li1.innerHTML = '<input type="checkbox" name="fid" value="'+fn.fid+'" />'+fn.fname ;
                    //当前菜单显示完毕，还需要显示其菜单
                    if(fn.children != null && fn.children.length > 0){
                        //有子菜单
                        var dd = document.createElement("dd") ;
                        position.appendChild(dd);
                        var dl = document.createElement('dl');
                        dd.appendChild(dl);
                        showFn(fn.children,dl) ;
                    }
                }
            }
        }
    </script>
</head>
<body>
    <h2 align="center">为【${param.rname}】设置功能</h2>
    <form action="RoleAction.do?method=setFns" method="post">
        <input type="hidden" name="rid" value="${param.rid}" >
        <h3 align="center">
            <button>保存</button>
        </h3>

        <dl id="menuBox" class="menuBox">

        </dl>
    </form>

</body>
</html>
