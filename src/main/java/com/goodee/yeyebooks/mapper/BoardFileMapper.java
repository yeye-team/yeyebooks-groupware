package com.goodee.yeyebooks.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	// 첨부파일 조회
	List<BoardFile> selectBoardFile(int boardNo);
	
	// 첨부파일 등록
	int insertBoardfile(BoardFile boardfile);
	
	// 첨부파일 삭제
	int deleteBoardfile(int boardNo);
}
