package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	List<Schedule> selectTodaySchedule(String userId, String todayYmd);
}
