package com.goodee.yeyebooks.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.UserService;

import lombok.extern.slf4j.Slf4j;

@RestController
@ResponseBody
@Slf4j
public class LoginController {
	@Autowired
	UserService userService;
	@PostMapping("/login")
	public String login(HttpSession session,
						HttpServletResponse response,
						@RequestParam(name="userId") String userId,
						@RequestParam(name="userPw") String userPw,
						@RequestParam(name="isRemember") boolean isRemember) {
		
		int result = userService.login(userId, userPw);
		log.debug("\u001B[42m" + "로그인 정보 조회 결과 : " + result + "\u001B[0m");
		
		log.debug("\u001B[42m" + "아이디 저장 여부 : " + isRemember + "\u001B[0m");
		
		if(isRemember) {
			Cookie cookie = new Cookie("rememberId", userId);
			// 한달 동안 쿠키가 지속되도록 설정
			cookie.setMaxAge(2592000);
			cookie.setPath("/");
			response.addCookie(cookie);
		}else {
			Cookie cookie = new Cookie("rememberId", "");
			cookie.setMaxAge(0);
			cookie.setPath("/");
			response.addCookie(cookie);
		}
		
		// 로그인 실패
		if(result == 0) {
			return "{\"success\": false}";
		}
		// 로그인 성공
		session.setAttribute("userId", userId);
		return "{\"success\": true}";
	}
}
