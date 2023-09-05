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
import org.springframework.web.multipart.MultipartFile;

import com.goodee.yeyebooks.mapper.ApprovalMapper;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.BoardFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ApprovalService {
	
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
	
	public List<Approval> selectApprovalOne(String aprvNo) {
		List<Approval> approvalOne = null;
		approvalOne = approvalMapper.selectApprovalOne(aprvNo);		
		return approvalOne;
	}
	

	// 문서 추가 메서드
	public int addApproval(Approval approval, String path) {
		//log.debug("\u001B[41m"+ "boardService board : " +  board + "\u001B[0m");
		
		// 관리자 메인메뉴바 : 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = approvalMapper.selectAll();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
		int row = approvalMapper.insertApproval(null);
		//log.debug("\u001B[41m" + "insertBoard row : " + row + "\u001B[0m");
		// addboard 성공 및 첨부된 파일이 1개 이상 있다면
		List<MultipartFile> fileList = approval.getMultipartFile();
		if(row == 1 && fileList != null && fileList.size() > 0) {
			String aprvNo = approval.getAprvNo();
			//log.debug("\u001B[41m" + "insertBoard boardFile boardNo : " + boardNo + "\u001B[0m");
			for(MultipartFile mf : fileList) { // 첨부 파일 개수만큼 반복
				if(mf.getSize() > 0) {
					ApprovalFile bf = new ApprovalFile();
					bf.setAprvNo(path); // 부모키값
					bf.setOrginFilename(path); // 파일원본이름
					bf.setSaveFilename(path);
					bf.setFiletype(path); // 파일타입(MIME : Multipurpose Internet Mail Extensions = 파일변환타입)
					bf.setPath(path);
					
					// 저장될 파일 이름
					// 확장자
					int lastIdx = mf.getOriginalFilename().lastIndexOf(".");
					String ext = mf.getOriginalFilename().substring(lastIdx); // 마지막 .의 위치값 > 확장자 ex) A.jpg 에서 자른다
					//log.debug("\u001B[41m" + "insertBoard boardFile lastIdx : " + lastIdx + "\u001B[0m");
					//log.debug("\u001B[41m" + "insertBoard boardFile ext : " + ext + "\u001B[0m");
					// 새로운 이름 + 확장자
					bf.setSaveFilename(UUID.randomUUID().toString().replace("-", "") + ext); 
					
					// 테이블에 저장
					approvalMapper.insertApprovalFile(null);
					// 파일저장(저장위치필요 > path변수 필요)
					// path 위치에 저장파일이름으로 빈파일을 생성
					File f = new File(path+bf.getSaveFilename());
					// 빈파일에 첨부된 파일의 스트림을 주입한다.
					log.debug("\u001B[41m" + "insertBoard boardFile f : " + f + "\u001B[0m");
					log.debug("\u001B[41m" + "insertBoard boardFile f.getAbsolutePath() : " + f.getAbsolutePath() + "\u001B[0m");
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
    
}
