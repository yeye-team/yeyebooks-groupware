package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.UserFileMapper;
import com.goodee.yeyebooks.mapper.UserMapper;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	@Autowired
	UserFileMapper userFileMapper;
	
	public int login(String userId, String userPw) {
		return userMapper.selectLoginInfo(userId, userPw);
	}
	public Map<String, Object> mypage(String userId) {
		Map<String, Object> userInfo = new HashMap<>();
		User user = userMapper.selectUserInfo(userId);
		List<UserFile> userFile = userFileMapper.selectUserFile(userId);
		userInfo.put("user", user);
		
		for(UserFile uf : userFile) {
			if(uf.getFileCategory().equals("사진")) {
				userInfo.put("photoFile", uf);
			}
			if(uf.getFileCategory().equals("사인")) {
				userInfo.put("signFile", uf);
			}
		}
		
		return userInfo;
	}
}
