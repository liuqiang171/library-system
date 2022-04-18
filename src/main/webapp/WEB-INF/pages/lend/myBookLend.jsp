<%--
  Created by IntelliJ IDEA.
  User: 12719
  Date: 2022/4/5
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的借阅</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
</head>
<body>
    <div class="layuimini-container">
    <div class="layuimini-main">

        <div class="layuimini-main">
            <div class="demoTable">
                <div class="layui-form-item layui-form ">
                    图书名称
                    <div class="layui-inline">
                        <input class="layui-input" name="bookName" id="bookName" autocomplete="off">
                    </div>
                    状态
                    <div class="layui-inline">
                        <select class="layui-input" name="status" id="status" readonly>
                            <option value=""></option>
                            <option value="0">已超时</option>
                            <option value="1">借阅中</option>
                        </select>
                    </div>
                    <button class="layui-btn" data-type="reload">搜索</button>
                </div>
            </div>
        </div>
<%--        <script type="text/html" id="toolbarDemo">--%>
<%--            <div class="layui-btn-container">--%>
<%--                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add"> 借书 </button>--%>
<%--                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="back"> 还书 </button>--%>
<%--                <button class="layui-btn layui-btn-sm layui-btn-danger data-delete-btn" lay-event="delete"> 删除 </button>--%>
<%--            </div>--%>
<%--        </script>--%>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            {{# if(new Date(d.dueDate) > new Date() && d.backType == 4 ){ }}
            <a class="layui-btn layui-btn-normal layui-btn-xs data-count-edit" lay-event="apply">申请续借</a>
            {{# }if(new Date(d.dueDate) > new Date() && d.backType == 5 ){ }}
            <span class="layui-badge layui-bg-gray">审核中</span>
            {{# }if(new Date(d.dueDate) > new Date() && d.backType == 6 ){ }}
            <div><a href="javascript:void(0)" style="color:#3cee30">审核通过</a></div>
            {{# }if(new Date(d.dueDate) > new Date() && d.backType == 7 ){ }}
            <div><a href="javascript:void(0)" style="color:#ee2226">未通过审核</a></div>
            {{# }if(new Date(d.dueDate) <= new Date() ){ }}
            <div><a href="javascript:void(0)" style="color:#ee2226">请先归还图书</a></div>
            {{# } }}
        </script>

    </div>
</div>
    <script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
    <script>
        layui.use(['form','table'],function () {
            var $ = layui.jquery,
                form = layui.form,
                table = layui.table;
            var rid = ${sessionScope.user.id};

            table.render({
                elem: '#currentTableId',
                url: '${pageContext.request.contextPath}/lendListByOrderId',
                // toolbar: '#toolbarDemo',
                height: 'full-125',
                where: {
                  rid: rid
                },
                defaultToolbar: ['filter', 'exports', 'print', {
                    title: '提示',
                    layEvent: 'LAYTABLE_TIPS',
                    icon: 'layui-icon-tips'
                }],
                cols: [[
                    //{field: 'id', width: 100, title: 'ID', sort: true},
                    {templet: '<div><a href="javascript:void(0)" style="color:#00b7ee">{{d.bookInfo.name}}</a></div>',
                        minWidth: 100, title: '图书名称', align: 'center'},
                    {templet:"<div>{{layui.util.toDateString(d.lendDate,'yyyy-MM-dd HH:mm:ss')}}</div>", minWidth: 160, title: '借阅时间', align: 'center'},
                    {field: 'dueDate', minWidth: 160, title: '应还时间', align: 'center'},
                    {title: '状态', minWidth: 100, align: 'center', templet: function (item) {
                            if(new Date(item.dueDate) > new Date()){
                                return '<div><a href="javascript:void(0)" style="color:#5fee40">借阅中</a></div>'
                            } else {
                                return '<div><a href="javascript:void(0)" style="color:#ee2226">已超时</a></div>'
                            }
                        }},
                    {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
                ]],
                limits: [10, 15, 20, 25, 50, 100],
                limit: 15,
                page: true,
                skin: 'line',
                id:'testReload'
            });
            var $ = layui.$, active = {
                reload: function(){
                    var bookName = $('#bookName').val();
                    var status = $('#status').val();
                    //执行重载
                    table.reload('testReload', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        ,where: {
                            rid: rid,
                            bookName: bookName,
                            status: status
                        }
                    }, 'data');
                }
            };


            $('.demoTable .layui-btn').on('click', function(){
                var type = $(this).data('type');
                active[type] ? active[type].call(this) : '';
            });
            table.on('tool(currentTableFilter)', function (obj) {
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event; //获得 lay-event 对应的值
                if(layEvent === 'apply'){
                    var index = layer.open({
                        title: '续借申请',
                        type: 2,
                        shade: 0.2,
                        maxmin:true,
                        shadeClose: true,
                        area: ['60%', '60%'],
                        content: '${pageContext.request.contextPath}/renewPage?id='+data.id,
                    });
                    $(window).on("resize", function () {
                        layer.full(index);
                    });
                }

            });

        });


    </script>
</body>
</html>
