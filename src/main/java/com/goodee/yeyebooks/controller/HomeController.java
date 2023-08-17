package com.goodee.yeyebooks.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	@GetMapping("/")
	public String home(HttpSession session,
					Model model,
					HttpServletRequest request) {
		String rememberId = null;
		boolean isRemember = false;
		
		Cookie[] cookies = request.getCookies();
		
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("rememberId")) {
					rememberId = (String)cookie.getValue();
					isRemember = true;
				}
			}
		}
		
		// userId정보가 없으면(로그인 안된 상태) 로그인페이지로
		if(session.getAttribute("userId") == null) {
			model.addAttribute("rememberId", rememberId);
			model.addAttribute("isRemember", isRemember);
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
