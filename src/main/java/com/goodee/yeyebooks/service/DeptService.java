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
	
	public List<Map<String, Object>> getDeptList(){
		List<Map<String, Object>> list = deptMapper.selectDeptList();
		return list;
	}
	
	public List<Map<String, Object>> getRankList(){
		List<Map<String, Object>> list = deptMapper.selectRankList();
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
		int joinNo = deptMapper.selectjoinYmdCnt(user.getJoinYmd()) + 1;
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
}
