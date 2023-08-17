package com.goodee.yeyebooks.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	@GetMapping("/")
	public String home(HttpSession session) {
		// userId정보가 없으면(로그인 안된 상태) 로그인페이지로
		if(session.getAttribute("userId") == null) {
			return "login";
		}
		String loginId = (String)session.getAttribute("userId");
		System.out.println("현재 접속한 아이디 : " + loginId);
		if(loginId.equals("admin")) {
			return "adminHome";
		}
		return "userHome";
	}
}
