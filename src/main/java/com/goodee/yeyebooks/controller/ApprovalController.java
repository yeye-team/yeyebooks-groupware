package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

@Controller
@RequestMapping
public class ApprovalController {
	
	private final ApprovalService approvalService;
	
	@Autowired
	public ApprovalController(ApprovalService approvalService) {
		this.approvalService = approvalService;
	}
	
	@GetMapping("/myApproval")
	public String myApproval(Model model, @RequestParam("loginId") String loginId) {
		List<Approval> approvalList = approvalService.selectMyApproval(loginId);
		model.addAttribute("approvalList",approvalList);
		return "approval/approvalList";
	}
	
	// 내문서함 불러오기
	@GetMapping("/approval/approvalList")
	public String getMyDocuments(@RequestParam(name = "statusHidden", required = false) String statusHidden, Model model) {
		String approvalStatus = "A001";
		String loginId = "admin";
		String userId = loginId;
		
		Map<String, Object> myDocuments = approvalService.selectApprovalByStatus(userId, approvalStatus);
		model.addAttribute("approvalList" , myDocuments);
		model.addAttribute("statusHidden" , statusHidden);
		return "approval/approvalList";
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
