package cn.allene.yun.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.allene.yun.dao.UserDao;
import cn.allene.yun.pojo.User;

@Service
public class UserService {
	@Autowired
	private UserDao userDao;

	public boolean findUser(User user) {
		try {
			User exsitUser = userDao.findUser(user);
			if(exsitUser == null){
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean addUser(User user){
		try {
			userDao.addUser(user);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
