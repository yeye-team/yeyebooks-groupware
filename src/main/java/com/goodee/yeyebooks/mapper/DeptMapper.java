package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.User;


@Mapper
public interface DeptMapper {
	List<Map<String, Object>> selectUserCntByDept();
	
	int insertDept(Map<String, Object> map);
	
	int deleteDept(Map<String, Object> map);
	
	int updateDept(Map<String, Object> map);
	
	List<Map<String, Object>> selectUserListByDept();
	
	List<Map<String, Object>> selectUserCntByDeptAndAll();
	
	int updateUserDept(Map<String, Object> map);
	
	List<Map<String, Object>> selectDeptList();
	
	List<Map<String, Object>> selectUserList(int beginRow, int rowPerPage);
	
	int selectUserCnt();
	
	List<Map<String, Object>> selectRankList();
	
	int insertUser(User user);
	
	int selectjoinYmdCnt(String joinYmd);
}
