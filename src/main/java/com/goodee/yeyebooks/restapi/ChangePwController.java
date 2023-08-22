package com.goodee.yeyebooks.restapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.UserService;

@RestController
@ResponseBody
public class ChangePwController {
	@Autowired
	UserService userService;
	
	@PostMapping("/updatePw")
	public String updatePw(@RequestParam String userId,
							@RequestParam String userPw,
							@RequestParam String originPw) {
		int row = userService.login(userId, originPw);
		
		if(row == 0) {
			return "{\"success\": false}";
		}else {
			userService.updateUserPw(userId, userPw);
		}
		
		return "{\"success\": true}";
	}
}
