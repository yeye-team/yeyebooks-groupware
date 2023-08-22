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
public class DeptRest {
	@Autowired
	DeptService deptService;
	
	@GetMapping("/rest/deptNameList")
	public List<Map<String, Object>> getLocalNmList(){
		return deptService.getDeptNmList();	
	}
}
