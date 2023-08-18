package com.goodee.yeyebooks.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
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
	
	// 내문서함 불러오기
	@GetMapping("approval/approvalList")
	public String getMyDocuments(@RequestParam String userId, Model model) {
		String approvalStatus = "A001";
		List<Approval> myDocuments = approvalService.selectApprovalByStatus(userId, userId);
		model.addAttribute("documents" , myDocuments);
		return "approvalList";
	}
	
	@PostMapping("approval/approvalList")
	public String getMyDocuments1(@ModelAttribute("userId")String userId, Model model) {
		return "apprivalList";
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