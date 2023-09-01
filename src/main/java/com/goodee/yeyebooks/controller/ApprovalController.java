package com.goodee.yeyebooks.controller;

import java.io.IOException;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.service.DeptService;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class ApprovalController {
	
	private final ApprovalService approvalService;
	@Autowired
	DeptService deptService;
	
	@GetMapping("/approval/addApproval")
	public String getDeptList(Model model) {
		List<Map<String, Object>> deptList = deptService.getUserCntByDept();
		List<Map<String, Object>> userList = deptService.getUserListByDept();
		List<Map<String, Object>> userCnt = deptService.getUserCntByDeptAndAll();
		
		model.addAttribute("deptList",deptList);
		model.addAttribute("userList",userList);
		model.addAttribute("userCnt",userCnt);
		
		log.debug("\u001B[35m"+"deptList{} : ",deptList);
		log.debug("\u001B[35m"+"userCnt{} : ",userCnt);
		log.debug("\u001B[35m"+"userList{} : ",userList);
		
		return "approval/addApproval";
	}
	
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
			
			
	/*
	 * // 문서작성
	 * 
	 * @GetMapping("/approval/addApproval") public String addApproval(Model model) {
	 * model.addAttribute("approval"); return "approval/addApproval"; // 문서 생성 폼을
	 * 보여주는 뷰로 리턴 }
	 */

	 @PostMapping("/approval/addApproval")
	    public String addApproval(HttpServletRequest request, Approval approval,
	            				@RequestParam("files") List<Approval> files,
	            				@RequestParam("approvalLine") List<ApprovalLine> approvalLine) {

	        String path = request.getServletContext().getRealPath("/approvalFiles/");
	        List<ApprovalFile> approvalFiles = new ArrayList<>();
	        
	        for (Approval file : files) {
	            ApprovalFile approvalFile = new ApprovalFile();
	            approvalFile.getOrginFilename();
	            approvalFile.getFiletype();
	            approvalFile.getPath();
	            approvalFiles.add(approvalFile);
	        }
	        
	        try {
	            int row = approvalService.addApproval(approval, approvalFiles, approvalLine);
	        } catch (IOException e) {
	            e.printStackTrace();
	        }

	        return "redirect:/approval/approvalList"; // 목록 페이지로 리디렉션
	    }

}
