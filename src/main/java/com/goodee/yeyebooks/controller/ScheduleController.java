package com.goodee.yeyebooks.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
	public String boardList(Model model,HttpSession session) {
		String loginId = (String)session.getAttribute("userId");
		log.debug("\u001B[41m" + "로그인아이디 : " + loginId + "\u001B[0m");
		
		// 오늘의 일정 리스트 모델에 셋팅
		List<Schedule> scheduleList = scheduleService.selectTodaySchedule(loginId);
		model.addAttribute("scheduleList", scheduleList);
		
		return "/schedule";
	}
	
	// 일정 상세 조회
	@GetMapping("/scheduleList")
	public List<Schedule> selectDateSchedule(@RequestParam String targetDate) {
		List<Schedule> dateSchedule = scheduleService.selectDateSchedule(targetDate);
		log.debug("\u001B[41m" + "scheduleController dateSchedule : " + dateSchedule + "\u001B[0m");
		
		return dateSchedule;
	}
}
