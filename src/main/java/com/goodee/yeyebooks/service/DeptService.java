package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.DeptMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
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
	
	public int modifyUserDept(Map<String, Object> map) {
		log.debug("\u001B[44m"+map.get("userId")+"\u001B[0m");
		String[] userIdList = ((String)map.get("userId")).split(",");
		String deptCd = (String)map.get("deptCd");
		int row = 0;
		
		for (String s : userIdList) {
			log.debug("\u001B[44m"+s+"\u001B[0m");
			Map<String, Object> m = new HashMap<>();
			m.put("deptCd", deptCd);
			m.put("userId", s);
			row += deptMapper.updateUserDept(m);
		}
		return row;
	}
	
	public List<Map<String, Object>> getDeptNmList(){
		List<Map<String, Object>> list = deptMapper.selectDeptNmList();
		return list;
	}
}
