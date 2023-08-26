package com.goodee.yeyebooks.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.UserTimeService;

@Controller
public class UserTimeController {
	@Autowired
	UserTimeService userTimeService;
	
	@PostMapping("/workStart")
	public String workStart(HttpSession session,
							@RequestParam String workStartTime) {
		String userId = (String)session.getAttribute("userId");
		userTimeService.insertTodayWorkStartTime(userId, workStartTime);
		return "userHome";
	}
	@PostMapping("/workEnd")
	public String workEnd(HttpSession session,
							@RequestParam String workEndTime) {
		String userId = (String)session.getAttribute("userId");
		userTimeService.updateTodayWorkEndTime(userId, workEndTime);
		return "userHome";
	}
}
