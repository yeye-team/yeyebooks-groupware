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

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DeptController {
	@Autowired
	DeptService deptService;
	
	@GetMapping("/dept")
	public String getDeptList(Model model) {
		List<Map<String, Object>> deptList = deptService.getDeptList();
		List<Map<String, Object>> userList = deptService.getUserListByDept();
		List<Map<String, Object>> userCnt = deptService.getUserCntByDept();
		
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
		
		return "redirect:/dept";
	}
	
	@PostMapping("/modifyDept")
	public String modifyDept(String deptNm, String deptCd) {
		Map<String, Object> map = new HashMap<>();
		map.put("deptNm", deptNm);
		map.put("deptCd", deptCd);
		deptService.modifyDept(map);
		
		return "redirect:/dept";
	}
	
	@GetMapping("/removeDept")
	public String removeDept(String deptCd) {
		Map<String, Object> map = new HashMap<>();
		map.put("deptCd", deptCd);
		deptService.removeDept(map);
		
		return "redirect:/dept";
	}
	
	@PostMapping("/modifyUserDept")
	public String modifyUserDept(@RequestParam(name = "userId", required = false) String userId, String deptCd) {
		if(userId != null) {
			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("deptCd", deptCd);
			deptService.modifyUserDept(map);
		}
		
		return "redirect:/dept";
	}
}
