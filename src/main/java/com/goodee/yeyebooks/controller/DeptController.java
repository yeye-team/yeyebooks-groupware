package com.goodee.yeyebooks.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.DeptService;
import com.goodee.yeyebooks.vo.User;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DeptController {
	@Autowired
	DeptService deptService;
	
	@GetMapping("/deptList")
	public String getDeptList(Model model) {
		List<Map<String, Object>> deptList = deptService.getUserCntByDept();
		List<Map<String, Object>> userList = deptService.getUserListByDept();
		List<Map<String, Object>> userCnt = deptService.getUserCntByDeptAndAll();
		
		model.addAttribute("deptList",deptList);
		model.addAttribute("userList",userList);
		model.addAttribute("userCnt",userCnt);
		
		return "user/deptList";
	}
	
	@PostMapping("/addDept")
	public String addDept(String deptNm) {
		Map<String, Object> map = new HashMap<>();
		map.put("deptNm", deptNm);
		deptService.addDept(map);
		
		return "redirect:/deptList";
	}
	
	@PostMapping("/modifyDept")
	public String modifyDept(String deptNm, String deptCd) {
		Map<String, Object> map = new HashMap<>();
		map.put("deptNm", deptNm);
		map.put("deptCd", deptCd);
		deptService.modifyDept(map);
		
		return "redirect:/deptList";
	}
	
	@GetMapping("/removeDept")
	public String removeDept(String deptCd) {
		Map<String, Object> map = new HashMap<>();
		map.put("deptCd", deptCd);
		deptService.removeDept(map);
		
		return "redirect:/deptList";
	}
	
	@PostMapping("/modifyUserDept")
	public String modifyUserDept(@RequestParam(name = "userId", required = false) String userId, String deptCd) {
		if(userId != null) {
			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("deptCd", deptCd);
			deptService.modifyUserDept(map);
		}
		
		return "redirect:/deptList";
	}
	
	@GetMapping("/userList")
	public String getUserList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage, @RequestParam(name = "rowPerPage", defaultValue = "8") int rowPerPage) {
		Map<String, Object> map = deptService.getUserList(currentPage, rowPerPage);
		map.put("currentPage", currentPage);
		
		model.addAllAttributes(map);
		return "user/userList";
	}
	
	@PostMapping("/addUser")
	public String addUser(String userNm, String deptCd, String rankCd, String joinYmd, String gender) {
		User user = new User();
		user.setUserNm(userNm);
		user.setDeptCd(deptCd);
		user.setRankCd(rankCd);
		user.setJoinYmd(joinYmd);
		user.setGender(gender);
		int row = deptService.addUser(user);
		
		return "redirect:/userList";
	}
}
