package com.goodee.yeyebooks.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
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
	
	// 해당 달의 일정 목록 조회
	public ArrayList<Map<String, Object>> selectMonthSchedule(String userId){
		return scheduleMapper.selectMonthSchedule(userId);
	}
	
	// 회사/부서/개인 일정
	public ArrayList<Map<String, Object>> selectFilteredMonthSchedule(String userId, String category) {
		// 회사 일정 조회
	    if ("00".equals(category)) {
	        return scheduleMapper.selectAdminSchedule();
	        // 개인 일정 조회
	    } else if ("99".equals(category)) {
	        return scheduleMapper.selectPersonalSchedule(userId);
	        // 부서별 일정 조회
	    } else {
	        return scheduleMapper.selectDeptSchedule(userId);
	    }
	}
	
	// 관리자 일정만
	public ArrayList<Map<String, Object>> selectAdminSchedule() {
		return scheduleMapper.selectAdminSchedule();
	}
	
	// 선택한 날짜의 일정 조회
	public List<Schedule> selectDateSchedule(String targetDate){
		return scheduleMapper.selectDateSchedule(targetDate);
	}
}
