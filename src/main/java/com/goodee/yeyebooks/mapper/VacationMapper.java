package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VacationMapper {
	// 휴가내역 리스트
	List<Map<String, Object>> selectVacationList(String userId, int beginRow, int rowPerPage, String searchDate);
	
	// 페이징을 위한 휴가내역 개수
	int vacationListCount(String userId, String searchDate);
}
