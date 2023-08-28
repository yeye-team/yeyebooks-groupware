package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.yeyebooks.mapper.ApprovalMapper;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ApprovalService {
	
	@Autowired 
	private ApprovalMapper approvalMapper;

	
	// 내 문서함 리스트
	public ApprovalService(ApprovalMapper approvalMapper) {
		this.approvalMapper = approvalMapper;
	}
	
	public List<Approval> selectMyApproval(String loginId, int status){
		List<Approval> approvalList = null;
		approvalList = approvalMapper.selectMyApproval(loginId, status);
		log.debug("\u001B[35m"+"aprovalList : " + approvalList);
		return approvalList;
	};
	
	// 문서상세보기
	
	public List<Approval> selectApprovalOne(String aprvNo) {
		List<Approval> approvalOne = null;
		approvalOne = approvalMapper.selectApprovalOne(aprvNo);		
		return approvalOne;
	}
	

	// 전자결재 작성
	public void addApproval(Approval approval, ApprovalFile approvalFile, ApprovalLine approvalLine) {
		// 문서추가
		approvalMapper.insertApproval(approval);
		
		// 첨부파일 추가
		approvalFile.setAprvNo(approval.getAprvNo());
		approvalMapper.insertApprovalFile(approvalFile);
		
		// 결재선 추가
		approvalLine.setAprvNo(approval.getAprvNo());
		approvalMapper.insertApprovalLine(approvalLine);
	}
	
	public Map<String, Object> getApprovalWaitingCnt(String userId){
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("approvalCnt", approvalMapper.selectApprovalWaitingCnt(userId));
		result.put("approveCnt", approvalMapper.selectApproveWaitingCnt(userId));
		return result;
	}
}
