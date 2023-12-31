package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Account;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Dayoff;

@Mapper
public interface ApprovalMapper {

	List<Map<String, Object>> selectAll();
	
	public String selectApprovalNo(Approval approval);
	
	// 결재문서 추가
	public int insertApproval(Approval approval);
	// 결재문서 파일추가
	public int insertApprovalFile(ApprovalFile approvalFile);
	// 결재문서 결재선 추가
	public int insertApprovalLine(ApprovalLine approvalLine);
	// 지출결의서 
	public int insertAccount(Account account);
	
	// 내 문서함 조회
	List<Approval> selectMyApproval(String userId, int status);
	// 각 상태별 문서함 조회
	List<Approval> selectApprovalByStatus(String userId, String status);
	
	// 문서 상세보기
	public Approval selectApprovalOne(String aprvNo);

	List<ApprovalFile> selectApprovalFileOne(String aprvNo);
	
	List<ApprovalLine> selectApprovalLineOne(String aprvNo);
	
	List<String> selectRefOne(String aprvNo);
	
	public Account selectAccountOne(String aprvNo);
	
	public Dayoff selectDayoffOne(String aprvNo);
	
	List<Map<String, Object>> selectUserListByDept();
	
	List<Map<String, Object>> selectUserCntByDept();
	
	List<Map<String, Object>> selectUserCntByDeptAndAll();
	
	//문서반려
	public void updateRjctReason(String rjctReason, String aprvNo);
	//approvalLine반려
	public void updateAprvlineRjct(String aprvNo, String userId);
	
	//문서회수
	public void updateAprvStatCd(String aprvNo);
	
	//문서 승인
	void updateApproveApproval(String aprvNo);
	//approvalLine승인
	void updateApproveApprovalLine(String aprvNo, String userId);
	
	//결재대기건수
	int selectApprovalWaitingCnt(String userId);
	
	//승인대기건수
	int selectApproveWaitingCnt(String userId);
	
	//이번에 결재해야할 유저id
	String selectNowApproveUSer(String aprvNo);
	
	//마지막으로 결재하는 유저id
	String selectLastApprovalUser(String aprvNo);
}
