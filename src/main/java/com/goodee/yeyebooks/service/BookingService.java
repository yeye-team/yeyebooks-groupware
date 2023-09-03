package com.goodee.yeyebooks.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.BookingMapper;
import com.goodee.yeyebooks.vo.Booking;

@Service
public class BookingService {
	@Autowired
	BookingMapper bookingMapper;
	
	public List<Booking> selectMyBooking(List<String> status, String userId){
		return bookingMapper.selectMyBooking(status, userId);
	}
}