<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>批量导入用户</title>
        <style>
            .userImportBox{
                width: 400px;
                background: #cfc;
                border: 2px solid #ccc;
                border-radius: 10px;
                margin: 50px auto;
                padding-bottom: 20px;
            }
            .userImportBox tr{
                height: 40px;
            }
        </style>
    </head>
    <body>
        <div class="userImportBox">
            <h2 align="center">导入用户</h2>
            <form action="UserAction.do?method=saves" method="post" enctype="multipart/form-data">
                <table align="center">
                    <tr>
                        <td><input type="file" name="excel" /></td>
                    </tr>
                    <tr>
                        <td><a href="UserAction.do?method=down">模板下载</a></td>
                    </tr>
                    <tr>
                        <td><button>提交</button></td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
