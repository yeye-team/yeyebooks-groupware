package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Board;

@Mapper
public interface BoardMapper {
	// 공지사항 리스트 조회
	List<Board> selectNotice(Map<String, Object> map);
	
	// 공지사항 상세 조회
	Board selectnNoticeOne(int boardNo);
	
	
	// 공지사항 전체 개수
	int selectNoticeCount();
	
}
