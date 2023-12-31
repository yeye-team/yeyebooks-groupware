package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.UserFile;

@Mapper
public interface UserFileMapper {
	List<UserFile> selectUserFile(String userId);
	int insertUserFile(UserFile userFile);
	int deleteUserFile(int userFileNo);
	UserFile selectUserFileOne(int userFileNo);
}
