package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.goodee.yeyebooks.service.DeptService;

@Controller
public class DeptController {
	@Autowired
	DeptService deptService;
	
	@GetMapping("/dept")
	public String getDeptList(Model model) {
		List<Map<String, Object>> deptList = deptService.getDeptList();
		List<Map<String, Object>> userList = deptService.getUserListByDept();
		
		model.addAttribute("deptList",deptList);
		model.addAttribute("userList",userList);
		return "emp/deptList";
	}
}
