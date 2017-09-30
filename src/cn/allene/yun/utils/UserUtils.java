package cn.allene.yun.utils;

import javax.servlet.http.HttpServletRequest;

import cn.allene.yun.pojo.User;

public class UserUtils {
	public static String getUsername(HttpServletRequest request){
		return (String) request.getSession().getAttribute(User.NAMESPACE);
	}
}
