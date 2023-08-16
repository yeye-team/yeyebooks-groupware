package com.goodee.yeyebooks.mapper;

import java.util.List;

import com.goodee.yeyebooks.vo.BoardFile;


public interface BoardFileMapper {
	List<BoardFile> selectBoardFile(int boardNo);
}
