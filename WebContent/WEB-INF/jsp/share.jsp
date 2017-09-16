<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'more.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

	<link href="${pageContext.request.contextPath }/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body style="background-color: #EDF1F5;">
		
   <div>
   		<table style="align-content: center; background-color: white; ">
   			<tr>
   				<td class="col-md-3" style="border-right: #EDF1F5;">
   					<div style="height: 40px; margin-top: 20px;">
   						<span class="col-md-5 "><a href="#" class="glyphicon glyphicon-comment" style="font-size: 15px;"> 会话</a></span>
   						<span class="col-md-2">|</span>
   						<span class="col-md-5"><a href="#" class="glyphicon glyphicon-user" style="font-size: 15px;"> 好友</a></span>
   						<br />
   					</div>
   					
   				</td>
   				<td width="100" bgcolor="lightgrey"></td>
   				<td class="col-md-11" rowspan="3" style="border-left: #EDF1F5 solid 1px;">
   					<img src="${pageContext.request.contextPath }/img/share.png"
					width="400px" /> <input type="button" value="给好友发信息" style="margin-left: 160px;"></input>
   				</td>
   			</tr>
   			<tr>
   				<td>
   					<div style="height: 500px;">
   						<p style="margin-left: 80px;">还没有会话结束</p>
   					</div></td>
   			</tr>
   			<tr>
   				<td>
   					<div style="height: 40px;">
   						<span class="col-md-4"><a href="#" style="font-size: 10px;" class="btn btn-primary" data-toggle="modal" data-target="#group">创建群组</a></span>
   						<span class="col-md-4"><a href="#" style="font-size: 10px;" class="btn btn-primary" data-toggle="modal" data-target="#addFriendModal">添加好友</a></span>
   						<span class="col-md-4"><a href="#" style="font-size: 10px;" class="btn btn-primary" data-toggle="modal" data-target="#set">设置</a></span>
   						<br />
   					</div>
   				</td>
   			</tr>
   		</table>
    </div>
  
  <!--
  	作者：624801304@qq.com
  	时间：2017-09-12
  	描述：添加群组模态框
  -->
  <div class="modal fade" id="group" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">创建群组</h4>
		      </div>
		      <div class="modal-body">
		        <p>你还没有添加好友呢，可以先建群然后在邀请好友加入~</p>
		        <button type="button" class="btn btn-primary">创建群组</button>
		      </div>
		    </div>
		  </div>
		</div>
		
		<!--
        	作者：624801304@qq.com
        	时间：2017-09-12
        	描述：添加好友模态框
        -->
		<div class="modal fade" id="addFriendModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4 class="modal-title" id="exampleModalLabel">添加好友</h4>
					</div>
					<div class="modal-body">
						<form>
							<div class="form-group">
								<label for="recipient-name" class="control-label">输入百度账号添加好友:</label>
								<input type="text" class="form-control" id="recipient-name">
								<!--<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
								<button type="submit" class="btn btn-primary">搜索</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>

  <!--
  	作者：624801304@qq.com
  	时间：2017-09-12
  	描述：添加设置模态框
  -->
  <div class="modal fade" id="set" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">设置</h4>
		      </div>
		      <div class="modal-body">
		        <p>用户名</p>
		        <button type="button" class="btn btn-primary">确定</button>
		      </div>
		    </div>
		  </div>
		</div>
		
    
    		<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
		<script src="${pageContext.request.contextPath }/js/jquery-1-4-2.min.js"></script>
		
		<!-- Include all compiled plugins (below), or include individual files as needed -->
		<script src="${pageContext.request.contextPath }/js/bootstrap.min.js"></script>
	</body>
</html>
