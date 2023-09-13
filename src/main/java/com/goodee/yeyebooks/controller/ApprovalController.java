package com.goodee.yeyebooks.controller;

import java.io.File;
import java.io.IOException;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import java.util.HashMap;
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
import com.goodee.yeyebooks.service.UserService;
import com.goodee.yeyebooks.vo.Account;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class ApprovalController {
	
	private final ApprovalService approvalService;
	@Autowired
	DeptService deptService;
	private Approval approval;
	
	@Autowired
	UserService userService;

	// 내 문서함 리스트 출력
	@Autowired
	public ApprovalController(ApprovalService approvalService) {
		this.approvalService = approvalService;
	}
	
	
	@GetMapping("/approval/approvalList")
	public String myApproval(Model model, 
							HttpSession session,
							@RequestParam(name = "status", defaultValue = "0") int status) {
		String userId = (String)session.getAttribute("userId");
		List<Approval> approvalList = approvalService.selectMyApproval(userId, status);
		log.debug("\u001B[35m"+"approvalList{} : ",approvalList);
		model.addAttribute("approvalList",approvalList);
		model.addAttribute("status", status);
		return "approval/approvalList";
	}
	
	 
	// 문서 상세보기
	@GetMapping("/approval/approvalOne")
	public String selectApprovalOne(Model model,
								HttpSession session,	
								@RequestParam(name = "aprvNo") String aprvNo) {
		Map<String, Object> approvalOne = approvalService.selectApprovalOne(aprvNo);
		List<Map<String,Object>> aprvLineInfo = new ArrayList<>();
		List<ApprovalLine> aprvLine = (List<ApprovalLine>)approvalOne.get("aprvLine");
		for(ApprovalLine al : aprvLine) {
			Map<String, Object> alInfo = new HashMap<>();
			alInfo.put("userId", al.getUserId());
			alInfo.put("aprvStat", al.getAprvStatCd());
			Map<String, Object> userInfo = userService.mypage(al.getUserId());
			User user = (User)userInfo.get("user");
			alInfo.put("userInfo", (user.getDept() == null ? "" : user.getDept()) + " " + user.getRank() + " " + user.getUserNm());
			if(userInfo.get("signFile") != null) {
				UserFile userFile = (UserFile)userInfo.get("signFile");
				alInfo.put("userSign", userFile.getPath() + userFile.getSaveFilename());
			}
			
			
			aprvLineInfo.add(alInfo);
		}
		Approval approval = (Approval)approvalOne.get("approval");
		model.addAttribute("aprvLine", aprvLineInfo);
		model.addAttribute("approval", approval);
		model.addAttribute("aprvFile", approvalOne.get("aprvFile"));
		model.addAttribute("approvalUser", approvalOne.get("approvalUser"));
		
		if(approval.getDocCatCd().equals("01")){
			model.addAttribute("account", approvalOne.get("account"));
		}
		
		if(approval.getDocCatCd().equals("02")){
			model.addAttribute("dayoff", approvalOne.get("dayoff"));
		}
		return "approval/approvalOne";
	}
	
	@GetMapping("/approval/cancelApproval")
	public String updateAprvStatCd(Model model,
								HttpSession session,
								@RequestParam String aprvNo) {
		approvalService.updateAprvStatCd(aprvNo);
	    return "redirect:/approval/approvalList";
	}
	
	@PostMapping("/approval/rejectApproval")
	public String updaterjctReason(HttpSession session,
								@RequestParam String aprvNo,
								@RequestParam String rejectReason) {
		String userId = (String)session.getAttribute("userId");
		approvalService.updaterjctReason(aprvNo, rejectReason, userId);
		return "redirect:/approval/approvalList";
	}

	
	// 문서작성
	@GetMapping("/approval/addApproval")
	public String addApproval(Model model, HttpSession session, String docCatCd) {
		String userId = (String)session.getAttribute("userId");
		
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
	public String addApproval(HttpServletRequest request, Approval approval, Account account,
							@RequestParam(name="approvalLine") String[] approvalLine,
							HttpSession session) {
		
		log.debug("\u001B[41m"+ "aprvController" + approval + "\u001B[0m");	
		
		String userId = (String)session.getAttribute("userId");
		approval.setUserId(userId);
		System.out.println("ApprovalController approvalLine[0] : " + approvalLine[0]);
		// RealPath를 붙혀야 경로를 안다.
		String path = request.getServletContext().getRealPath("/approvalFile/");
		log.debug("\u001B[35m" + "path" + path + "\u001B[0m");
		approvalService.addApproval(approval, approvalLine, path, account);
		log.debug("\u001B[35m"+ approval + "입력 board" + "\u001B[0m");	
		//log.debug("\u001B[41m"+ row + "입력 row" + "\u001B[0m");	
		return "redirect:/approval/approvalList?docCatCd="+approval.getDocCatCd();
	}

	/*
	 * @PostMapping("approval/addApproval") public String Account() {
	 * 
	 * return ""; }
	 */
	
	@PostMapping("approval/approveApproval")
	public String approvaApproval(@RequestParam String aprvNo,
								HttpSession session) {
		String userId = (String)session.getAttribute("userId");
		String lastUser = approvalService.selectLastApprovalUser(aprvNo);
		approvalService.updateApproveApprovalLine(aprvNo, userId);
		if(userId.equals(lastUser)) {
			approvalService.updateApproveApproval(aprvNo);
		}
		return "approval/approvalList";
	}
	
}
