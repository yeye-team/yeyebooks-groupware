package com.goodee.yeyebooks.service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.yeyebooks.mapper.ApprovalMapper;
import com.goodee.yeyebooks.vo.Account;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.BoardFile;
import com.goodee.yeyebooks.vo.Dayoff;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ApprovalService {
	String todayYmd = LocalDate.now().toString();
	@Autowired 
	private ApprovalMapper approvalMapper;
	
	public List<Map<String, Object>> getUserCntByDept(){
		List<Map<String, Object>> list = approvalMapper.selectUserCntByDept();
		return list;
	}
	
	public List<Map<String, Object>> getUserListByDept(){
		List<Map<String, Object>> list = approvalMapper.selectUserListByDept();
		return list;
	}
	
	public List<Map<String, Object>> getUserCntByDeptAndAll(){
		List<Map<String, Object>> list = approvalMapper.selectUserCntByDeptAndAll();
		return list;
	}

	
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
	public Map<String, Object> selectApprovalOne(String aprvNo) {
		Map<String, Object> approvalOne = new HashMap<>();
		Approval approval = approvalMapper.selectApprovalOne(aprvNo);
		List<ApprovalFile> aprvFile = approvalMapper.selectApprovalFileOne(aprvNo);
		List<ApprovalLine> aprvLine =  approvalMapper.selectApprovalLineOne(aprvNo);
		String nowApprovalUser = approvalMapper.selectNowApproveUSer(aprvNo);

		approvalOne.put("approval", approval);
	    approvalOne.put("aprvFile", aprvFile);
	    approvalOne.put("aprvLine", aprvLine);
	    approvalOne.put("approvalUser", nowApprovalUser);
	    
	    if(approval.getDocCatCd().equals("01")) {
		    Account account = approvalMapper.selectAccountOne(aprvNo);
		    approvalOne.put("account", account);
	    }
	    
	    if(approval.getDocCatCd().equals("02")) {
		    Dayoff dayoff = approvalMapper.selectDayoffOne(aprvNo);
		    approvalOne.put("dayoff", dayoff);
	    }

		return approvalOne;
	}
	
	// 문서 회수
    public void updateAprvStatCd(String aprvNo) {
    	
    	approvalMapper.updateAprvStatCd(aprvNo);
    	
    }

    
    // 문서 반려
    public void updaterjctReason(String aprvNo, String rejectReason, String userId) {
    	approvalMapper.updateRjctReason(rejectReason, aprvNo);
    	approvalMapper.updateAprvlineRjct(aprvNo, userId);  	
    }
	

	// 문서 추가 메서드
	public int addApproval(Approval approval, String[] approvalLine, String path, Account account) {
		log.debug("\u001B[35m"+ "approvalLien : " +  approvalLine + "\u001B[0m");
		approval.setAprvYmd(todayYmd);
		String aprvNo = approvalMapper.selectApprovalNo(approval);
		log.debug("\u001B[35m"+"aprvNo : " + aprvNo);
		approval.setAprvNo(aprvNo);

		account.setAprvNo(aprvNo);
		log.debug("\u001B[35m"+account.getAcntYmd());
		
		int row = approvalMapper.insertApproval(approval);
		
		if("01".equals(approval.getDocCatCd())) {
			row = approvalMapper.insertAccount(account);
		} 
		
		// 관리자 메인메뉴바 : 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = approvalMapper.selectAll();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
		if(approvalLine != null && approvalLine.length != 0) {
			int seq = 1;
			for(String line : approvalLine) {
				System.out.println("ApprovalService line : " + line);
				ApprovalLine apl = new ApprovalLine();
				apl.setUserId(line);
				apl.setAprvSequence(seq);
				apl.setAprvNo(aprvNo);
				int lineRow = approvalMapper.insertApprovalLine(apl);
				seq++;
			}
		}
		
		// addApproval 성공 및 첨부된 파일이 1개 이상 있다면
		List<MultipartFile> fileList = approval.getMultipartFile();
		if(fileList != null && fileList.size() > 0) {
			for(MultipartFile mf : fileList) { // 첨부 파일 개수만큼 반복
				if(mf.getSize() > 0) {
					ApprovalFile bf = new ApprovalFile();
					bf.setAprvNo(aprvNo); // 부모키값
					bf.setOrginFilename(mf.getOriginalFilename()); // 파일원본이름
					bf.setFiletype(mf.getContentType()); // 파일타입(MIME : Multipurpose Internet Mail Extensions = 파일변환타입)
					bf.setPath("/approvalFile/");
					
					// 저장될 파일 이름
					// 확장자
					int lastIdx = mf.getOriginalFilename().lastIndexOf(".");
					String ext = mf.getOriginalFilename().substring(lastIdx); // 마지막 .의 위치값 > 확장자 ex) A.jpg 에서 자른다
					// 새로운 이름 + 확장자
					bf.setSaveFilename(UUID.randomUUID().toString().replace("-", "") + ext); 
					
					// 테이블에 저장
					approvalMapper.insertApprovalFile(bf);
					// 파일저장(저장위치필요 > path변수 필요)
					// path 위치에 저장파일이름으로 빈파일을 생성
					File f = new File(path+bf.getSaveFilename());
					// 빈파일에 첨부된 파일의 스트림을 주입한다.
					try {
						mf.transferTo(f);
					} catch(IllegalStateException | IOException e) {
						// 트랜잭션 작동을 위해 예외 발생이 필요
						e.printStackTrace();
						// 트랜잭션 작동을 위해 예외(try catch 강요하지 않는 예외 ex) RuntimeException) 발생 필요
						throw new RuntimeException();
					}
				}
			}
		}
		return row;
	}
	
	
	public Map<String, Object> getApprovalWaitingCnt(String userId){
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("approvalCnt", approvalMapper.selectApprovalWaitingCnt(userId));
		result.put("approveCnt", approvalMapper.selectApproveWaitingCnt(userId));
		return result;
	}
	
	public String selectLastApprovalUser(String aprvNo) {
		return approvalMapper.selectLastApprovalUser(aprvNo);
	}
    public void updateApproveApproval(String aprvNo) {
    	approvalMapper.updateApproveApproval(aprvNo);
    }
    public void updateApproveApprovalLine(String aprvNo, String userId) {
    	approvalMapper.updateApproveApprovalLine(aprvNo, userId);
    }
}
