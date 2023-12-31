package com.goodee.yeyebooks.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.BookingMapper;
import com.goodee.yeyebooks.mapper.BookingTargetMapper;
import com.goodee.yeyebooks.vo.Booking;
import com.goodee.yeyebooks.vo.BookingTarget;

@Service
public class BookingService {
	@Autowired
	BookingMapper bookingMapper;
	
	@Autowired
	BookingTargetMapper bookingTargetMapper;
	
	public List<Booking> selectMyBooking(List<String> status, String userId, String searchCat, String searchNm, int startRow, int rowPerPage){
		return bookingMapper.selectMyBooking(status, userId, searchCat, searchNm, startRow, rowPerPage);
	}
	
	public List<String> selectBookingCategory(){
		return bookingMapper.selectBookingCategory();
	}
	public int selectMyBookingCnt(List<String> status, String userId, String searchCat, String searchNm) {
		return bookingMapper.selectMyBookingCnt(status, userId, searchCat, searchNm);
	}
	public Booking selectBookingOne(int bkgNo) {
		return bookingMapper.selectBookingOne(bkgNo);
	}
	public int deleteBooking(int bkgNo) {
		return bookingMapper.deleteBooking(bkgNo);
	}
	
	public List<BookingTarget> selectBookingTarget(){
		return bookingTargetMapper.selectBookingTarget();
	}
	
	public List<Booking> selectBookingListByDate(){
		return bookingMapper.selectBookingListByDate();
	}
	public int selectOverlapCnt(String bookingStart, String bookingEnd, int targetNo) {
		return bookingMapper.selectOverlapCnt(bookingStart, bookingEnd, targetNo);
	}
	public int insertBooking(Booking booking) {
		return bookingMapper.insertBooking(booking);
	}
	
	@Scheduled(cron = "0 0/30 * * * *")
	public void bookingScheduling() {
		bookingMapper.updateBookingStartSchedule();
		bookingMapper.updateBookingEndSchedule();
	}
}
