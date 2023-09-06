package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.yeyebooks.mapper.VacationMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VacationService {
	@Autowired
	private VacationMapper vacationMapper;
	
	// 휴가 내역 리스트
	public Map<String, Object> selectVacationList(HttpSession session, int currentPage, int rowPerPage, String searchDate){
		String userId = (String) session.getAttribute("userId");
		
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 리스트
		List<Map<String, Object>> selectVacationList = vacationMapper.selectVacationList(userId, beginRow, rowPerPage,searchDate);
		
		// ================ 페이지 =================
		// 페이징을 위한 내역 개수
		int vacationListCount = vacationMapper.vacationListCount(userId, searchDate);
		
		
		// 마지막행
		int endRow = beginRow + (rowPerPage - 1);
		if (endRow > vacationListCount) {
			endRow = vacationListCount;
		}

		// 페이지 선택 버튼
		int pagePerPage = 5;

		// 마지막 페이지
		int lastPage = vacationListCount / rowPerPage;
		if (vacationListCount % rowPerPage != 0) {
			lastPage += 1; // lastPage =lastPage +1;
		}

		// 페이지 선택 버튼 최소값
		int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;

		// 페이지 선택 버튼 최대값
		int maxPage = minPage + (pagePerPage - 1);
		if (maxPage > lastPage) {
			maxPage = lastPage;
		}

		Map<String,Object> map = new HashMap<String,Object>();
		map.put("selectVacationList", selectVacationList);
		map.put("currentPage", currentPage);
		map.put("lastPage", lastPage);
		map.put("endRow", endRow);
		map.put("pagePerPage", pagePerPage);
		map.put("minPage", minPage);
		map.put("maxPage", maxPage);
		// ========================================
		
		return map;
	}
}
