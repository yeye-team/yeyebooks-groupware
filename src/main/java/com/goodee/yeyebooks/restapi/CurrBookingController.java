package com.goodee.yeyebooks.restapi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.BookingService;
import com.goodee.yeyebooks.vo.BookingTarget;

@RestController
public class CurrBookingController {
	@Autowired
	BookingService bookingService;
	
	@GetMapping("/booking/bookingTargets")
	public ResponseEntity<List<Map<String, Object>>> getBookingTarget(){
		List<Map<String, Object>> bkTargetList = new ArrayList<>();
		List<BookingTarget> selectedBkTarget = bookingService.selectBookingTarget();
		
		for(BookingTarget bt : selectedBkTarget) {
			Map<String, Object> bkTargetData = new HashMap<>();
			bkTargetData.put("id", bt.getTrgtNo());
			bkTargetData.put("building", bt.getTrgtCategory());
			bkTargetData.put("title", bt.getTrgtNm());
			bkTargetList.add(bkTargetData);
		}
		return new ResponseEntity<>(bkTargetList, HttpStatus.OK);
	}
}
