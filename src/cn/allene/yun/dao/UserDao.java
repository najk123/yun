package cn.allene.yun.dao;

import org.springframework.stereotype.Repository;

import cn.allene.yun.pojo.User;

@Repository
public interface UserDao {
	User findUser(User user) throws Exception;
	
	void addUser(User user) throws Exception; 
}
