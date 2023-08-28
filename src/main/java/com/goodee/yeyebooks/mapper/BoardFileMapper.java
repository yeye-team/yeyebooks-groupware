package com.goodee.yeyebooks.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.goodee.yeyebooks.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	// 첨부파일 조회
	List<BoardFile> selectBoardFile(int boardNo);
	
	// 첨부파일 등록
	int insertBoardfile(BoardFile boardfile);
	
	// 첨부파일 삭제
	int deleteBoardfile(int boardNo);
	
	// 게시물 수정시 삭제되는 기존 파일
	int deleteModifyFile(int boardNo, List<Integer> boardFileNos);
	
	// 게시물 수정시 삭제되는 실제 파일 정보
	List<BoardFile> selectBoardFileNos(@Param("boardFileNos") List<Integer> boardFileNos);
}
