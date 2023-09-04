package com.goodee.yeyebooks.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
	Map<String, String> convertString = new HashMap<>() {{
	    put("예약완료", "isBooking");
	    put("이용중", "isUsing");
	    put("이용완료", "isUsed");
	    put("예약취소", "isCanceled");
	}};
	
	@GetMapping("/booking/myBooking")
	public String myBooking(Model model,
							HttpSession session,
							HttpServletRequest request,
							 @RequestParam(value = "status[]", required=false) List<String> status,
							 @RequestParam(required=false) String searchCat,
							 @RequestParam(required=false) String searchNm,
							 @RequestParam(defaultValue="1") int currentPage) {
		List<String> selectedStatus;
		if(status != null) {
			System.out.println("BookingController status : " + status);
			selectedStatus = status;
		}else {
			selectedStatus = new ArrayList<>();
			selectedStatus.add("예약완료");
			selectedStatus.add("이용중");
		}
		for(String stat : selectedStatus) {
			model.addAttribute(convertString.get(stat), "checked");
		}
		String userId = (String)session.getAttribute("userId");
		List<Booking> myBookingList = bookingService.selectMyBooking(selectedStatus, userId, searchCat, searchNm);
		List<String> bookingCategory = bookingService.selectBookingCategory();
		model.addAttribute("bookingCategory", bookingCategory);
		model.addAttribute("myBookingList", myBookingList);
		return "booking/myBooking";
	}
}
