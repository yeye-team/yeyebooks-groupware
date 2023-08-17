package com.goodee.yeyebooks.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	List<BoardFile> selectNoticeFile(int boardNo);
}
