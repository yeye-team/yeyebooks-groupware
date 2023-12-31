package com.goodee.yeyebooks.restapi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.BookingService;
import com.goodee.yeyebooks.vo.Booking;
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
	@GetMapping("/booking/bookingList")
	public ResponseEntity<List<Map<String, Object>>> getBookingList(){
		List<Map<String, Object>> bookingList = new ArrayList<>();
		List<Booking> selectedBookingList = bookingService.selectBookingListByDate();
		for(Booking bk : selectedBookingList) {
			Map<String, Object> booking = new HashMap<>();
			booking.put("id", bk.getBkgNo());
			booking.put("resourceId", bk.getTrgtNo());
			booking.put("start", bk.getBkgStartTime());
			booking.put("end", bk.getBkgEndTime());
			booking.put("selectable", false);
;			bookingList.add(booking);
		}
		return new ResponseEntity<>(bookingList, HttpStatus.OK);
	}
	@GetMapping("/booking/isOverlap")
	public ResponseEntity<String> checkIsOverlap(String bookingStart, String bookingEnd, int targetNo){
		int overlapCnt = bookingService.selectOverlapCnt(bookingStart, bookingEnd, targetNo);
		if (overlapCnt == 0) {
            return ResponseEntity.status(HttpStatus.OK).body("{\"success\": true}");
        } else {
            return ResponseEntity.status(HttpStatus.OK).body("{\"success\": false}");
        }
	}
	@PostMapping("/booking/addBooking")
	public ResponseEntity<Map<String, Object>> addBooking(HttpSession session, Booking booking) {
		String userId = (String)session.getAttribute("userId");
		booking.setUserId(userId);
		bookingService.insertBooking(booking);
		
		Map<String, Object> responseData = new HashMap<>();
        responseData.put("bkgNo", booking.getBkgNo());
        
		if(booking.getBkgNo() == 0) {
			responseData.put("success", false);
		}else {
			responseData.put("success", true);
		}
		 return ResponseEntity.status(HttpStatus.OK).body(responseData);
	}
}
