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
	
	private final ApprovalMapper approvalMapper;
	/*
	 status들어오면
	 > String approvalCode = approvalMapper.selectApprovalCode(status);
	 > return List<Approval> selectApprovalByStatus(loginId, approvalCode);
	  
	 */
	
	
	@Autowired 
	public ApprovalService(ApprovalMapper approvalMapper) {
		this.approvalMapper = approvalMapper;
	}
	
	public List<Approval> selectMyApproval(String loginId){
		return approvalMapper.selectMyApproval(loginId);
	}
	
	// 내 문서함 리스트
	public Map<String, Object> selectApprovalByStatus(String loginId, String approvalStatus){
		Map<String, Object> resultMap = new HashMap<>();
		
		String approvalCode = getApprovalStatusCode(approvalStatus);
		
		List<Approval> allApprovalList = approvalMapper.selectApprovalByStatus(loginId, approvalStatus);
		
		List<Approval> approvalList = approvalMapper.selectApprovalByStatus(loginId, approvalStatus);
		
		resultMap.put("approvalCode", approvalCode);
		resultMap.put("approvalList", approvalList);
		resultMap.put("status", approvalStatus);
		
		return resultMap;
	}
	
	public String getApprovalStatusCode(String approvalStatus) {
		return approvalMapper.selectApprovalCode(approvalStatus);
	}
	

	// 전자결재 작성
	public void createApproval(Approval approval, ApprovalFile approvalFile, ApprovalLine approvalLine) {
		// 문서추가
		approvalMapper.insertApproval(approval);
		
		// 첨부파일 추가
		approvalFile.setAprvNo(approval.getAprvNo());
		approvalMapper.insertApprovalFile(approvalFile);
		
		// 결재선 추가
		approvalLine.setAprvNo(approval.getAprvNo());
		approvalMapper.insertApprovalLine(approvalLine);
	}

}
