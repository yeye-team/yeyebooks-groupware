package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Booking;

@Mapper
public interface BookingMapper {
	List<Booking> selectMyBooking(List<String> status, String userId);
}
