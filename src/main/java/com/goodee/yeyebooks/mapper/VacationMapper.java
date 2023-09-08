package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Dayoff;

@Mapper
public interface VacationMapper {
	// 휴가내역 리스트
	List<Map<String, Object>> selectVacationList(String userId, int beginRow, int rowPerPage, String searchDate);
	
	// 페이징을 위한 휴가내역 개수
	int vacationListCount(String userId, String searchDate);
	
	/* 휴가 신청 */
	// 기안자 정보조회
	Map<String, Object> getAprvInfo(String userId);
	
	// 결재자 출력
	List<Map<String, Object>> getAprvLine(String userId);
	
	// 참조자 조회
	List<Map<String, Object>> getReference(String userId);
	
	// 휴가 신청 시 시퀀스 함수 실행하여 문서번호 임의 테이블에 생성
	String getAprvNo(String aprvYmd);
	
	// 문서(휴가신청) 내용 입력
	int insertAprv(Approval approval);
	
	// 휴가 세부 내용 입력
	int insertDayoff(Dayoff dayOff);
	
	// 결재 라인 입력
	int insertAprvLine(ApprovalLine approvalLine);
	
	// 첨부파일 입력
	int insertAprvFile(ApprovalFile approvalFile);
	
	// 사용자 연차 조회
	double getDayoffCnt(String userId);
	
	// 연차차감
	int minusDayoff(String userId, double userDayoffCnt);
}
