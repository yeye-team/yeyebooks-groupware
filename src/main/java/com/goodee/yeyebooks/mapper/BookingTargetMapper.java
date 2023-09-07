package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.BookingTarget;

@Mapper
public interface BookingTargetMapper {
	List<BookingTarget> selectBookingTarget();
}
