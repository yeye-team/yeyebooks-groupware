package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.User;

@Mapper
public interface BoardMapper {
	// 게시판 별 게시물 리스트 조회
	List<Map<String, Object>> selectBoard(Map<String, Object> map);
	
	// 게시판 별 게시물 전체 개수
	int selectBoardCount(String boardCatCd);
	
	// 부서 게시판 조회를 위한 사용자 부서 코드,부서 이름 조회
	Map<String, Object> selectUserDept (String userId);
	
	// 관리자일 때 모든 부서 코드 조회
	List<Map<String, Object>> selectAllCatCode();
	
	// 게시물 상세 조회
	Map<String, Object> selectBoardOne(int boardNo);
	
	// 조회수 증가
	int updateView(int boardNo);
	
	// 게시물 등록
	int insertBoard(Board board);
	
	// 게시물 수정
	int modifyBoard(int boardNo);
	
	// 게시물 삭제
	int deleteBoard(int boardNo);
	
	// 최근 공지사항 리스트 조회
	List<Board> selectRecentNotice();
}
