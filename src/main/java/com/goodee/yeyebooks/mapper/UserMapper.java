package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Report;
import com.goodee.yeyebooks.vo.User;

@Mapper
public interface UserMapper {
	int selectLoginInfo(String userId, String userPw);
	User selectUserInfo(String userId);
	int updateUserInfoByUser(User user);
	int updateUserPw(String userId, String userPw);
	List<Report> selectRecentJoinCnt();
	List<Report> selectRecentLeaveCnt();
	List<Report> selectFMCnt();
	int selectTotalUserCntBeforeMonth(int year, int month);
}
