package com.goodee.yeyebooks.service;

import java.util.List;
import java.time.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.ScheduleMapper;
import com.goodee.yeyebooks.vo.Schedule;

@Service
public class ScheduleService {
	@Autowired
	ScheduleMapper scheduleMapper;
	
	// 오늘 날짜의 모든 일정 조회(홈)
	public List<Schedule> selectTodaySchedule(String userId){
		String todayYmd = LocalDate.now().toString();
		return scheduleMapper.selectTodaySchedule(userId, todayYmd);
	}
	
	// 선택한 날짜의 일정 조회
	public List<Schedule> selectDateSchedule(String targetDate){
		return scheduleMapper.selectDateSchedule(targetDate);
	}
}
