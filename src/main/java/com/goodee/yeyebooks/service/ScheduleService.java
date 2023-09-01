package com.goodee.yeyebooks.service;

import java.util.List;
import java.util.Map;
import java.time.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.ScheduleMapper;
import com.goodee.yeyebooks.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
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
	public List<Schedule>  selectMonthSchedule(String userId){
		return scheduleMapper.selectMonthSchedule(userId);
	}
	
	// 회사/부서/개인 일정
	public List<Schedule> selectFilteredMonthSchedule(String userId, String skdCatCd) {
		// 회사 일정 조회
	    if ("00".equals(skdCatCd)) {
	        return scheduleMapper.selectAdminSchedule();
	        // 개인 일정 조회
	    } else if ("99".equals(skdCatCd)) {
	        return scheduleMapper.selectPersonalSchedule(userId);
	        // 부서별 일정 조회
	    } else {
	        return scheduleMapper.selectDeptSchedule(userId);
	    }
	}
	
	// 관리자 일정만
	public List<Schedule>  selectAdminSchedule() {
		return scheduleMapper.selectAdminSchedule();
	}
	
	// 선택한 일정 조회
	public Schedule selectDateSchedule(int skdNo){
		return scheduleMapper.selectDateSchedule(skdNo);
	}
	
	// 일정 수정
	public int modifySchedule(Schedule schdule) {
		log.debug("\u001B[41m" + "service modifySchedule schdule : " + schdule + "\u001B[0m");
		return scheduleMapper.modifySchedule(schdule);
	}
	
	// 일정 삭제
	public int deleteSchedule(int skdNo) {
		return scheduleMapper.deleteSchedule(skdNo);
	}
}
