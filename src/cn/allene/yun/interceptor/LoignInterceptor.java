package cn.allene.yun.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cn.allene.yun.service.FileService;

public class LoignInterceptor implements HandlerInterceptor {

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {

	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object object) throws Exception {
		String url = request.getRequestURI();
		if (url.indexOf("login.action") >= 0 || url.indexOf("regist.action") >= 0 || url.indexOf("share.action") >= 0 || url.indexOf("getShareFiles.action") >= 0 || url.indexOf("download.action") >= 0) {
			return true;
		}

		String username = (String) request.getSession().getAttribute(FileService.NAMESPACE);

		if (username != null) {
			return true;
		}

		response.sendRedirect("/yun/user/login.action");
		return false;
	}

}
