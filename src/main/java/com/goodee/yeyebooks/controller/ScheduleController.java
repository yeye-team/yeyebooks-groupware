package com.goodee.yeyebooks.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.ScheduleService;
import com.goodee.yeyebooks.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScheduleController {
	@Autowired
	private ScheduleService scheduleService;
	
	@GetMapping("/schedule")
	// 일정 메인 조회(홈)
	public String scheduleList(Model model,HttpSession session) {
		String loginId = (String)session.getAttribute("userId");
		log.debug("\u001B[41m" + "로그인아이디 : " + loginId + "\u001B[0m");
		
		// 오늘의 일정 리스트 모델에 셋팅
		List<Schedule> scheduleList = scheduleService.selectTodaySchedule(loginId);
		
		model.addAttribute("scheduleList", scheduleList);
		
		return "/schedule";
	}
	
}
