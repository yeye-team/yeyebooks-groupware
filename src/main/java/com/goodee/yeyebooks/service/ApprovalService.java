package com.goodee.yeyebooks.service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
	

	// 문서 추가 메서드
    public int addApproval(Approval approval, List<ApprovalFile> fileList, List<ApprovalLine> approvalLine) throws IOException {
        int row = approvalMapper.insertApproval(approval);
        
        if (row == 1 && fileList != null && !fileList.isEmpty()) {
            String aprvNo = approval.getAprvNo();
            
            for (ApprovalFile approvalFile : fileList) {
                if (approvalFile.getAprvFileNo() > 0) {
                	approvalFile.setAprvNo(aprvNo);
                    String extension = getFileExtension(approvalFile.getOrginFilename());
                    approvalFile.setSaveFilename(UUID.randomUUID().toString().replace("-", "") + extension);
                    
                    approvalMapper.insertApprovalFile(approvalFile);
                    
                    String filePath = "your_file_path_here"; // 파일 경로 설정
                    File file = new File(filePath + approvalFile.getSaveFilename());
                    
                    approvalFile.getPath();
                }
            }
        }
        
        if (row == 1 && approvalLine != null && !approvalLine.isEmpty()) {
            for (ApprovalLine aprvLine : approvalLine) {
            	aprvLine.getUserId();
                    
                approvalMapper.insertApprovalLine(aprvLine);
            }
        }
        
        return row;
    }
    
    // 문서번호 생성 로직
    private String generateApprovalNumber(Approval approval) {
        String prefix = ""; // "A" or "N" depending on document type
        if (approval.getDocCatCd().equals("지출결의서")) {
            prefix = "A";
        } else if (approval.getDocCatCd().equals("일반문서")) {
            prefix = "N";
        }
        
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int sequence = approvalMapper.selectDocumentSequence(prefix + date) + 1;
        
        String documentNumber = prefix + date + String.format("%02d", sequence);
        return documentNumber;
    }
    
    // 파일 확장자 얻는 메서드
    private String getFileExtension(String filename) {
        int lastIdx = filename.lastIndexOf(".");
        return filename.substring(lastIdx);
    }
	
	public Map<String, Object> getApprovalWaitingCnt(String userId){
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("approvalCnt", approvalMapper.selectApprovalWaitingCnt(userId));
		result.put("approveCnt", approvalMapper.selectApproveWaitingCnt(userId));
		return result;
	}
}
