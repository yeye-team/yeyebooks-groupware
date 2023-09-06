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
import com.goodee.yeyebooks.service.UserService;
import com.goodee.yeyebooks.vo.Booking;
import com.goodee.yeyebooks.vo.User;

@Controller
public class BookingController {
	@Autowired
	BookingService bookingService;
	@Autowired
	UserService userService;
	
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
		int listCnt = bookingService.selectMyBookingCnt(selectedStatus, userId, searchCat, searchNm);
		
		int rowPerPage = 10;
		int pagePerPage = 5;
		
		int lastPage = listCnt / rowPerPage;
		if(listCnt % rowPerPage != 0) {
			lastPage++;
		}
		
		int startRow = (currentPage - 1) * rowPerPage;
		
		int minPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
		int maxPage = minPage + pagePerPage;
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		
		List<Booking> myBookingList = bookingService.selectMyBooking(selectedStatus, userId, searchCat, searchNm, startRow, rowPerPage);
		List<String> bookingCategory = bookingService.selectBookingCategory();
		
		model.addAttribute("bookingCategory", bookingCategory);
		model.addAttribute("myBookingList", myBookingList);
		model.addAttribute("searchNm", searchNm);
		model.addAttribute("searchCat", searchCat);
		model.addAttribute("minPage", minPage);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("lastPage", lastPage);
		
		return "booking/myBooking";
	}
	
	@GetMapping("/booking/bookingOne")
	public String bookingOne(@RequestParam int bkgNo,
							Model model) {
		Booking booking = bookingService.selectBookingOne(bkgNo);
		User user = userService.selectUserInfo(booking.getUserId()); 
		model.addAttribute("booking", booking);
		model.addAttribute("user", user);
		return "booking/bookingOne";
	}
	
	@GetMapping("/booking/deleteBooking")
	public String deleteBooking(@RequestParam int bkgNo) {
		bookingService.deleteBooking(bkgNo);
		return "redirect:/booking/myBooking";
	}
}
