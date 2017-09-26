<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'index.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link href="${pageContext.request.contextPath }/css/lightbox.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/css/layer.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/css/index.css" rel="stylesheet">
<script src="${pageContext.request.contextPath }/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath }/js/lightbox.js"></script>
<script src="${pageContext.request.contextPath }/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath }/js/layer.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/js/index.js"></script>
</head>
<body>
	<div class="content">
		<div class="top">
			<%@include file="top.jsp"%>
		</div>
		<div class="bottom" onclick="">
			<div class="left">
				<%@include file="menu.jsp"%>
			</div>
			<div class="right">
				<jsp:include page="main.jsp"></jsp:include>
			</div>
		</div>
 
	</div>
<div id="shareTab" style="visibility:visible; display: none;"> 
  <!-- Nav tabs -->
  <ul class="nav nav-tabs" role="tablist">
    <li role="presentation" class="active"><a href="#shareTable" onclick="return changeShareTab(1)" aria-controls="home" role="tab" data-toggle="tab">公共链接</a></li>
    <li role="presentation"><a href="#shareTable" onclick="return changeShareTab(2)" aria-controls="home" role="tab" data-toggle="tab">私密链接</a></li>
    <li role="presentation"><a href="#officeTable" onclick="return changeShareTab(-1)" aria-controls="home" role="tab" data-toggle="tab">失效链接</a></li>
  </ul>
 
  <!-- Tab panes -->
  <div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="shareTable">
	    <div class="panel panel-default">
		  <table class="table">
    		<thead>
    			<tr>
    				<th width="40%">分享文件</th>
    				<th width="25%">分享时间</th>
    				<th width="35%">分享链接</th>
    			</tr>
    		</thead>
    		<tbody>
    			
    		</tbody>
    	</table>
		</div>
    </div>
  </div>
</div>
<div id="fileTypeList" style="visibility:visible; display: none;"> 
  <!-- Nav tabs --> 
 <ul class="nav navbar-fixed-top nav-tabs"  role="tablist" style="background: white; margin-bottom: 40px; z-index: 0">
   <li role="presentation" class="active"><a href="#imageTab" onclick="return changeTypeTab('image')" aria-controls="imageTab" role="tab" data-toggle="tab">图片</a></li>
   <li role="presentation"><a href="#officeTab" onclick="return changeTypeTab('office')" aria-controls="officeTab" role="tab" data-toggle="tab">文档</a></li>
   <li role="presentation"><a href="#vidoTab" onclick="return changeTypeTab('vido')" aria-controls="vidoTab" role="tab" data-toggle="tab">视频</a></li>
   <li role="presentation"><a href="#audioTab" onclick="return changeTypeTab('audio')" aria-controls="audioTab" role="tab" data-toggle="tab">音乐</a></li>
   <li role="presentation"><a href="#fileTab" onclick="return changeTypeTab('file')" aria-controls="fileTab" role="tab" data-toggle="tab">其他</a></li>
 </ul>
  
 
  <!-- Tab panes -->
  <div class="tab-content" style="margin-top: 45px;">
    <div role="tabpanel" class="tab-pane active" id="imageTab">
	</div>
    <div role="tabpanel" class="tab-pane" id="officeTab"></div>
    <div role="tabpanel" class="tab-pane" id="vidoTab"></div>
    <div role="tabpanel" class="tab-pane" id="audioTab"></div>
    <div role="tabpanel" class="tab-pane" id="fileTab">55555555555</div>
  </div>
</div>
</body>
</html>
