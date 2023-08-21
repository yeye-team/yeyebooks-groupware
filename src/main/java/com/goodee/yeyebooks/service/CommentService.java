package com.goodee.yeyebooks.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.yeyebooks.mapper.CommentMapper;
import com.goodee.yeyebooks.vo.Comment;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class CommentService {
	@Autowired
	private CommentMapper commentMapper;

	// 게시물별 댓글 조회
	public List<Map<String, Object>> selectComment(int boardNo){
		
		List<Map<String, Object>> commentList = commentMapper.selectComment(boardNo);
		log.debug("\u001B[41m"  + "commentList : "+ commentList + "\u001B[0m");
		
		return commentList;
	}
	
	// 게시물별 댓글 입력
	public int addComment(Comment comment) {
		return commentMapper.addComment(comment);
	}
	
	// 댓글 수정
	public int modify(Comment comment) {
		return commentMapper.modifyComment(comment);
	}
}
