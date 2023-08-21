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
	
	public List<Map<String, Object>> getUserListByDept(){
		List<Map<String, Object>> list = deptMapper.selectUserListByDept();
		return list;
	}
	
	public List<Map<String, Object>> getUserCntByDept(){
		List<Map<String, Object>> list = deptMapper.selectUserCntByDept();
		return list;
	}
	
	public int addDept(Map<String, Object> map) {
		int row = deptMapper.insertDept(map);
		return row;
	}
	
	public int modifyDept(Map<String, Object> map) {
		int row = deptMapper.updateDept(map);
		return row;
	}
	
	public int removeDept(Map<String, Object> map) {
		int row = deptMapper.deleteDept(map);
		return row;
	}
}
