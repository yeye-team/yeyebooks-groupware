package com.goodee.yeyebooks.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.UserMapper;
import com.goodee.yeyebooks.vo.User;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	
	public int login(String userId, String userPw) {
		return userMapper.selectLoginInfo(userId, userPw);
	}
	public User mypage(String userId) {
		return userMapper.selectUserInfo(userId);
	}
}
