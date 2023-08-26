package com.goodee.yeyebooks.service;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.UserTimeMapper;
import com.goodee.yeyebooks.vo.UserTime;

@Service
public class UserTimeService {
	@Autowired
	UserTimeMapper userTimeMapper;
	String todayYmd = LocalDate.now().toString();
	
	public UserTime selectTodayWorkTime(String userId) {
		return userTimeMapper.selectTodayWorkTime(userId, todayYmd);
	}
	public int insertTodayWorkStartTime(String userId, String workStartTime) {
		return userTimeMapper.insertTodayWorkStartTime(userId, todayYmd, workStartTime);
	}
	public int updateTodayWorkEndTime(String userId, String workEndTime) {
		return userTimeMapper.updateTodayWorkEndTime(userId, todayYmd, workEndTime);
	}
}
