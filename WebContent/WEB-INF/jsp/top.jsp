<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

	<nav class="navbar navbar-default navbar-fixed-top"
		style="background-color: #EFF4F8; margin-bottom: 0px; height: 10%">
	<div class="container">
		<div class="navbar-header">
			<span style="float: left;"><img
				src="${pageContext.request.contextPath }/img/logo@2x.png"
				height="50px" /></span> <a class="navbar-brand" href="index.action"
				style="margin-left: 5px;">网盘</a> <a
				class="navbar-brand" href="${pageContext.request.contextPath }/jsp/share.jsp" target="main">分享</a> <a
				class="navbar-brand" href="${pageContext.request.contextPath }/jsp/more.jsp" target="main">更多</a>
		</div>
		<div id="navbar" style="float: right;">
			<ul class="nav navbar-nav">
				<li><a href="#">超级会员 超低价</a></li>
				<li><a href="#about"><img
						src="${pageContext.request.contextPath }/img/titalpicture.jpg"
						height="20px" class="img-circle"> 用户为：${username }</a></li>
				<li><a>|</a></li>
				<li><a href="#contact" title="客服端下载">客服端下载</a></li>
				<li><a href="#" class="glyphicon glyphicon-bell" title="系统通知"></a></li>
				<li><a href="#" class="glyphicon glyphicon-list-alt"
					title="意见反馈"></a></li>
				<li><a href="#" class="glyphicon glyphicon-bookmark"
					title="皮肤中心"></a></li>
				<li><a href="#"><button type="button"
							class="btn btn-danger  btn-xs" title="会员中心">会员中心</button></a></li>

			</ul>
		</div>
	</div>
	</nav>
