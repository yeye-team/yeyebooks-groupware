package com.goodee.yeyebooks.restapi;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.controller.ScheduleController;
import com.goodee.yeyebooks.service.ScheduleService;
import com.goodee.yeyebooks.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/events")
public class ScheduleRestController {
	@Autowired
    private ScheduleService scheduleService;

	// 일정 조회
    @GetMapping("/everySchedule")
    public ResponseEntity<List<Map<String, Object>>> getEvents(HttpSession session, @RequestParam(required = false) String skdCatCd) {
    	String userId = (String)session.getAttribute("userId");
    	log.debug("\u001B[41m" + "RestAPI getEvents skdCatCd : " + skdCatCd + "\u001B[0m");
    	
    	// 카테고리별로 일정 조회 구분
    	List <Schedule> schedules = null;
    	if(skdCatCd == null) {
    		schedules = scheduleService.selectMonthSchedule(userId);
    		log.debug("\u001B[41m" + "RestAPI getEvents all : " + schedules + "\u001B[0m");
    	} else if (userId == "admin") {
    		schedules = scheduleService.selectAdminSchedule();
    		log.debug("\u001B[41m" + "RestAPI getEvents admin : " + schedules + "\u001B[0m");
    	} else {
    		schedules = scheduleService.selectFilteredMonthSchedule(userId,skdCatCd);
    		log.debug("\u001B[41m" + "RestAPI getEvents other : " + schedules + "\u001B[0m");
    	}
    	
    	List<Map<String, Object>> monthScheduleList = new ArrayList<>();
    	for(Schedule schedule : schedules) {
    		Map<String, Object> eventData = new HashMap<>();
    		// 일정시작시간
    		LocalDate startDate = LocalDate.parse(schedule.getSkdStartYmd());
    		LocalTime startTime = LocalTime.parse(schedule.getSkdStartTime());
    		LocalDateTime startDateTime = LocalDateTime.of(startDate, startTime);
    		// 일정종료시간
    		LocalDate endDate = LocalDate.parse(schedule.getSkdEndYmd());
    		LocalTime endTime = LocalTime.parse(schedule.getSkdEndTime());
    		LocalDateTime endDateTime = LocalDateTime.of(endDate, endTime);
    		
    		String catCd = null;
    		String title = null;
    		if(schedule.getSkdCatCd().equals("00")) {
    			catCd = "회사";
    			title = "[" + catCd + "] " + schedule.getSkdTitle();
    		} else if(schedule.getSkdCatCd().equals("99")){
    			catCd = "개인";
    			title = "[" + catCd + "] " + schedule.getSkdTitle();
    		} else {
    			catCd = "부서";
    			title = "[" + catCd + "] " + schedule.getSkdTitle();
    		}
            // FullCalendar 표시데이터
            eventData.put("id", schedule.getSkdNo());
            eventData.put("title", title);
            eventData.put("start", startDateTime.toString());
            eventData.put("end", endDateTime.toString());
            monthScheduleList.add(eventData);
    	}
    	
    	//log.debug("\u001B[41m" + "RestAPI getEvents monthScheduleList : " + monthScheduleList + "\u001B[0m");
    	
    	return new ResponseEntity<>(monthScheduleList, HttpStatus.OK);
    }
	
    // 일정 상세
    @GetMapping("/scheduleOne") // skdNo에 해당하는 일정 상세 정보 가져오기
    public ResponseEntity<Schedule> scheduleOne(@RequestParam int skdNo) {
    	log.debug("\u001B[41m" + "RestAPI scheduleOne skdNo : " + skdNo + "\u001B[0m");
        Schedule scheduleOne = scheduleService.selectDateSchedule(skdNo);
        
    	// 일정 시작 시간 및 종료 시간을 12시간 AM/PM 형식으로 변환
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a", Locale.ENGLISH);
        LocalDateTime startDateTime = LocalDateTime.parse(scheduleOne.getSkdStartYmd() + " " + scheduleOne.getSkdStartTime(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime endDateTime = LocalDateTime.parse(scheduleOne.getSkdEndYmd() + " " + scheduleOne.getSkdEndTime(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        String formattedStartDateTime = startDateTime.format(formatter);
        String formattedEndDateTime = endDateTime.format(formatter);
    
        String skdCatCd = scheduleOne.getSkdCatCd();
        String catCdTitle = "";
        if (skdCatCd.equals("00")) {
            catCdTitle = "회사";
        } else if (skdCatCd.equals("99")) {
            catCdTitle = "개인";
        } else {
            catCdTitle = "부서";
        };
        
        // 타이틀에 카테고리와 일정 이름 추가
        String modifiedTitle = "[" + catCdTitle + "] " + scheduleOne.getSkdTitle();
        
        scheduleOne.setSkdStartYmd(formattedStartDateTime);
        scheduleOne.setSkdEndYmd(formattedEndDateTime);
        scheduleOne.setSkdTitle(modifiedTitle);
        
        log.debug("\u001B[41m" + "RestAPI scheduleOne scheduleOne : " + scheduleOne + "\u001B[0m");
        
        return new ResponseEntity<>(scheduleOne, HttpStatus.OK);
    }

    // 일정 수정
    @PostMapping("/modifySchedule")
    public ResponseEntity<Map<String, Object>> modifySchedule(@RequestBody Schedule schedule) {
    	log.debug("\u001B[41m" + "RestAPI modifySchedule schedule : " + schedule + "\u001B[0m");
    	
        Map<String, Object> response = new HashMap<>();

        try {
            int row = scheduleService.modifySchedule(schedule);
            if (row == 1) {
                response.put("success", true);
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("success", false);
                response.put("message", "수정 실패");
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "수정 오류");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 일정 삭제
    @PostMapping("/deleteSchedule")
    public ResponseEntity<Map<String, Object>> deleteSchedule(int skdNo) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        int row = scheduleService.deleteSchedule(skdNo);
	        if (row == 1) {
	            response.put("success", true);
	            return new ResponseEntity<>(response, HttpStatus.OK);
	        } else {
	            response.put("success", false);
	            response.put("message", "삭제실패");
	            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "삭제오류");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
}
