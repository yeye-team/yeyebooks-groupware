package com.goodee.yeyebooks.controller;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.goodee.yeyebooks.service.ApprovalService;
import com.goodee.yeyebooks.service.BoardService;
import com.goodee.yeyebooks.service.ScheduleService;
import com.goodee.yeyebooks.service.UserService;
import com.goodee.yeyebooks.service.UserTimeService;
import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.Schedule;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;
import com.goodee.yeyebooks.vo.UserTime;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class HomeController {
	@Autowired
	UserService userService;
	@Autowired
	ApprovalService approvalService;
	@Autowired
	BoardService boardService;
	@Autowired
	ScheduleService scheduleService;
	@Autowired
	UserTimeService userTimeService;
	
	String[] allowedIp = {"192.168.7.146", "172.30.1.99", "192.168.5.7", "192.168.25.27", "192.168.1.82", "192.168.1.29"};
	
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
		
		Map<String, Object> userInfo = userService.mypage(loginId);
		User user = (User)userInfo.get("user");
		UserFile photoFile = (UserFile)userInfo.get("photoFile");
		
		// navbar에 들어갈 이름 세션에 저장
		session.setAttribute("userNm", user.getUserNm());
		
		if(loginId.equals("admin")) {
			Map<String, Object> joinLeaveCnt = userService.selectRecentJoinLeaveCnt();
			Map<String, Object> fmCnt = userService.selectFMCnt();
			Map<String, Object> totalUserCnt = userService.selectRecentTotalUserCnt();
			model.addAttribute("joinCnt", joinLeaveCnt.get("joinCnt"));
			model.addAttribute("leaveCnt", joinLeaveCnt.get("leaveCnt"));
			model.addAttribute("monthNames", joinLeaveCnt.get("monthNames"));
			model.addAttribute("mCnt", (fmCnt.get("남자") != null ? fmCnt.get("남자") : 0));
			model.addAttribute("fCnt", (fmCnt.get("여자") != null ? fmCnt.get("여자") : 0));
			model.addAttribute("yearMonthList", totalUserCnt.get("yearMonthList"));
			model.addAttribute("totalUserCnt", totalUserCnt.get("totalUserCnt"));
			return "adminHome";
		}
		
		// navbar에 들어갈 팀+직급 세션에 저장
		String dept = user.getDept() == null ? "" : user.getDept();
		session.setAttribute("userRank", dept + " " + user.getRank());
		
		// navbar에 들어갈 이미지 세션에 저장
		if(photoFile != null) {
			session.setAttribute("userImg", photoFile.getPath() + photoFile.getSaveFilename());
		}
		
		if(userInfo.get("signFile") == null) {
			return "redirect:/mypage";
		}
		// IP 가져와서 비교
		InetAddress ipAddress;
		try {
			ipAddress = InetAddress.getLocalHost();
			String nowIp = ipAddress.getHostAddress();
			log.debug("\u001B[42m" + "현재 아이피 : " + nowIp + "\u001B[0m");
			boolean isInCompany = false;
			
			for(String ip : allowedIp) {
				if(nowIp.equals(ip)) {
					isInCompany = true;
					break;
				}
			}
			
			model.addAttribute("isInCompany", isInCompany);
			
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        
        
		// 대기중인 문서건수 모델에 셋팅
		Map<String, Object> approvalWaitingCnt = approvalService.getApprovalWaitingCnt(loginId);
		model.addAttribute("approvalCnt", approvalWaitingCnt.get("approvalCnt"));
		model.addAttribute("approveCnt", approvalWaitingCnt.get("approveCnt"));
		
		// 최근 공지사항 리스트 모델에 셋팅
		List<Board> noticeList = boardService.selectRecentNotice();
		model.addAttribute("noticeList", noticeList);
		
		// 오늘의 일정 리스트 모델에 셋팅
		List<Schedule> scheduleList = scheduleService.selectTodaySchedule(loginId);
		model.addAttribute("scheduleList", scheduleList);
		
		// 오늘의 출근기록 모델에 셋팅
		UserTime userTime = userTimeService.selectTodayWorkTime(loginId);
		if(userTime != null) {
			model.addAttribute("workStartTime", userTime.getWorkStartTime());
			model.addAttribute("workEndTime", userTime.getWorkEndTime());
		}
		
		return "userHome";
	}
}
