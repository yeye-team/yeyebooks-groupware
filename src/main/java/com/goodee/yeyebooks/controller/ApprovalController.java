package com.goodee.yeyebooks.controller;

import java.io.File;
import java.io.IOException;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.service.DeptService;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class ApprovalController {
	
	private final ApprovalService approvalService;
	@Autowired
	DeptService deptService;
	private Approval approval;

	/*
	 * @GetMapping("/approval/addApproval") public String getDeptList(Model model) {
	 * List<Map<String, Object>> deptList = deptService.getUserCntByDept();
	 * List<Map<String, Object>> userList = deptService.getUserListByDept();
	 * List<Map<String, Object>> userCnt = deptService.getUserCntByDeptAndAll();
	 * 
	 * model.addAttribute("deptList",deptList);
	 * model.addAttribute("userList",userList);
	 * model.addAttribute("userCnt",userCnt);
	 * 
	 * log.debug("\u001B[35m"+"deptList{} : ",deptList);
	 * log.debug("\u001B[35m"+"userCnt{} : ",userCnt);
	 * log.debug("\u001B[35m"+"userList{} : ",userList);
	 * 
	 * return "approval/addApproval"; }
	 */
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

	@GetMapping("/approval/addApproval")
	public String addApproval(Model model, HttpSession session, String docCatCd) {
		String userId = "admin";
		//log.debug("\u001B[41m"+ "addBoard loginUserId : " + userId + "\u001B[0m");	
		//log.debug("\u001B[41m"+ "addBoard boardCatCd : " + boardCatCd + "\u001B[0m");
		
		List<Map<String, Object>> mainMenu = approvalService.getUserCntByDeptAndAll();
		//log.debug("\u001B[41m"+ "addBoard mainMenu : " + mainMenu + "\u001B[0m");
		List<Map<String, Object>> deptList = deptService.getUserCntByDept();
		List<Map<String, Object>> userList = deptService.getUserListByDept();
		List<Map<String, Object>> userCnt = deptService.getUserCntByDeptAndAll();
		
		model.addAttribute("deptList",deptList);
		model.addAttribute("userList",userList);
		model.addAttribute("userCnt",userCnt);
		
		model.addAttribute("userId", userId);
		model.addAttribute("docCatCd", docCatCd);
		model.addAllAttributes(mainMenu);
		return("/approval/addApproval");
	}
	
	@PostMapping("/approval/addApproval")	
	public String addApproval(HttpServletRequest request, Approval approval) {
		// RealPath를 붙혀야 경로를 안다.
		String path = request.getServletContext().getRealPath("/approvalFile/");
		log.debug("\u001B[41m" + "path" + path + "\u001B[0m");
		approvalService.addApproval(approval, path);
		log.debug("\u001B[41m"+ approval + "입력 board" + "\u001B[0m");	
		//log.debug("\u001B[41m"+ row + "입력 row" + "\u001B[0m");	
		return "redirect:/approval/approvalList?docCatCd="+approval.getDocCatCd();
	}

}
