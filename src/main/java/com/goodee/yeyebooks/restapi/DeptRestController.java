package com.goodee.yeyebooks.restapi;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.DeptService;

@CrossOrigin
@RestController
public class DeptRestController {
	@Autowired
	DeptService deptService;
	
	@GetMapping("/rest/deptList")
	public List<Map<String, Object>> getDeptList(){
		return deptService.getDeptList();	
	}
	
	@GetMapping("/rest/rankList")
	public List<Map<String, Object>> getRankList(){
		return deptService.getRankList();	
	}
	
	@GetMapping("/rest/userStatList")
	public List<Map<String, Object>> getUserStatList(){
		return deptService.getUserStatList();	
	}
}
