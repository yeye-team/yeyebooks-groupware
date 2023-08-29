package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	// 오늘의 회사/부서/개인 일정 조회
	List<Schedule> selectTodaySchedule(String userId, String todayYmd);
	
	// 해당 날짜의 일정상세 보여주기
	List<Schedule> selectDateSchedule(String targetDate);
	
	// 일정 등록
	int insertSchedule(Schedule schedule);
	
	// 일정 수정
	int updateSchedule(Schedule schedule);
	
	// 일정 삭제
	int deleteSchedule(int skdNo);
}
