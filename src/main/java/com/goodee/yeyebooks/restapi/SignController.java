package com.goodee.yeyebooks.restapi;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.UserService;

@RestController
public class SignController {
	@Autowired
	UserService userService;
	
	@PostMapping("/addSign")
	public String addSign(HttpServletRequest request,
						@RequestParam String sign,
						@RequestParam String userId,
						@RequestParam int userFileNo) {
		String path = request.getServletContext().getRealPath("/empImg/");
		String filename = userService.updateUserFile(sign, path, userId, "사인", userFileNo);
		return "empImg/" + userId + "/" + filename;
	}
}
