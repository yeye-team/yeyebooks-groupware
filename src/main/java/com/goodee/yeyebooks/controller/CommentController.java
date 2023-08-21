package com.goodee.yeyebooks.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.service.CommentService;
import com.goodee.yeyebooks.vo.Comment;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommentController {
	@Autowired
	private CommentService commentService;
	
	@PostMapping("board/addComment")
	// 댓글입력
	public String addComment(HttpServletRequest request,
						@RequestParam(name="comment") String comment, int boardNo, String loginId, String userId) {
		Comment c = new Comment();
		c.setBoardNo(boardNo);
		c.setUserId(loginId);
		c.setCmntContents(comment);
		
		int row = commentService.addComment(c);
		log.debug("\u001B[41m"+ "CommentController Post row : " + row + "\u001B[0m");
		
		return "redirect:/board/boardOne?boardNo="+boardNo+"&userId="+userId;
	}
}
