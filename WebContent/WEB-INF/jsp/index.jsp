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
.file {
    position: relative;
    display: inline-block;
    background: #D0EEFF;
    border: 1px solid #99D3F5;
    border-radius: 4px;
    padding: 4px 12px;
    overflow: hidden;
    color: #1E88C7;
    text-decoration: none;
    text-indent: 0;
    line-height: 30px;
}
.file input {
    position: absolute;
    font-size: 100px;
    right: 0;
    top: 0;
    opacity: 0;
}
.file:hover {
    background: #AADFFD;
    border-color: #78C3F3;
    color: #004974;
    text-decoration: none;
}
</style>
<script type="text/javascript">
	var currentPath;
	$(document).ready(function() {
		getFiles("\\");
		countPercent();
	});
	//计算容量百分比
	function countPercent(){
		var countSize = $("#countSize").text();
		var totalSize = $("#totalSize").text();
		var countSizeNum = parseFloat(countSize.substr(0, countSize.length - 2));
		var totalSizeNum = parseFloat(totalSize.substr(0, totalSize.length - 2));
		totalSizeNum *= (1024 * 1024 * 1024);
		if(!isNaN(countSizeNum)){
			var unit = countSize.substr(countSize.length - 2);
			if(unit == "KB"){
				countSizeNum *= 1024;
			}else if(unit == "MB"){
				countSizeNum *= (1024 * 1024);
			}else if(unit == "GB"){
				countSizeNum *= (1024 * 1024 * 1024);
			}
		}else{
			countSizeNum = 0;
		}
		var percent = Math.round(countSizeNum * 100 / totalSizeNum) + "%";
		$("#sizeprogress").css("width", percent).attr("aria-valuemax", totalSizeNum).text(percent);
	}
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
		下载文件
	*/
	function downloadFile(){
		var $download = $("input:checked");
		var $startDownload = new Array();
		$.each($download.parent().next().children(),function(i,n){
			$startDownload = $(this).text();
		});
		if($download.length <= 0){
			alert("必须选择一个");
			$check.removeAttr("checked");
		}else{
			var url = "file/download.action";
			url += ("?currentPath=" + escape(currentPath));
			url += downPath;
			$(obj).attr("href", url);
			return true; 
		}
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
		}else{
		    //alert($check.parent().next().children().text());
			layer.prompt({title: '重命名'}, function(destName, index){
				  $.post("file/renameDirectory.action",{
					  "currentPath":currentPath,
					  "srcName":$check.parent().next().children().text(),
					  "destName":destName
				  },function(data){
					  if(data.success == true){
						  layer.msg('重命名成功');
						  layer.close(index);
						  getFiles(currentPath);
					  }
				  });
			});
		}
		return false;
	}

	function deleteall() {
		var $id = $("input:checked");
		var check = new Array();
		if($id.length < 1){
			alert("请选择至少一个");
		}else{
			$.each($id.parent().next().children(),function(i,n){
				check[i] = $(this).text();
			})
			//alert($id.parent().next().children().text());
			
			$.ajax({
				type:"POST",
				url:"file/delDirectory.action",
				data:{
					"currentPath":currentPath,
					"directoryName":check
				},
				success:function(data){
					layer.msg(data.msg);
					getFiles(currentPath);
				},
				traditional:true
			});
		}
		return false;
	}

	//新建文件夹 
 	function buildfile(){
		layer.prompt({title: '新建文件夹'}, function(filename, index){
			  $.post("file/addDirectory.action",{
				  "currentPath":currentPath,
				  "directoryName":filename
			  },function(data){
				  layer.msg('新建文件夹'+filename+'成功');
				  layer.close(index);
				  getFiles(currentPath);
			  });
		});
		return false;
	}
	
	//上传文件*upload()
	function upload(){
	  var files = document.getElementById("input").files;
          
	  if(files.length==0) {  
	      alert("请选择文件");  
	      return;  
	  }
	    //alert(paths.length);  
	    //我们遍历每一个文件对象  

	    //loading层
// 		layer.msg('正在上传中', {
// 		  icon: 16
// 		  ,shade: 0.5
// 		});
	    var index = layer.load(1, {
		  shade: [0.75,'#fff'] //0.1透明度的白色背景
		});
	    //我们可以预先定义一个FormData对象  
	    var formData=new FormData();  
	    for(var i=0;i<files.length;i++) {  
	        //将每个文件设置一个string类型的名字，放入到formData中，这里类似于setAttribute("",Object)  
	        formData.append("files",files[i]);  
	    }
	    formData.append("currentPath", currentPath);
	    $.ajax({     
	         url: 'file/upload.action',  
	         type: 'POST',  
	         cache: false,
	         //这个参数是jquery特有的，不进行序列化，因为我们不是json格式的字符串，而是要传文件  
	         processData: false,  
	         //注意这里一定要设置contentType:false，不然会默认为传的是字符串，这样文件就传不过去了  
	         contentType: false,  
	         data : formData,
			success : function(data) {
				if (data.success == true) {
// 					alert(data.success);
					getFiles(currentPath);
					layer.closeAll('loading');
				}
			},
	    });  
	}
	/* for(var i=0; i< files.length; i++){
		alert(input.files[i].name);
	}	 */
	//添加新功能
	//功能2
	//其他功能
	//测试
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
