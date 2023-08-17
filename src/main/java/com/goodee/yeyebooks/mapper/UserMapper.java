package com.goodee.yeyebooks.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
	int selectLoginInfo(String userId, String userPw);
}
