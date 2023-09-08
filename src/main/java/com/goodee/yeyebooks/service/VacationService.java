package com.goodee.yeyebooks.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.yeyebooks.controller.LunarCalendar;
import com.goodee.yeyebooks.mapper.ApprovalMapper;
import com.goodee.yeyebooks.mapper.VacationMapper;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Dayoff;

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
		//log.debug("\u001B[41m"+ "vacaService addVacation aprvLine : " + aprvLine + "\u001B[0m");
		
		// 참조자 정보
		List<Map<String, Object>> referList = vacationMapper.getReference(userId);
		//log.debug("\u001B[41m"+ "vacaService addVacation referList : " + referList + "\u001B[0m");
		
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
	
	// 예상 휴가 일수 계산 함수
	private int calculateExpectedRowCount(LocalDate startDate, LocalDate endDate, Set<String> holidaysSet) {
	    int expectedRowCount = 0;
	    for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
	        // 주말(토요일 또는 일요일) 또는 공휴일인 경우 계산에서 제외
	        if (date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY &&
	            !holidaysSet.contains(date.format(DateTimeFormatter.BASIC_ISO_DATE))) {
	            expectedRowCount++;
	        }
	    }
	    return expectedRowCount;
	}
	
	// 휴가 상신
	public int addVacation(HttpSession session, Approval approval, String[] approvalLine, Dayoff dayOff, String[] dayoffYmd) {
		//log.debug("\u001B[41m"+ "vacaService addVacation approvalLine : " + approvalLine + "\u001B[0m");
		//log.debug("\u001B[41m"+ "vacaService addVacation dayoffYmd : " + dayoffYmd + "\u001B[0m");
		int row = 0;
		
		/* 문서제목 */
		// 현재 날짜 구하기
		LocalDate now = LocalDate.now();
		// 포맷 정의
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		// 포맷 적용
		String aprvTitle = now.format(formatter) + " 휴가 신청서";
		//log.debug("\u001B[41m"+ "vacaService addVacation formatedNow : " + aprvTitle + "\u001B[0m");
		
		// 상신날짜
		String aprvYmd = now.format(formatter);
		//log.debug("\u001B[41m"+ "vacaService add/Post aprvYmd/오늘날짜 : " + aprvYmd + "\u001B[0m");
		
		String userId = (String)session.getAttribute("userId");
		
		// 시퀀스로 생성된 문서번호
		String aprvNo = vacationMapper.getAprvNo(aprvYmd);
		//log.debug("\u001B[41m"+ "vacaService add/Post aprvNo/시퀀스 문서번호 : " + aprvNo + "\u001B[0m");
        
        // 문서내용 세팅
        approval.setAprvNo(aprvNo);
        approval.setUserId(userId);
        approval.setAprvTitle(aprvTitle);
        approval.setAprvYmd(aprvYmd);
        
        //log.debug("\u001B[41m"+ "vacaService add/Post approval : " + approval + "\u001B[0m");
        
        row = vacationMapper.insertAprv(approval);
        
        //문서내용 입력 성공시 결재선 입력
        if(row == 1) {
        	if(approvalLine != null && approvalLine.length != 0) {
        		int lineRow = 0;
    			int seq = 1;
    			for(String line : approvalLine) {
    				//log.debug("\u001B[41m"+ "vacaService add/Post aprvNo/문서번호 : " + aprvNo + "\u001B[0m");
    				//log.debug("\u001B[41m"+ "vacaService add/Post line/결재선분리 : " + line + "\u001B[0m");
    				ApprovalLine apl = new ApprovalLine();
    				apl.setAprvNo(aprvNo);
    				apl.setUserId(line);
    				apl.setAprvSequence(seq);
    				
    				lineRow += vacationMapper.insertAprvLine(apl);
    				seq++;
    			}
    			
    			// 결재선 입력 성공시 휴가 내용 입력
    			if(lineRow == approvalLine.length) {
    				int offRow = 0;
    				
    				dayOff.setAprvNo(aprvNo);
    				//log.debug("\u001B[41m"+ "vacaService add/Post dayOff/휴가내용 : " + dayOff + "\u001B[0m");
    				
    				// 오전반차(01) 또는 오후반차(02)인 경우
                    if (dayOff.getDayoffTypeCd().equals("01") || dayOff.getDayoffTypeCd().equals("02")) {
                        LocalDate date = LocalDate.parse(dayoffYmd[0]);
                        String formattedDate = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        dayOff.setDayoffYmd(formattedDate);
                        
                        offRow = vacationMapper.insertDayoff(dayOff);
                        
                        // 반차는 결과값 1
                        int expectedRowCount = 1;
                        if (offRow != expectedRowCount) {
                        	 log.debug("\u001B[41m"+ "반차 입력실패" + "\u001B[0m");
                        	 return 0;
                        }
                        
                        // 현재 연차
                        double userDayoffCnt = vacationMapper.getDayoffCnt(userId);
                        // 0.5개 차감
                        double dayoffToDeduct = 0.5;
                        userDayoffCnt -= dayoffToDeduct;
                        // 차감 업데이트
                        vacationMapper.minusDayoff(userId, userDayoffCnt);
                        
                    } else if (dayOff.getDayoffTypeCd().equals("03") && dayoffYmd.length == 2) {
                    	// 연차(03)인 경우
                    	String year = String.valueOf(now.getYear()); // 공휴일 정보를 가져올 연도
                    	
                    	// 주말/공휴일 정보 가져오기
                		LunarCalendar lunarCalendar = new LunarCalendar();
                		Set<String> holidaysSet = lunarCalendar.holidayArray(year);
                		
                		DateTimeFormatter dbDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                		
                		log.debug("\u001B[41m"+ "날짜 포맷" + dbDateFormatter + "\u001B[0m");
                		log.debug("\u001B[41m"+ "연차 신청 처음" + dayoffYmd[0] + "\u001B[0m");
                		log.debug("\u001B[41m"+ "연차 신청 끝" + dayoffYmd[1] + "\u001B[0m");
                		
                		LocalDate startDate = LocalDate.parse(dayoffYmd[0], DateTimeFormatter.BASIC_ISO_DATE);
                	    LocalDate endDate = LocalDate.parse(dayoffYmd[1], DateTimeFormatter.BASIC_ISO_DATE);
                	    
                	    int expectedRowCount = calculateExpectedRowCount(startDate, endDate, holidaysSet);
                	    int actualRowCount = 0; // 입력된 휴가 개수 확인


                	    // 주말 공휴일 제외 사이의 날짜를 계산하여 전부 DB에 입력
                	    for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                	        // 주말(토요일 또는 일요일) 또는 공휴일인 경우 계산에서 제외
                	        if (date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY &&
                	            !holidaysSet.contains(date.format(DateTimeFormatter.BASIC_ISO_DATE))) {
                	            // 주말 또는 공휴일이 아니라면 휴가로 계산
                	            String formattedDate = date.format(dbDateFormatter);
                	            dayOff.setDayoffYmd(formattedDate); // YYYY-MM-DD 형식으로 변환
                	            offRow += vacationMapper.insertDayoff(dayOff);
                	            actualRowCount++;
                	        }
                	    }
                	    
                	    if (actualRowCount != expectedRowCount) {
                	    	log.debug("\u001B[41m"+ "연차 입력실패" + "\u001B[0m");
                       	 	return 0;
                	    }
                	    
	                	// 현재 연차
	                    double userDayoffCnt = vacationMapper.getDayoffCnt(userId);
	                    // 연차 차감
	                    userDayoffCnt -= expectedRowCount;
	                    // 차감 업데이트
	                    vacationMapper.minusDayoff(userId, userDayoffCnt);
                	}
                    
    			}
    		}
        }
		return row;
	}
}
