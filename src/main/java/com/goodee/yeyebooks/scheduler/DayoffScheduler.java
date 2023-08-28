package com.goodee.yeyebooks.scheduler;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.yeyebooks.mapper.DeptMapper;
import com.goodee.yeyebooks.vo.User;

@Component
public class DayoffScheduler {
	@Autowired
	DeptMapper deptMapper;
	
	List<Map<String, Object>> getUserTenureList(){
		return deptMapper.selectUserTenureList();
	}

	@Scheduled(cron="0 30 01 * * *")
	public void modifyUserDayoffCnt() {
		List<Map<String, Object>> list = getUserTenureList();
		
		for(Map<String, Object> m : list) {
			int yearCnt = Integer.parseInt(String.valueOf(m.get("yearCnt")));
			if(yearCnt > 0) {
				int plusDayoff = yearCnt / 2;
				User u = new User();
				u.setUserId((String)m.get("userId"));
				u.setDayoffCnt(plusDayoff+15);
				deptMapper.updateUserDayoffCnt(u);
			} else {
				int monthCnt = Integer.parseInt(String.valueOf(m.get("monthCnt")));
				User u = new User();
				u.setUserId((String)m.get("userId"));
				u.setDayoffCnt(monthCnt);
				deptMapper.updateUserDayoffCnt(u);
			}
		}
	}
}
