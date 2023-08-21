package com.goodee.yeyebooks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.yeyebooks.vo.Comment;

@Mapper
public interface CommentMapper {
	// 댓글 입력
	int addComment(Comment comment);
	
	// 게시물 별 댓글 조회
	List<Map<String, Object>> selectComment(int boardNo);
}
