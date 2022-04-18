<%--
  Created by IntelliJ IDEA.
  User: 12719
  Date: 2022/4/14
  Time: 14:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>续借申请审核</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <div class="demoTable">
            <div class="layui-form-item layui-form ">
                图书名称：
                <div class="layui-inline">
                    <input class="layui-input" name="bookName" id="bookName" autocomplete="off">
                </div>
                读者编号：
                <div class="layui-inline">
                    <input class="layui-input" name="readerNumber" id="readerNumber" autocomplete="off">
                </div>

                <button class="layui-btn" data-type="reload">搜索</button>
            </div>
        </div>


        <!--表单，查询出的数据在这里显示-->
        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs data-count-edit" lay-event="approval">批准</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="refuse">拒绝</a>
        </script>

    </div>
</div>
    <script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
    <script>
        layui.use(['form', 'table'],function () {
            var $ = layui.jquery,
                form = layui.form,
                table = layui.table;
            table.render({
                elem: '#currentTableId',
                url: '${pageContext.request.contextPath}/queryAllRenew',//查询数据
                height: 'full-125',
                method: 'post',
                defaultToolbar: ['filter', 'exports', 'print', {
                    title: '提示',
                    layEvent: 'LAYTABLE_TIPS',
                    icon: 'layui-icon-tips'
                }],
                cols: [[
                    {field: 'readerInfo.realName', minWidth: 150, title: '读者姓名', align: "center", templet: function (d) {
                            return d.readerInfo.realName;
                        }},
                    {field: 'readerInfo.readerNumber', minWidth: 100, title: '读者编号', align: "center", templet: function (d) {
                            return d.readerInfo.readerNumber;
                        }},
                    {field: 'bookInfo.name', minWidth: 100, title: '图书名称', align: "center", templet: function (d) {
                            return d.bookInfo.name;
                        }},
                    {field: 'lendList.lendDate', minWidth: 80, title: '借阅日期', align: "center", templet:"<div>{{layui.util.toDateString(d.lendList.lendDate,'yyyy-MM-dd HH:mm:ss')}}</div>",},
                    {field: 'lendList.dueDate', minWidth: 150, title: '应还日期', align: "center", templet:"<div>{{layui.util.toDateString(d.lendList.dueDate,'yyyy-MM-dd HH:mm:ss')}}</div>",},
                    {field: 'renewDays', minWidth: 200, title: '续借天数', align: "center"},
                    {field: 'remarks',  minWidth: 150, title: '续借原因', align: "center"},
                    {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
                ]],
                limits: [10, 15, 20, 25, 50, 100],
                limit: 15,  <!--默认显示15条-->
                page: true,
                skin: 'line',
                id:'testReload'
            });

            var $ = layui.$, active = {
                reload: function(){
                    var bookName = $('#bookName').val();
                    var readerNumber = $('#readerNumber').val();

                    //执行重载
                    table.reload('testReload', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        ,where: {
                            bookName: bookName,
                            readerNumber:readerNumber,

                        }
                    }, 'data');
                }
            };


            $('.demoTable .layui-btn').on('click', function(){
                var type = $(this).data('type');
                active[type] ? active[type].call(this) : '';
            });

            table.on('tool(currentTableFilter)', function (obj) {
                var data=obj.data;
                if (obj.event === 'approval') {  // 监听添加操作

                    console.log(data);
                    layer.confirm("你确定要批准" + data.readerInfo.realName + "的续借申请吗？", function (index) {
                        layer.close(index);
                        $.ajax({
                            url: "approval",
                            type: "GET",
                            data: {id: data.id, renewDays: data.renewDays, lid: data.lendList.id},
                            success: function (result) {
                                if (result.code == 0) {//如果成功
                                    layer.msg('批准成功', {
                                        icon: 6,
                                        time: 500
                                    }, function () {
                                        $('.layui-laypage-btn').click();
                                    });
                                } else {
                                    layer.msg(result.msg);
                                }
                            }
                        });
                    });
                } else if (obj.event === 'refuse') {  // 监听删除操作
                    console.log(data);
                    layer.confirm("你确定要拒绝" + data.readerInfo.realName + "的续借申请吗？", function (index) {
                        $.ajax({
                            url: "refuse",
                            type: "GET",
                            data: {id: data.id, lid: data.lendList.id},
                            success: function (result) {
                                if (result.code == 0) {//如果成功
                                    layer.msg('拒绝成功', {
                                        icon: 6,
                                        time: 500
                                    }, function () {
                                        $('.layui-laypage-btn').click();
                                    });
                                } else {
                                    layer.msg(result.msg);
                                }
                            }
                        })
                    });
                }
            });
        })


    </script>
</body>
</html>
