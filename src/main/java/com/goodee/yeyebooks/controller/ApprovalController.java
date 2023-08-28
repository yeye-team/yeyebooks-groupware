package com.goodee.yeyebooks.controller;

import java.lang.ProcessBuilder.Redirect;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class ApprovalController {
	
	private final ApprovalService approvalService;
	
	// 내 문서함 리스트 출력
	@Autowired
	public ApprovalController(ApprovalService approvalService) {
		this.approvalService = approvalService;
	}
	
	@GetMapping("/approval/approvalList")
	public String myApproval(Model model, 
							@RequestParam(name = "loginId", defaultValue = "admin") String loginId,
							@RequestParam(name = "status", defaultValue = "0") int status) {
		List<Approval> approvalList = approvalService.selectMyApproval(loginId, status);
		log.debug("\u001B[35m"+"approvalList{} : ",approvalList);
		model.addAttribute("approvalList",approvalList);
		model.addAttribute("status", status);
		return "approval/approvalList";
	}
	
	// 문서 상세보기
	@GetMapping("/approval/approvalOne")
	public String approvalOne(Model model, 
							@RequestParam(name = "aprvNo") String aprvNo) {
		List<Approval> approvalOne = approvalService.selectApprovalOne(aprvNo);
		model.addAttribute("approvalOneList", approvalOne);
		return "approval/approvalOne";
	}
			
			
	// 문서작성
	 @GetMapping("/approval/addApproval")
	    public String showCreateForm() {
	        return "createform"; // 문서 생성 폼을 보여주는 뷰로 리턴
	    }

	    @PostMapping("/approval/addApproval")
	    public String createApproval(
	            @RequestParam("userId") String userId,
	            @RequestParam("docCatCd") String docCatCd, 
	            @RequestParam("aprvTitle") String aprvTitle, 
	            @RequestParam("aprvContents") String aprvContents, 
	            @RequestParam("orginFilename") String orginFilename, 
	            @RequestParam("saveFilename") String saveFilename,
	            @RequestParam("fileType") String filetype, 
	            @RequestParam("path") String path, 
	            @RequestParam("aprvUserId") String aprvUserId 
	    ) {
	        // Approval 객체 생성 및 데이터 설정
	        Approval approval = new Approval();
	        approval.setUserId(userId);
	        approval.setDocCatCd(docCatCd);
	        approval.setAprvTitle(aprvTitle);
	        approval.setAprvContents(aprvContents);
	        
	        // ApprovalFile 객체 생성 및 데이터 설정
	        ApprovalFile approvalFile = new ApprovalFile();
	        approvalFile.setOrginFilename(orginFilename);
	        approvalFile.setSaveFilename(saveFilename);
	        approvalFile.setFiletype(filetype);
	        approvalFile.setPath(path);
	        
	        // ApprovalLine 객체 생성 및 데이터 설정
	        ApprovalLine approvalLine = new ApprovalLine();
	        approvalLine.setUserId(aprvUserId);
	        approvalLine.setAprvYn("N"); // 결재 여부 초기화
	        approvalLine.setAprvSequence(1); // 결재 순서 초기화
	        
	        // 문서 생성 서비스 메서드 호출
	        approvalService.addApproval(approval, approvalFile, approvalLine);
	        
	        // return "redirect:/approval/detail?aprvNo=" + approval.getAprvNo();
	        
	        return "redirect:/approval/addApproval"; // 작성한 폼으로 다시 리다이렉트
	    }
	
	

}
