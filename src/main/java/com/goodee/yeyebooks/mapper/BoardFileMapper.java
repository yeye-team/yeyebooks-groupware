package com.goodee.yeyebooks.mapper;


import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	BoardFile selectBoardFile(int boardNo);
}
