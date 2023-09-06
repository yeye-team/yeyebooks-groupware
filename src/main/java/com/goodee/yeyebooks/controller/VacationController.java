package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.VacationService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class VacationController {
	@Autowired
	private VacationService vacationService;
	
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
}
