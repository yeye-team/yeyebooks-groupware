package com.goodee.yeyebooks.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.BookingService;
import com.goodee.yeyebooks.vo.Booking;

@Controller
public class BookingController {
	@Autowired
	BookingService bookingService;
	
	@GetMapping("/booking/myBooking")
	public String myBooking(Model model,
							HttpSession session,
							@RequestParam(required = false) List<String> status ) {
		Map<String, String> convertString = new HashMap<>();
		convertString.put("예약완료", "isBooking");
		convertString.put("이용중", "isUsing");
		convertString.put("이용완료", "isUsed");
		convertString.put("예약취소", "isCanceled");
		
		List<String> selectedStatus = status;
		if(selectedStatus == null) {
			selectedStatus = new ArrayList<>();
			selectedStatus.add("예약완료");
			selectedStatus.add("이용중");
		}
		for(String stat : selectedStatus) {
			model.addAttribute(convertString.get(stat), "checked");
		}
		String userId = (String)session.getAttribute("userId");
		List<Booking> myBookingList = bookingService.selectMyBooking(selectedStatus, userId);
		model.addAttribute("myBookingList", myBookingList);
		return "booking/myBooking";
	}
}
