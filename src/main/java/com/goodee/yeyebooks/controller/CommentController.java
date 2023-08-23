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
	
	// 댓글입력
	@PostMapping("board/addComment")
	public String addComment(HttpServletRequest request,
						@RequestParam(name="comment") String comment, int boardNo, String userId) {
		Comment c = new Comment();
		c.setBoardNo(boardNo);
		c.setUserId(userId);
		c.setCmntContents(comment);
		
		int row = commentService.addComment(c);
		//log.debug("\u001B[41m"+ "CommentController Post row : " + row + "\u001B[0m");
		
		return "redirect:/board/boardOne?boardNo="+boardNo;
	}
	
	// 댓글 수정
	@PostMapping("board/modifyComment")
	public String modifyComment(HttpServletRequest request,
							@RequestParam(name="cmntNo") int cmntNo,
							@RequestParam(name="modifyComment") String cmntContents, 
							int boardNo) {
		
		commentService.modifyComment(cmntNo, cmntContents);
		
		return "redirect:/board/boardOne?boardNo="+boardNo;
	}
	
	// 댓글 삭제
	@PostMapping("board/deleteComment")
	public String deleteComment(HttpServletRequest request,
								@RequestParam(name="cmntNo") int cmntNo,
								int boardNo) {
		
		commentService.deleteComment(cmntNo);
		
		return "redirect:/board/boardOne?boardNo="+boardNo;
	}
}
