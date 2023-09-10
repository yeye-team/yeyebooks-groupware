package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.yeyebooks.service.VacationService;
import com.goodee.yeyebooks.vo.Approval;
import com.goodee.yeyebooks.vo.ApprovalFile;
import com.goodee.yeyebooks.vo.ApprovalLine;
import com.goodee.yeyebooks.vo.Dayoff;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class VacationController {
	@Autowired
	private VacationService vacationService;
	
	// 휴가 신청 내역
	@GetMapping("/vacationList")
	public String vacationList(Model model, HttpSession session,
								@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
								@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage,
								@RequestParam(required = false) String searchDate) {
		//log.debug("\u001B[41m" + "vaca Controller currentPage : " + currentPage + "\u001B[0m");
		//log.debug("\u001B[41m" + "vaca Controller rowPerPage : " + rowPerPage + "\u001B[0m");
		//log.debug("\u001B[41m" + "vaca Controller searchDate : " + searchDate + "\u001B[0m");
		
		Map<String,Object> selectVacationList = vacationService.selectVacationList(session, currentPage, rowPerPage, searchDate);
		//log.debug("\u001B[41m" + "vaca Controller selectList" + selectVacationList + "\u001B[0m");
		
		model.addAllAttributes(selectVacationList);
		
		return "/vacationList";
	}
	
	// 휴가 신청
	@GetMapping("/addVacation")
	public String addVacation(Model model, HttpSession session) {
		
		Map<String, Object> map = vacationService.addVactionForm(session);
		
		model.addAllAttributes(map);
		
		return "/addVacation";
	}
	
	@PostMapping("addVacation")
	public String addVaction(HttpSession session,
							HttpServletRequest request,
							Approval approval, 
							@RequestParam(name="lineUserId") String[] approvalLine, 
							Dayoff dayOff, 
							String[] dayoffYmd,
							@RequestParam(required = false) MultipartFile multipartFile) {
		//log.debug("\u001B[41m" + "controller approvalLine" + approvalLine + "\u001B[0m");
		
		int row = vacationService.addVacation(request, session, approval, approvalLine, dayOff, dayoffYmd, multipartFile);
		
		if(row != 1) {
			log.debug("\u001B[41m" + "입력실패" + "\u001B[0m");
			return "redirect:/addVacation";
		}
		
		return "redirect:/vacationList";
	}
	
}
