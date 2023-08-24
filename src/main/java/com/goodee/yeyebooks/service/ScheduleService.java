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
	
	public List<Schedule> selectTodaySchedule(String userId){
		String todayYmd = LocalDate.now().toString();
		return scheduleMapper.selectTodaySchedule(userId, todayYmd);
	}
}
