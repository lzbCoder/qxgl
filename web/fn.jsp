<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
    这个jsp的作用是展示功能列表
    展示成什么样子? 是页面的事
    展示什么数据？需要ajax技术发送请求从数据库端获取
-->
<html>
    <head>
        <title>功能列表</title>
        <style>
            ul,li{
                margin:0;
                padding:0;
                list-style: none;
            }
            dt,dd,dl{
                clear:both ;
            }

            .menuBox{
                width:510px;
                border:1px solid #ccc ;
                padding:10px;
            }
            dt{
                cursor: default;
                height: 30px;
            }
            dt#active{
                background:dodgerblue;
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

            .menuBox > dt:nth-child(1){
                font-weight: bold;
            }
        </style>

        <script>
            //网页加载完毕后，指定的操作
            window.onload = function () {
                //网页加载完毕后，ajax请求加载功能信息
                initLoadFn();

                //网页加载完毕，为root按钮增加点击事件
                addClickToRoot();

                //网页加载完毕，为child按钮增加点击事件
                addClickToChild();
            }

            /**
             * 方法一：ajax发送请求，获得所有的功能信息
             */
            function initLoadFn(){
                //ajax发送请求，获得所有的功能信息
                //1.创建xhr对象
                var xhr = new XMLHttpRequest();
                //2.打开一个请求
                xhr.open('get','FnAction.do?method=list',true);
                //4.监听状态
                xhr.onreadystatechange = function () {
                    //ajax请求-响应过程分为5个状态，使用01234
                    if(xhr.readyState == 4 && xhr.status == 200){
                        //当状态正确时，调用回调函数
                        doBack(xhr.responseText);
                    }
                }
                //5.发送请求
                xhr.send();

                //3.回调函数(请求响应回来之后调用的方法)
                function doBack(result) {
                    //result表示响应回来的数据
                    //result响应回来的数据
                    //拼装数据
                    var fns = JSON.parse(result).jsonObject;
                    /*
                        fns中装载着带结构的功能(子父关系)
                        我们先显示第一层(根菜单)数据
                        由于根菜单还包含子菜单
                        所以需要将子菜单那一层数据也显示完毕，第一层才算显示完毕。
                        也就是说，要显示一层，还需要显示第二层。
                        第一层和第二层的显示是一样的事情，所以：需要使用递归。
                    */
                    //将后台响应回来的一堆菜单fns，显示在box这个标签中。
                    var box = document.getElementById('menuBox');
                    showFn(fns,box);//将后台响应回来的一堆菜单fns，显示在box这个标签中。
                    //数据加载完毕，为菜单增加单击选中操作
                    addActiveToDt();
                    //数据加载为菜单增加展开合并的双击事件操作
                    addDoubleClickToDt();
                }
            }

            /**
             * 方法二：将获取到的信息展示到页面中
             * @param fns   要显示的功能(那一层)
             * @param position (dom/标签对象)表示显示的位置
             */
            function showFn(fns,position) {
                for(var i=0; i<fns.length; i++){
                    var fn = fns[i];
                    //每一个功能即是一个dt
                    var dt = document.createElement("dt");
                    position.appendChild(dt);

                    var ul = document.createElement("ul");
                    var li1 = document.createElement("li");
                    var li2 = document.createElement("li");
                    var li3 = document.createElement("li");

                    dt.appendChild(ul);
                    ul.appendChild(li1);
                    ul.appendChild(li2);
                    ul.appendChild(li3);

                    // 给li元素添加class属性 类似：<li class=""></li>
                    // 在js中给元素添加class属性使用的是className
                    li1.className = 'title';
                    li2.className = 'link';
                    li3.className = 'flag';

                    //给每个li元素中添加内容 类似：<li>内容</li>
                    li1.innerHTML = fn.fname;
                    li2.innerHTML = fn.fhref==''?'无':fn.fhref;
                    li3.innerHTML = fn.flag==1?'<span style="color: red">菜单</span>':'<span style="color: green">按钮</span>';

                    //当前菜单显示完毕，还需要显示其子菜单
                    //先判断是否有子菜单
                    if(fn.children != null && fn.children.length > 0){
                        //有子菜单
                        var dd = document.createElement("dd");
                        position.appendChild(dd);
                        var dl = document.createElement("dl");
                        dd.appendChild(dl);
                        showFn(fn.children,dl);
                    }
                }
            }

            /**
             * 方法三：为新建根功能按钮增加点击事件，增加可输入表单，保存/删除
             */
            function addClickToRoot() {
                var rootBtn = document.getElementById("rootBtn");
                rootBtn.onclick = function () {
                    /*
                      在指定的位置添加一套组件
                     */
                    //1.先获取menuBox组件的对象box
                    var box = document.getElementById('menuBox');
                    //3.为了保证每次点击rootBtn按钮后，都是一套新的组件，因此要在每次点击
                    //  rootBtn后，保证上一次的组件已经完成
                    var fname = document.getElementById('fname');
                    if(fname){
                        //证明有一个新建操作正在执行
                        alert('请先完成之前的操作');
                        return ;
                    }
                    //2.在box组件中原有内容的后面，添加上新的一套组件
                    box.innerHTML += '<dt>\n' +
                        '                <ul>\n' +
                        '                    <li class="title"><input id="fname" style="width: 120px" type="text"></li>\n' +
                        '                    <li class="link"><input id="fhref" style="width: 120px" type="text"><button id="saveBtn">√</button> <button id="deleteBtn">×</button></li>\n' +
                        '                    <li class="flag">\n' +
                        '                        <select id="flag" style="width: 60px">\n' +
                        '                            <option value="1">菜单</option>\n' +
                        '                            <option value="2">按钮</option>\n' +
                        '                        </select>\n' +
                        '                    </li>\n' +
                        '                </ul>\n' +
                        '            </dt>';

                    //完成上面新增组件中的删除×按钮
                    var deleteBtn = document.getElementById('deleteBtn');
                    deleteBtn.onclick = function () {
                        //点击的是删除按钮，但希望删除的是父级dt
                        //注意：js中删除元素时：只能先找到父元素，再删除它对应的子元素，不能直接删除该元素
                        // 因此先找到dt的父元素dl，然后删除dl的子元素dt
                        //this就是触发点击事件时的哪个标签(删除按钮)
                                //btn   li          ul         dt
                        var dt = this.parentNode.parentNode.parentNode;
                           //dl
                        dt.parentNode.removeChild(dt);
                    }

                    //完成上面新增组件中的保存√按钮
                    var saveBtn = document.getElementById('saveBtn');
                    saveBtn.onclick = function () {
                        //点击保存按钮，将输入框的3个信息 通过ajax传递给后台程序。
                        var fname = document.getElementById('fname');
                        var flag = document.getElementById('flag');
                        var fhref = document.getElementById('fhref');
                        var pid = -1;
                        saveFn(fname.value,flag.value,fhref.value,pid);
                    }
                }
            }

            /**
             * 方法四：给新建子功能添加点击事件
             */
            function addClickToChild(){
                var childBtn = document.getElementById("childBtn");
                childBtn.onclick = function () {
                    //先判断是否有未完成操作
                    var fname = document.getElementById("fname");
                    if(fname){
                        //fname新建组件存在，证明有一个新建操作未完成
                        alert("请完成之前的操作");
                        return ;
                    }
                    //判断是否选中了参考的父级功能
                    var active = document.getElementById("active");
                    if(!active){
                        //未选中参考的父级功能
                        alert("请选择父级功能");
                        return;
                    }
                    //参考active，增加新建表单
                    //判断active对应的菜单是否有子菜单，是否有紧邻的<dd>
                    var next = active.nextElementSibling; //找到下一个兄弟元素
                    //注意：js中判断标签时，使用标签名字大写的形式
                    if(next != null && next.tagName == "DD"){
                        //有相邻的标签，而且还是一个dd标签，证明有子菜单，增加dt
                        var dl = next.children[0];  //dd的第一个子菜单
                        dl.innerHTML += '<dt>\n' +
                            '                        <ul>\n' +
                            '                            <li class="title"><input id="fname" style="width:120px;" /></li>\n' +
                            '                            <li class="link"><input id="fhref" style="width:120px;" /> <button id="saveBtn">√</button> <button id="deleteBtn">×</button></li>\n' +
                            '                            <li class="flag">\n' +
                            '                                <select style="width:60px;" id="flag">\n' +
                            '                                    <option value="1">菜单</option>\n' +
                            '                                    <option value="2">按钮</option>\n' +
                            '                                </select>\n' +
                            '                            </li>\n' +
                            '                        </ul>\n' +
                            '                    </dt>';
                    }else{ //没有相邻的dd，没有子菜单。需要新增加一套标签<dd><dl><dt>
                        if(next == null){
                            //没有相邻的标签，证明当前的父级菜单是最后一个菜单。
                            active.parentNode.innerHTML += '<dd><dl><dt>\n' +
                                '                        <ul>\n' +
                                '                            <li class="title"><input id="fname" style="width:120px;" /></li>\n' +
                                '                            <li class="link"><input id="fhref" style="width:120px;" /> <button id="saveBtn">√</button> <button id="deleteBtn">×</button></li>\n' +
                                '                            <li class="flag">\n' +
                                '                                <select id="flag" style="width:60px;">\n' +
                                '                                    <option value="1">菜单</option>\n' +
                                '                                    <option value="2">按钮</option>\n' +
                                '                                </select>\n' +
                                '                            </li>\n' +
                                '                        </ul>\n' +
                                '                    </dt></dl></dd>';
                        }else{
                            //next 是一个相邻的同级别的菜单<dt>,需要在这个next之前增加一套子标签
                            var dd = document.createElement("dd");
                            next.parentNode.insertBefore(dd,next);
                            dd.innerHTML += '<dl><dt>\n' +
                                '                        <ul>\n' +
                                '                            <li class="title"><input id="fname" style="width:120px;" /></li>\n' +
                                '                            <li class="link"><input id="fhref" style="width:120px;" /> <button id="saveBtn">√</button> <button id="deleteBtn">×</button></li>\n' +
                                '                            <li class="flag">\n' +
                                '                                <select style="width:60px;" id="flag">\n' +
                                '                                    <option value="1">菜单</option>\n' +
                                '                                    <option value="2">按钮</option>\n' +
                                '                                </select>\n' +
                                '                            </li>\n' +
                                '                        </ul>\n' +
                                '                    </dt></dl>';
                        }
                    }
                    //无论哪种请求，都增加了响应的新建组件，需要提供保存和移除处理(增加2个事件)
                    //完成上面新增组件中的删除×按钮
                    var deleteBtn = document.getElementById('deleteBtn');
                    deleteBtn.onclick = function () {
                        //点击的是删除按钮，但希望删除的是父级dt
                        //注意：js中删除元素时：只能先找到父元素，再删除它对应的子元素，不能直接删除该元素
                        // 因此先找到dt的父元素dl，然后删除dl的子元素dt
                        //this就是触发点击事件时的哪个标签(删除按钮)
                        //btn   li          ul         dt
                        var dt = this.parentNode.parentNode.parentNode;
                        //dl
                        dt.parentNode.removeChild(dt);
                    }

                    //完成上面新增组件中的保存√按钮
                    var saveBtn = document.getElementById('saveBtn');
                    saveBtn.onclick = function () {
                        //点击保存按钮，将输入框的3个信息 通过ajax传递给后台程序。
                        var fname = document.getElementById('fname');
                        var flag = document.getElementById('flag');
                        var fhref = document.getElementById('fhref');
                        var pid = active.getAttribute('fid');
                        saveFn(fname.value,flag.value,fhref.value,pid);
                    }
                }
            }

            /**
             * 方法五：实现保存功能
             * ajax请求传递四个参数
             */
            function saveFn(fname,flag,fhref,pid) {
                //1.创建xhr对象
                var xhr = new XMLHttpRequest();
                //2.打开一个请求
                xhr.open('post','FnAction.do?method=save',true);
                //3.定义回调函数
                function doBack() {
                    alert('保存完毕');
                    //刷新表单部分
                    document.getElementById('fname').parentNode.innerHTML = fname;
                    document.getElementById('flag').parentNode.innerHTML = flag==1?'<span style="color: red">菜单</span>':'<span style="color: green">按钮</span>';
                    document.getElementById('fhref').parentNode.innerHTML = fhref==''?'无':fhref;
                }
                //4.监测响应状态
                xhr.onreadystatechange = function () {
                    if(xhr.readyState==4 && xhr.status==200){
                        doBack(xhr.responseText);
                    }
                }
                //5.发送请求
                //注意：在send里面发送参数，需要再设置一个请求头
                xhr.setRequestHeader('content-type','application/x-www-form-urlencoded');
                xhr.send('fname='+fname+'&fhref='+fhref+'&flag='+flag+'&pid='+pid);
            }

            /**
             * 方法六：为菜单增加单击选中操作
             */
            function addActiveToDt() {
                var dts = document.getElementsByTagName("dt");
                for(var i=0; i<dts.length; i++){
                    var dt = dts[i];
                    dt.onclick = function () {
                        var active = document.getElementById("active");
                        if(active){
                            active.id = ''; //确保每次只会有一个dt(菜单)被选中
                        }
                        this.id = 'active' ;
                    }
                }
            }

            /**
             * 方法七：为菜单增加展开合并的双击事件操作
             */
            function addDoubleClickToDt() {
                //找到所有dt
                var dts = document.getElementsByTagName("dt");
                for(var i=0; i<dts.length; i++){
                    var dt = dts[i];
                    dt.ondblclick = function () {
                        //双击菜单，展开合并子菜单相邻<dd>
                        var next = this.nextElementSibling;
                        if(next != null && next.tagName == "DD"){
                            //找到了子菜单，展开或者合并 css-> style="display:none/block"
                            var style1 = getComputedStyle(next); //获得样式
                            var style2 = next.style;  //设置样式
                            if(style1.display == 'none'){
                                //当前合并，需要展开
                                style2.display = 'block';
                            }else{
                                //当前展开，需要合并(消失)
                                style2.display = 'none';
                            }
                        }
                    }
                }
            }

        </script>
    </head>

    <body>
        <!-- 标签结构/数据结构/对象结构 -->
        <button id="rootBtn">新建根功能</button> <button id="childBtn">新建子功能</button>
        <dl id="menuBox" class="menuBox">
            <dt>
                <ul>
                    <li class="title">功能管理</li>
                    <li class="link">链接</li>
                    <li class="flag">类型</li>
                </ul>
            </dt>
            <%--<dt>
                <ul>
                    <li class="title">权限管理</li>
                    <li class="flag">菜单</li>
                    <li class="link">链接</li>
                </ul>
            </dt>
            <dd>
                <dl>
                    <dt>
                        <ul>
                            <li class="title">用户管理</li>
                            <li class="flag">菜单</li>
                            <li class="link">链接</li>
                        </ul>
                    </dt>
                    <dt>
                        <ul>
                            <li class="title">角色管理</li>
                            <li class="flag">菜单</li>
                            <li class="link">链接</li>
                        </ul>
                    </dt>
                    <dt>
                        <ul>
                            <li class="title">功能管理</li>
                            <li class="flag">菜单</li>
                            <li class="link">链接</li>
                        </ul>
                    </dt>
                </dl>
            </dd>

            <dt>
                <ul>
                    <li class="title">基本信息管理</li>
                    <li class="flag">菜单</li>
                    <li class="link">链接</li>
                </ul>
            </dt>
            <dd>
                <dl>
                    <dt>
                        <ul>
                            <li class="title">商品管理</li>
                            <li class="flag">菜单</li>
                            <li class="link">链接</li>
                        </ul>
                    </dt>
                    <dd>
                        <dl>
                            <dt>
                                <ul>
                                    <li class="title">商品-新建</li>
                                    <li class="flag">按钮</li>
                                    <li class="link">链接</li>
                                </ul>
                            </dt>
                            <dt>
                                <ul>
                                    <li class="title">商品-删除</li>
                                    <li class="flag">按钮</li>
                                    <li class="link">链接</li>
                                </ul>
                            </dt>
                        </dl>
                    </dd>
                </dl>
            </dd> --%>


<%--            <dt>--%>
<%--                <ul>--%>
<%--                    <li class="title"><input style="width: 120px" type="text"></li>--%>
<%--                    <li class="link"><input style="width: 120px" type="text"><button>√</button><button>×</button></li>--%>
<%--                    <li class="flag">--%>
<%--                        <select style="width: 60px">--%>
<%--                            <option value="1">菜单</option>--%>
<%--                            <option value="2">按钮</option>--%>
<%--                        </select>--%>
<%--                    </li>--%>
<%--                </ul>--%>
<%--            </dt>--%>

        </dl>
    </body>

</html>
