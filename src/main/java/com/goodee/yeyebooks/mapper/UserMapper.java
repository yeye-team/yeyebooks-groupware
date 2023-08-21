package com.goodee.yeyebooks.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.User;

@Mapper
public interface UserMapper {
	int selectLoginInfo(String userId, String userPw);
	User selectUserInfo(String userId);
	int updateUserInfoByUser(User user);
}
