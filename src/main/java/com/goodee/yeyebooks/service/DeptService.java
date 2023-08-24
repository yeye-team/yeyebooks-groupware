package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.DeptMapper;
import com.goodee.yeyebooks.vo.User;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DeptService {
	@Autowired
	DeptMapper deptMapper;
	
	public List<Map<String, Object>> getUserCntByDept(){
		List<Map<String, Object>> list = deptMapper.selectUserCntByDept();
		return list;
	}
	
	public List<Map<String, Object>> getUserListByDept(){
		List<Map<String, Object>> list = deptMapper.selectUserListByDept();
		return list;
	}
	
	public List<Map<String, Object>> getUserCntByDeptAndAll(){
		List<Map<String, Object>> list = deptMapper.selectUserCntByDeptAndAll();
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
	
	public int modifyUserDept(User user) {
		String[] userIdList = user.getUserId().split(",");
		String deptCd = user.getDeptCd();
		int row = 0;
		
		for (String s : userIdList) {
			User u = new User();
			u.setUserId(s);
			u.setDeptCd(deptCd);
			row += deptMapper.updateUserDept(u);
		}
		return row;
	}
	
	public List<Map<String, Object>> getDeptList(){
		List<Map<String, Object>> list = deptMapper.selectDeptList();
		return list;
	}
	
	public List<Map<String, Object>> getRankList(){
		List<Map<String, Object>> list = deptMapper.selectRankList();
		return list;
	}
	
	public List<Map<String, Object>> getUserStatList(){
		List<Map<String, Object>> list = deptMapper.selectUserStatList();
		return list;
	}
	
	public Map<String, Object> getUserList(int currentPage, int rowPerPage){
		int beginRow = (currentPage-1)*rowPerPage;
		List<Map<String, Object>> list = deptMapper.selectUserList(beginRow, rowPerPage);
		
		int totalRow = deptMapper.selectUserCnt();
		int lastPage = totalRow / rowPerPage;
		if (totalRow % rowPerPage != 0) {
			lastPage += 1;
		}
	
		int pagePerPage = 5;
		int minPage = (currentPage-1) / pagePerPage * pagePerPage + 1;
		int maxPage = minPage + pagePerPage - 1;
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		Map<String, Object> map = new HashMap<>();
		map.put("list", list);
		map.put("pagePerPage", pagePerPage);
		map.put("minPage", minPage);
		map.put("maxPage", maxPage);
		map.put("lastPage", lastPage);
		
		return map;
	}
	
	public int addUser(User user) {
		int joinNo = deptMapper.selectjoinYmdCnt(user) + 1;
		String userId = "y"+user.getJoinYmd().replace("-", "");
		if(joinNo > 9) {
			userId += joinNo;
		} else {
			userId += "0"+joinNo;
		}
		user.setUserId(userId);
		
		String mail = userId + "@yeye.co.kr";
		user.setMail(mail);
		
		if(user.getDeptCd().equals(" ")) {
			user.setDeptCd(null);
		}
		
		int row = deptMapper.insertUser(user);
		return row;
	}
	
	public int resetUserPw(User user) {
		int row = deptMapper.updateUserPwReset(user);
		return row;
	}
	
	public int modifyUser(User user) {
		int row = 0;
		if(user.getDeptCd() != null) {
			if(user.getDeptCd().equals(" ")) {
				user.setDeptCd(null);
			}
			row = deptMapper.updateUserDept(user);
		}
		
		if(user.getRankCd() != null) {
			row = deptMapper.updateUserRank(user);
		}
		
		if(user.getUserStatCd() != null) {
			row = deptMapper.updateUserStat(user);
		}
	
		return row;
	}
}
