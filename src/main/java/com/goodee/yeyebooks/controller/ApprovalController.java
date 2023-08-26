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
	@GetMapping("/create")
	public String showCreateForm() {
		return "createform";
	}
	
	@PostMapping("/create")
	public String createApproval(
			@RequestParam("userId") String userId
			
	) {
		
		Approval approval = new Approval();
		ApprovalFile approvalFile = new ApprovalFile();
		ApprovalLine approvalLine = new ApprovalLine();
		
		approvalService.createApproval(approval, approvalFile, approvalLine);
		
		return "";
		
	}
	

}
