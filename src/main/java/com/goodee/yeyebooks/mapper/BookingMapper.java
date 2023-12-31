package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Booking;
import com.goodee.yeyebooks.vo.BookingTarget;

@Mapper
public interface BookingMapper {
	List<Booking> selectMyBooking(List<String> status, String userId, String searchCat, String searchNm, int startRow, int rowPerPage);
	int selectMyBookingCnt(List<String> status, String userId, String searchCat, String searchNm);
	List<String> selectBookingCategory();
	Booking selectBookingOne(int bkgNo);
	int deleteBooking(int bkgNo);
	List<Booking> selectBookingListByDate();
	int selectOverlapCnt(String bookingStart, String bookingEnd, int targetNo);
	int insertBooking(Booking booking);
	void updateBookingStartSchedule();
	void updateBookingEndSchedule();
}
