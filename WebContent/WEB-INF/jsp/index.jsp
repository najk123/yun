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
<link href="${pageContext.request.contextPath }/css/layer.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath }/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath }/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath }/js/layer.js"></script>
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

#pathnav a, #list a {
	text-decoration: none;
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
		$.post("file/getFiles.action",
				{
					"path" : path
				},
				function(data) {
					if (data.success) {
						currentPath = path;
						$("#list").empty();
						// 				$("#list").attr("currentPath", newPath);
						// 				$("#navPath").append('<a href="#" onclick="return theClick(this)">' + newPath + '</a>');
						$.each(data.data,
								function() {
									$("#list").append(
										'<tr><td><input type="checkbox" aria-label="..."></td>'
									  + 	'<td width="60%"><a href="#" prePath="' + path + '" isFile="' + this.file + '" onclick="return preDirectory(this)">' + this.fileName + '</a></td>'
									  + 	'<td width="32px"><a href="#" class="glyphicon glyphicon-share"' + 'title="分享"></a></td>'
									  + 	'<td width="32px"><a href="#"' + 'class="glyphicon glyphicon-download-alt" title="下载"></a></td>'
									  + 	'<td width="32px"><a href="#"' + 'class="glyphicon glyphicon-option-horizontal" title="更多"></a></td>'
									  + 	'<td>'+ this.fileSize + '</td>'
									  + 	'<td>'+ this.lastTime+ '</td></tr>');
								});
					}
				});
	}

	function preDirectory(obj) {
		if ($(obj).attr("isfile") == "false") {
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

	function navPath(path, currentPath) {
		$("#navPath").append(
				'<a href="#" path="' + path
						+ '" onclick="return theClick(this)">&nbsp;'
						+ currentPath + '&nbsp;&#62;</a>');
	}

	function navClick(obj) {
		return false;
	}
	function upload(obj) {
		$("#input_file").click();
		return false;
	}

	/*
	重命名文件名
	 */
	function rename() {
		//var check = $("#list input[checked]");
		//调用
		var $check = $("input:checked");
		if ($check.length > 1 || $check.length <= 0) {
			alert("必须选择一个");
			$check.removeAttr("checked");
		} else {
			//alert($check.parent().next().children().text());
			layer.prompt({
				title : '重命名'
			}, function(destName, index) {
				$.post("file/renameDirectory.action", {
					"currentPath" : currentPath,
					"srcName" : $check.parent().next().children().text(),
					"destName" : destName
				}, function(data) {
					if (data.success == true) {
						layer.msg('重命名成功');
						layer.close(index);
						getFiles(currentPath);
					}
				});
			});
		}
		return false;
	}

	/*
	 删除文件 */
	function deleteall() {
		var $id = $("input:checked");
		var check = new Array();
		if ($id.length < 1) {
			alert("请选择至少一个");
		} else {
			$.each($id.parent().next().children(), function(i, n) {
				check[i] = $(this).text();
			});
			//alert($id.parent().next().children().text());

			$.ajax({
				type : "POST",
				url : "file/delDirectory.action",
				data : {
					"currentPath" : currentPath,
					"directoryName" : check
				},
				success : function(data) {
					layer.msg(data.msg);
					getFiles(currentPath);
				},
				traditional : true
			});
		}
		return false;
	}

	//新建文件夹 
	function buildfile() {
		layer.prompt({
			title : '新建文件夹'
		}, function(filename, index) {
			$.post("file/addDirectory.action", {
				"currentPath" : currentPath,
				"directoryName" : filename
			}, function(data) {
				if (data.success == true) {
					layer.msg('新建文件夹：' + filename + '成功');
					layer.close(index);
					getFiles(currentPath);
				}
			});
		});
		return false;
	}

	/* 移动文件及文件夹 */
	function moveto(){
		var $id = $("input:checked");
		var canmove = "yes";
		var check = new Array();
		var targetdirectorypath = "";
		if($id.length<1){
			alert("请选择需要移动的文件");
		}else{
			layer.open({
				  type: 2,			//0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
				  tilte: '移动到',
				  area: ['500px', '300px'],
				  shade: 0.6,			//遮罩透明度，默认：0.3
				  shadeclose: false,	//控制点击弹层外区域关闭，默认：false
				  fixed: false, 		//鼠标滚动时，层是否固定在可视区域，默认：true
				  maxmin: false,		//是否允许全屏最小化，默认：false
				  resize: false,		//是否允许拉伸，默认：true
				  anim: 0,				//0-6的动画形式，-1不开启，默认0
				  scrollbar: true,		//是否允许浏览器出现滚动条，默认：true
				  move: false,			//触发拖动的元素，默认是触发标题区域拖拽
				  closeBtn: 0,			//提供了两种风格的关闭按钮，可通过配置1和2来展示,如果不显示，则closeBtn: 0，默认：1
				  content: 'file/summarylist.action',
				  btn: ['确定', '取消'],
				  yes: function(index,layero){
							var tree = layer.getChildFrame('.chooseup > .path',index);
							targetdirectorypath = tree.html();
							
							$.each($id.parent().next().children(), function(i, n) {
								check[i] = $(this).text();
								var start = currentPath+"\\"+check[i];
								var end = "\\\\"+targetdirectorypath;
								if(end.length>=start.length && end.startsWith(start)){
									layer.msg("文件夹不能放在自身及其子文件夹内！");
									layer.close(index);
									canmove = "no";
									return false;
								}
							});
							if(canmove == "yes"){
								$.ajax({
									type : "POST",
									url : "file/moveDirectory.action",
									data : {
										"currentPath" : currentPath,
										"directoryName" : check,
										"targetdirectorypath" : targetdirectorypath
									},
									success : function(data) {
										layer.msg(data.msg);
										getFiles(currentPath);
									},
									traditional : true
								});
								layer.close(index);
							}
					  },
				  btn2: function(index,layero){
					  		layer.close(index);}
				});
		}
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
