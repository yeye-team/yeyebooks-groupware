package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.User;

@Mapper
public interface BoardMapper {
	// 게시판 별 게시물 리스트 조회
	List<Board> selectBoard(Map<String, Object> map);
	
	// 게시판 별 게시물 전체 개수
	int selectBoardCount(String boardCatCd);
	
	// 부서 게시판 조회를 위한 사용자 부서 코드 조회
	String selectUserDept (String userId);
	
	// 공지사항 상세 조회
	Board selectnNoticeOne(int boardNo);
	
}
