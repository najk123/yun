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
<link href="${pageContext.request.contextPath }/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath }/css/lightbox.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath }/css/layer.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath }/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath }/js/lightbox.js"></script>
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
		//全选
		$("#checkAll").click(function () {
				$("input[name='check_name']").prop("checked", $(this).prop("checked"));
// 				$("#operation").toggle();
				if($(this).prop("checked")){
					$("#operation").show();
				}else{
					$("#operation").hide()
				}
		});
		//显示隐藏操作栏
		$("#operation").hide()
	});
	function selectCheckbox(){
		$inputs = $("input[name='check_name']");
		var len = $inputs.filter(":checked").length;
		$("#checkAll").prop("checked", len == $inputs.length);
		$("#operation").show();
		if(len == 0){
			$("#operation").hide();
		}
	}
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
				$("#checkAll").prop("checked",false);
// 				$("#list").attr("currentPath", newPath);
// 				$("#navPath").append('<a href="#" onclick="return theClick(this)">' + newPath + '</a>');
				$.each(data.data, function() {
					$("#list").append('<tr><td><input onclick="selectCheckbox()" name="check_name" type="checkbox" aria-label="..."></td>' +
						'<td width="60%"><a href="#" prePath="' + path +'" fileType="' + this.fileType +'" onclick="return openFile(this)"><span class="glyphicon glyphicon-'+this.fileType+'" style="margin-right: 10px"></span>' + this.fileName + '</a></td>' +
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
	function downloadFile(obj){
		var $download = $("input:checked");
		var downPath = "";
		$.each($download.parent().next().children(),function(i,n){
			downPath += "&downPath=" + $(this).text();
		});
		if($download.length <= 0){
			alert("必须选择一个");
			$check.removeAttr("checked");
		}else{
			var url = "file/download.action";
			 url += ("?currentPath=" + encodeURI(currentPath));
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
		var $check = $("input[name='check_name']:checked");
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

	/*
	 删除文件 */
	function deleteall() {
		var $id = $("input[name='check_name']:checked");
		var check = new Array();
		if($id.length < 1){
			alert("请选择至少一个");
		}else{
			$.each($id.parent().next().children(),function(i,n){
				check[i] = $(this).text();
			});
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
					getFiles(currentPath);
					layer.closeAll('loading');
				}
			},
	    });  
	}
	//分享
	function share(obj){
		var $check = $("input:checked").not($("#checkAll"));
		if($check.length < 1){
			alert("请选择至少一个");
		}else{
			var shareFiles = $check.parent().next().children();
			var shareFile = new Array();
			for(var i = 0; i < shareFiles.length; i++){
				shareFile[i] = $(shareFiles[i]).text();
			}
			$.ajax({
				type:"POST",
				url:"shareFile.action",
				data:{
					"currentPath":currentPath,
					"shareFile":shareFile
				},
				traditional:true
				,success:function(data){
					layer.open({
						  title: '分享',
						  content: '<input id="url" value="' + joinUrl(data.data) + '" class="form-control" readonly="readonly"/>'
						  ,btn: ['复制到粘贴板', '返回'],
						  area: ['500px', '200px']
						  ,yes: function(index, layero){ 
						    //按钮【按钮一】的回调
							  copyUrl($("#url"));
						  },end: function(index, layero){ 
							$("input:checkbox").prop("checked", false);  
						  } 
					});
				}
			});
		}
		return false;
	} 
	function copyUrl(obj){
		  obj.select();
		  var successful = document.execCommand('copy');
		  if(successful){
			  layer.tips('复制成功', obj, {tips: 3});
		  }
	}
	function joinUrl(url){
		var host = window.location.href;
		host = host.substring(0, host.indexOf("/yun") + 5);
		return host + "share.action?shareUrl=" + url;
	}
	/* for(var i=0; i< files.length; i++){
		alert(input.files[i].name);
	}	 */
	//添加新功能
	//功能2
	//其他功能
	//测试

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
// 							alert(targetdirectorypath + "---" + currentPath);
// 								\\music  music
// 								\music\aaa  music\aaa
							if(currentPath == ("\\\\" + targetdirectorypath)){
								layer.msg("不能移动到当前目录");
								layer.close(index);
								canmove = "no";
								return false;
							}
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

	function searchFile(obj){
		var reg = $(obj).prev().val();
		if(reg.trim() == "" || reg.trim() == null){
// 			if(currentPath != "\\"){
// 				window.location.reload();
				getFiles(currentPath); 
// 			}
		}else{
			$("#list").empty();
			$.post("file/searchFile.action", {
				"reg" : reg,
				"currentPath" : currentPath
			}, function(data) {
				if (data.success) {
// 					currentPath = path;
					$("#checkAll").prop("checked",false);
					$.each(data.data, function() {
						$("#list").append('<tr><td><input onclick="selectCheckbox()" name="check_name" type="checkbox" aria-label="..."></td>' +
							'<td width="60%"><a href="#" prePath="' + this.prePath +'" fileType="' + this.fileType +'" onclick="return openFile(this)">' + this.fileName + '</a></td>' +
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
	}
	function openMyShare(){
		changeShareTab(1);
		layer.open({ 
			  type: 1, 
			  area: ['850px', '450px'],
			  title:false,
			  content: $("#shareTab")
			});
	}
	function changeShareTab(order){
		$.post("searchShare.action",{
			  "status":order
		  },function(data){
			  if(data.success){
				  $("#shareTable tbody").empty();
				  $.each(data.data, function(){
					    $("#shareTable tbody").append('<tr><td><span class="glyphicon glyphicon-'+this.fileType+'" style="margin-right: 10px"></span>'+this.fileName+'</td><td>'+this.lastTime+'</td><td><input id="url" onFocus="copyUrl(this)" value="' + joinUrl(this.url) + '" class="form-control" readonly="readonly"/></td></tr>');
				  });
				   
			  }
		  }
					
		);
		return false;
	}
	function searchFileType(type){
		var tabName = type + "Tab";
		$("#fileTypeList li").has("a[aria-controls='"+tabName+"']").addClass("active").siblings().removeClass("active");
		$("#"+tabName).addClass("active").siblings().removeClass("active");
		changeTypeTab(type);
		layer.open({ 
			  type: 1, 
			  zIndex : 80,
			  area: ['890px', '450px'],
			  title:false,
			  content: $("#fileTypeList")
			});
		return false;
	}
	function changeTypeTab(type){
		$.post("file/searchFile.action", {
			"regType" : type
		}, function(data) {
			if (data.success) {
				var typeName = type+"Tab";
				$("#"+ typeName).empty();
				$.each(data.data, function() {
					if(type == "image"){
						var url = encodeURI('currentPath='+this.prePath+'&fileType='+this.fileType+'&fileName='+this.fileName);
						$("#"+ typeName).append('<a href="file/openFile.action?'+url+'" data-lightbox="roadtrip" title="'+this.fileName+'"><img alt="'+this.fileName+'" style="margin: 10px" src="file/openFile.action?'+url+'" width="150" height="150"></a>')
					}else{
						
					}
				});
			}
		});
		return false;
	}
	function openFile(obj) {
		var fileType = $(obj).attr("filetype")
		var fileName = $(obj).text();
		if (fileType == "folder-open") {
			var prePath = $(obj).attr("prePath");
			var path = prePath + "\\" + fileName;
			getFiles(path);
			navPath(path, fileName); 
		} else if(fileType.indexOf("image") >= 0){
				var url = encodeURI('currentPath='+currentPath+'&fileType='+fileType+'&fileName='+fileName);
				$(obj).attr({"href":"file/openFile.action?"+url,"data-lightbox":"test","data-title":fileName});
				return true;
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
