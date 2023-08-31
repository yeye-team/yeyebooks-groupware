package com.goodee.yeyebooks.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	// 오늘의 회사/부서/개인 일정 조회
	List<Schedule> selectTodaySchedule(String userId, String todayYmd);
	
	// 선택달의 일정보여주기
	List<Schedule> selectMonthSchedule(String userId);
	
	// 회사일정
	List<Schedule> selectAdminSchedule();
	
	// 개인일정
	List<Schedule> selectPersonalSchedule(String userId);
	
	// 부서일정
	List<Schedule> selectDeptSchedule(String userId);
	
	// 해당 날짜의 일정상세 보여주기
	Schedule selectDateSchedule(int skdNo);
	
	// 일정 등록
	int insertSchedule(Schedule schedule);
	
	// 일정 수정
	int updateSchedule(Schedule schedule);
	
	// 일정 삭제
	int deleteSchedule(int skdNo);
}
