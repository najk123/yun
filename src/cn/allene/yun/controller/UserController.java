package cn.allene.yun.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.allene.yun.pojo.User;
import cn.allene.yun.service.FileService;
import cn.allene.yun.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {
	@Autowired
	private UserService userService;
	
	@Autowired
	private FileService fileService;
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request, User user){
		User exsitUser = userService.findUser(user);
		if(exsitUser != null){
			HttpSession session = request.getSession();
			session.setAttribute(FileService.NAMESPACE, exsitUser.getUsername());
			session.setAttribute("totalSize", exsitUser.getTotalSize());
			return "redirect:/index.action";
		}else{
			request.setAttribute("msg", "用户名或密码错误");
			return "login";
		}
	}
	@RequestMapping("/regist")
	public String regist(HttpServletRequest request, User user){
		if(user.getUsername() == null || user.getPassword() == null){
			return "regist";
		}else{
			boolean isSuccess = userService.addUser(user);
			if(isSuccess){
				fileService.addNewNameSpace(request, user.getUsername());
				return "login";
			}else{
				request.setAttribute("msg", "注册失败");
				return "regist";
			}
		}
	}
}
