package com.goodee.yeyebooks.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.DeptMapper;

@Service
public class DeptService {
	@Autowired
	DeptMapper deptMapper;
	
	public List<Map<String, Object>> getDeptList(){
		List<Map<String, Object>> list = deptMapper.selectDeptList();
		return list;
	}
	
}
