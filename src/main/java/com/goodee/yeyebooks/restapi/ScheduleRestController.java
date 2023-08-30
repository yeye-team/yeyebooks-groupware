package com.goodee.yeyebooks.restapi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.yeyebooks.service.ScheduleService;

@Controller
@RequestMapping("/events")
public class ScheduleRestController {
	@Autowired
    private ScheduleService scheduleService;

    @GetMapping
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getEvents(Model model,HttpSession session, @RequestParam(required = false) String category) {
    	List<Map<String, Object>> monthScheduleList;
    	String userId = (String)session.getAttribute("userId");
    	if(category == null) {
    		monthScheduleList = scheduleService.selectMonthSchedule(userId);
    	} else if (userId == "admin") {
    		monthScheduleList = scheduleService.selectAdminSchedule();
    	} else {
    		monthScheduleList = scheduleService.selectFilteredMonthSchedule(userId,category);
    	}
        
    	model.addAttribute("userId", userId);
    	
        return ResponseEntity.ok(monthScheduleList);
    }
	
}
