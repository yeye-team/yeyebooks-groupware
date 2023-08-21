package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

@Mapper
public interface ApprovalMapper {
	
	public int insertApproval(Approval approval);
	
	public int insertApprovalFile(ApprovalFile approvalFile);
	
	public int insertApprovalLine(ApprovalLine approvalLine);
	
	Map<String, Object> selectApprovalByStatus(String loginId, String status);
	
	String selectApprovalCode(String approvalStatus);

	public Approval selectApprovalOne(int aprvNo);
	
	public int updateApprovalProcessed(Approval approval);
	
	public int updateApprovalWithDrawn(Approval approval);
	
	
}
