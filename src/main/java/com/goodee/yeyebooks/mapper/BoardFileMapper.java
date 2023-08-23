package com.goodee.yeyebooks.mapper;


import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	// 첨부파일 조회
	BoardFile selectBoardFile(int boardNo);
	
	// 첨부파일 등록
	int insertBoardfile(BoardFile boardfile);
}
