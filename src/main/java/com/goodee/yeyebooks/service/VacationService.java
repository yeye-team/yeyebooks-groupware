package com.goodee.yeyebooks.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.yeyebooks.mapper.ApprovalMapper;
import com.goodee.yeyebooks.mapper.VacationMapper;
import com.goodee.yeyebooks.vo.Approval;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VacationService {
	@Autowired
	private VacationMapper vacationMapper;
	@Autowired
	private ApprovalMapper approvalMapper;
	
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
		
		return map;
	}
	
	// 휴가 신청 폼
	public Map<String, Object> addVactionForm(HttpSession session){
		String userId = (String)session.getAttribute("userId");
		
		// 기안자 정보
		Map<String, Object> aprvInfo = vacationMapper.getAprvInfo(userId);
		//log.debug("\u001B[41m"+ "vacaService addVacation aprvInfo : " + aprvInfo + "\u001B[0m");
		
		// 결재자 정보
		List<Map<String, Object>> aprvLine = vacationMapper.getAprvLine(userId);
		log.debug("\u001B[41m"+ "vacaService addVacation aprvLine : " + aprvLine + "\u001B[0m");
		
		// 참조자 정보
		List<Map<String, Object>> referList = vacationMapper.getReference(userId);
		log.debug("\u001B[41m"+ "vacaService addVacation referList : " + referList + "\u001B[0m");
		
		// 현재 날짜 구하기
        LocalDate now = LocalDate.now();
        // 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        // 포맷 적용
        String formatedNow = now.format(formatter);
        //log.debug("\u001B[41m"+ "vacaService addVacation formatedNow : " + formatedNow + "\u001B[0m");
        
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("aprvInfo", aprvInfo);
		map.put("aprvLine", aprvLine);
		map.put("referList", referList);
		map.put("today", formatedNow);
		
		return map;
	}
	
	// 휴가 상신
	public int addVacation(Approval approval) {
		int row = 0;
		
		// 시퀀스로 생성된 문서번호
		String aprvNo = vacationMapper.getAprvNo(approval.getAprvYmd());
		
		// 문서제목
		// 현재 날짜 구하기
        LocalDate now = LocalDate.now();
        // 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        // 포맷 적용
        String aprvTitle = now.format(formatter) + " 휴가 신청서";
        //log.debug("\u001B[41m"+ "vacaService addVacation formatedNow : " + aprvTitle + "\u001B[0m");
		return row;
	}
}
