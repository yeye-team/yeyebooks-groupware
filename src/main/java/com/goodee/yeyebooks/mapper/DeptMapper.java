package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface DeptMapper {
	List<Map<String, Object>> selectDeptList();
	
	int insertDept(Map<String, Object> map);
	
	int deleteDept(Map<String, Object> map);
	
	int updateDept(Map<String, Object> map);
	
	List<Map<String, Object>> selectUserListByDept();
	
	List<Map<String, Object>> selectUserCntByDept();
}
