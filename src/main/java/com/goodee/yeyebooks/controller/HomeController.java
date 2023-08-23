package com.goodee.yeyebooks.controller;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.service.UserService;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class HomeController {
	@Autowired
	UserService userService;
	@Autowired
	ApprovalService approvalService;
	
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
		log.debug("\u001B[42m" + "현재 접속한 아이디 : " + loginId + "\u001B[0m");
		
		if(loginId.equals("admin")) {
			return "adminHome";
		}
		
		Map<String, Object> userInfo = userService.mypage(loginId);
		User user = (User)userInfo.get("user");
		UserFile photoFile = (UserFile)userInfo.get("photoFile");
		
		session.setAttribute("userNm", user.getUserNm());
		session.setAttribute("userRank", user.getDept() + " " + user.getRank());
		if(photoFile != null) {
			session.setAttribute("userImg", photoFile.getPath() + photoFile.getSaveFilename());
		}
		
		if(userInfo.get("signFile") == null) {
			return "redirect:/mypage";
		}
		
		Map<String, Object> approvalWaitingCnt = approvalService.getApprovalWaitingCnt(loginId);
		model.addAttribute("approvalCnt", approvalWaitingCnt.get("approvalCnt"));
		model.addAttribute("approveCnt", approvalWaitingCnt.get("approveCnt"));
		
		return "userHome";
	}
}
