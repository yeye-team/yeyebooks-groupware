package com.goodee.yeyebooks.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.UserTime;

@Mapper
public interface UserTimeMapper {
	UserTime selectTodayWorkTime(String userId, String todayYmd);
	int insertTodayWorkStartTime(String userId, String todayYmd, String workStartTime);
	int updateTodayWorkEndTime(String userId, String todayYmd, String workEndTime);
}
