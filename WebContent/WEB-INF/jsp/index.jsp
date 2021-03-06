<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
<link href="${pageContext.request.contextPath }/css/bootstrap.min.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath }/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath }/js/bootstrap.min.js"></script>
<style>
.content {
	width: 100%;
	height: 100%;
}

.top {
	height: 10%;
	width: 100%;
}

.bottom {
	width: 100%;
}

.left {
	width: 15%;
	height: 90%;
	float: left;
}

.right {
	width: 85%;
	height: 90%;
	float: right;
}

#subMenu {
	display: none;
	position: relative;
	margin-top: 0px;
}

#subMenu a {
	font-size: 15px;
	text-decoration: none;
}

#menubutton a {
	padding-top: 9px;
	height: 40px;
	width: 70px;
	font-size: 12px;
}

#menubutton div {
	text-align: center;
}

.item {
	text-decoration: none;
	display: none;
}

.ul li:hover {
	background: #E3E8EB;
	cursor: pointer;
}
</style>
<script type="text/javascript">
	var currentPath;
	$(document).ready(function() {
		getFiles("\\");
	});
	function getFiles(path) {
// 		var oldPath = $("#list").attr("currentPath");
// 		var newPath = oldPath + "\\" + path;
		$.post("file/getFiles.action", {
			"path" : path
		}, function(data) {
			if (data.success) {
				currentPath = path;
				$("#list").empty();
// 				$("#list").attr("currentPath", newPath);
// 				$("#navPath").append('<a href="#" onclick="return theClick(this)">' + newPath + '</a>');
				$.each(data.data, function() {
					$("#list").append('<tr><td><input type="checkbox" aria-label="..."></td>' +
						'<td width="60%"><a href="#" prePath="' + path +'" isFile="' + this.file +'" onclick="return preDirectory(this)">' + this.fileName + '</a></td>' +
						'<td width="32px"><a href="#" class="glyphicon glyphicon-share"' +
						'title="分享"></a></td>' +
						'<td width="32px"><a href="#"' +
						'class="glyphicon glyphicon-download-alt" title="下载"></a></td>' +
						'<td width="32px"><a href="#"' +
						'class="glyphicon glyphicon-option-horizontal" title="更多"></a></td>' +
						'<td>' + this.fileSize + '</td>' +
						'<td>' + this.lastTime + '</td></tr>');
				});
			}
		});
	}
	
	function preDirectory(obj){
		if($(obj).attr("isfile") == "false"){
			var prePath = $(obj).attr("prePath");
			var currentPath = $(obj).text();
			var path = prePath + "\\" + currentPath;
			getFiles(path);
			navPath(path, currentPath);
		}
		return false;
	}
	
	function theClick(obj) {
		getFiles($(obj).attr("path"));
		$(obj).nextAll().remove();
		return false;
	}
	
	function navPath(path, currentPath){
		$("#navPath").append('<a href="#" path="' + path +'" onclick="return theClick(this)">&nbsp;' + currentPath + '&nbsp;&#62;</a>');
	}
	
	function navClick(obj){
		return false;
	}
	function upload(obj){
		$("#input_file").click();
		return false;
	}
</script>
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
				<%@include file="main.jsp"%>
			</div>
		</div>

	</div>
</body>
</html>
