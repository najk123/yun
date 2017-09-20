package cn.allene.yun.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.allene.yun.service.FileService;
import cn.allene.yun.service.UserService;

@Controller
public class IndexController {
	@Autowired
	private UserService userService;
	
	@RequestMapping("/index")
	public String index(HttpServletRequest request){
		String username = (String) request.getSession().getAttribute(FileService.NAMESPACE);
		String countSize = userService.getCountSize(username);
		request.setAttribute("countSize", countSize);
		return "index";
	}
}
