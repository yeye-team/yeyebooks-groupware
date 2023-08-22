package com.goodee.yeyebooks.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	@PostMapping("/mypage")
	public String updateMypage(HttpServletRequest request,
							@RequestParam String photo,
							@RequestParam String userId,
							@RequestParam int userFileNo,
							@RequestParam String userNm,
							@RequestParam String phoneNo) {
		if(photo != "") {
			String path = request.getServletContext().getRealPath("/empImg/");
			userService.updateUserFile(photo, path, userId, "사진", userFileNo);
		}
		userService.updateUserInfoByUser(userNm, phoneNo, userId);
		return "mypage";
	}
	
	@PostMapping("/changePw")
	public String chagePw(Model model,
						@RequestParam String userId) {
		model.addAttribute("userId", userId);
		return "changePw";
	}
}
