package com.goodee.yeyebooks.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.UserService;

@RestController
@ResponseBody
public class LoginController {
	@Autowired
	UserService userService;
	@PostMapping("/login")
	public String login(HttpSession session,
						@RequestParam(name="userId") String userId,
						@RequestParam(name="userPw") String userPw) {
		int result = userService.login(userId, userPw);
		System.out.println("로그인 정보 조회 결과 : " + result);
		// 로그인 실패
		if(result == 0) {
			return "{\"success\": false}";
		}
		// 로그인 성공
		session.setAttribute("userId", userId);
		return "{\"success\": true}";
	}
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "/login";
	}
}
