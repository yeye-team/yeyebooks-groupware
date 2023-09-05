package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

@Mapper
public interface ApprovalMapper {
	List<Map<String, Object>> selectAll();
	// 결재문서 추가
	public int insertApproval(Approval approval);
	// 결재문서 파일추가
	public int insertApprovalFile(ApprovalFile approvalFile);
	// 결재문서 결재선 추가
	public int insertApprovalLine(ApprovalLine approvalLine);
	// 내 문서함 조회
	List<Approval> selectMyApproval(String loginId, int status);
	// 각 상태별 문서함 조회
	List<Approval> selectApprovalByStatus(String loginId, String status);
	// 문서 상세보기
	List<Approval> selectApprovalOne(String aprvNo);
	
	List<Map<String, Object>> selectUserListByDept();
	
	List<Map<String, Object>> selectUserCntByDept();
	
	List<Map<String, Object>> selectUserCntByDeptAndAll();
	
	public int updateApprovalProcessed(Approval approval);
	
	public int updateApprovalWithDrawn(Approval approval);
	
	//결재대기건수
	int selectApprovalWaitingCnt(String userId);
	
	//승인대기건수
	int selectApproveWaitingCnt(String userId);
}
