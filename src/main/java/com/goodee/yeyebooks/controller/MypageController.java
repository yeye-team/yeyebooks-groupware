package com.goodee.yeyebooks.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.goodee.yeyebooks.service.UserService;
import com.goodee.yeyebooks.vo.User;

@Controller
public class MypageController {
	@Autowired
	UserService userService;
	@GetMapping("/mypage")
	public String mypage(HttpSession session,
						Model model) {
		String userId = (String)session.getAttribute("userId");
		Map<String, Object> userInfo = userService.mypage(userId);
		model.addAttribute("user", userInfo.get("user"));
		model.addAttribute("photoFile", userInfo.get("photoFile"));
		model.addAttribute("signFile", userInfo.get("signFile"));
		return "mypage";
	}
}
