<%--
  Created by IntelliJ IDEA.
  User: 12719
  Date: 2022/4/11
  Time: 16:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>续借申请页面</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
</head>
<body>
    <div class="layui-form layuimini-form">
        <input type="hidden" name="id" value="${lendList.id}">
        <input type="hidden" name="bookId" value="${lendList.bookId}">
        <input type="hidden" name="readerId" value="${sessionScope.user.id}">
        <div class="layui-form-item">
            <label class="layui-form-label">图书名称</label>
            <div class="layui-input-block">
                <input type="text" name="booName" value="${lendList.bookInfo.name}" class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">借阅日期</label>
            <div class="layui-input-block">
                <input type="text" name="lendDate" value="<fmt:formatDate value="${lendList.lendDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" pattern="yyyy-MM-dd" class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">应还日期</label>
            <div class="layui-input-block">
                <input type="text" name="dueDate" value="<fmt:formatDate value="${lendList.dueDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required">续借天数</label>
            <div class="layui-input-block">
                <input type="text" name="renewDays" placeholder="请输入续借天数" lay-verify="required" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label" required>续借原因</label>
            <div class="layui-input-block">
                <textarea name="remarks" lay-verify="required" placeholder="请输入内容"  class="layui-textarea"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveBtn">提交申请</button>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
    <script>
        layui.use(['form','laydate'], function () {
            var form = layui.form,
                layer = layui.layer,
                laydate = layui.laydate,
                $ = layui.$;
            //日期
            laydate.render({
                elem: '#date',
                trigger:'click'
            });
            //监听提交
            form.on('submit(saveBtn)', function (data) {
                var datas=data.field;//form单中的数据信息
                console.log(JSON.stringify(datas));
                //向后台发送数据提交添加
                $.ajax({
                    url:"renewSubmit",
                    type:"POST",
                    data:datas,
                    // contentType:'application/json',
                    // data:JSON.stringify(datas),
                    success:function(result){
                        if(result.code==0){//如果成功
                            layer.msg('申请成功,等待管理员审核',{
                                icon:6,
                                time:1500
                            },function(){
                                parent.window.location.reload();
                                var iframeIndex = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(iframeIndex);
                            })
                        }else{
                            layer.msg("申请失败");
                        }
                    }
                })
                return false;
            });

        });
    </script>
</body>
</html>
