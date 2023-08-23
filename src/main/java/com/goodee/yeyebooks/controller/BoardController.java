package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.BoardFile;
import com.goodee.yeyebooks.vo.Comment;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.service.BoardService;
import com.goodee.yeyebooks.service.CommentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	@Autowired
	private BoardService boardService;
	@Autowired
	private CommentService commentService;
	
	@GetMapping("/board/boardList")
	// 게시물 리스트 조회
	public String boardList(Model model,HttpSession session,
							@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
							@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage,
							@RequestParam(name = "boardCatCd", defaultValue = "00") String boardCatCd) {
		
		Map<String,Object> resultMap = boardService.selectBoardList(session, currentPage, rowPerPage, boardCatCd);
		//log.debug("\u001B[41m"+ resultMap + "< BoardController Get resultMap" + "\u001B[0m");	
		
		// 맵에 있는거 한번에 넘기기
		model.addAttribute("boardCatCd",boardCatCd);
		model.addAllAttributes(resultMap);
		
		// 맵에 있는거 각각 넘기기
		/*
		 * model.addAttribute("selectBoard", resultMap.get("selectBoard"));
		 * model.addAttribute("currentPage", resultMap.get("currentPage"));
		 * model.addAttribute("lastPage", resultMap.get("lastPage"));
		 * model.addAttribute("endRow", resultMap.get("endRow"));
		 * model.addAttribute("pagePerPage", resultMap.get("pagePerPage"));
		 * model.addAttribute("minPage", resultMap.get("minPage"));
		 * model.addAttribute("maxPage", resultMap.get("maxPage"));
		 */
		
		return "/board/boardList";
	}
	@PostMapping("board/boardList")
	// 게시판이 바뀔때마다 게시판 코드를 변수로 리스트 값을 변경
	public String chgBoardList(HttpServletRequest request, HttpSession session,
								@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
								@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage,
								@RequestParam(name = "boardCatCd") String boardCatCd) {
		
		Map<String,Object> resultMap = boardService.selectBoardList(session, currentPage, rowPerPage, boardCatCd);
		log.debug("\u001B[41m"+ resultMap + "< BoardController Post resultMap" + "\u001B[0m");
		
		return "redirect:/board/boardList?boardCatCd="+boardCatCd;
	}
	
	// 게시물 상세조회
	@GetMapping("/board/boardOne") 
	public String getBoardOne(Model model, HttpSession session, HttpServletRequest request,  HttpServletResponse response,
							int boardNo) { 
		// 게시물 정보 + 첨부파일 정보
		Map<String, Object> map = boardService.getBoardOne(session, boardNo);
		log.debug("\u001B[41m" + "Controller boardOne map : " + map + "\u001B[0m");
		
		// 댓글 작성시 사용
		String userId = (String)session.getAttribute("userId");
		//log.debug("\u001B[41m" + "Controller boardOne userId : " + userId + "\u001B[0m");
		
		// 게시물 댓글 정보
		List<Map<String, Object>> commentList = commentService.selectComment(boardNo);
		//log.debug("\u001B[41m"+ "BoardController getBoardOne commentList : " + commentList + "\u001B[0m");
		
		// 상세조회 시 조회수 1 증가
		// 쿠키 사용
		Cookie[] cookies = request.getCookies();
		// 기본값 조회x
	    boolean viewed = false;
	    
	    // 쿠키를 확인, 게시물 조회 여부를 확인하여 일치하는게 있다면 break처리
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if (cookie.getName().equals("viewed_" + boardNo)) {
	                viewed = true;
	                break;
	            }
	        }
	    }
	    // 조회안했다면 조회처리, 조회수 1추가
	    if (!viewed) {
			int updateView = boardService.updateView(boardNo);
			log.debug("\u001B[41m"+ "BoardController getBoardOne updateView : " + updateView + "\u001B[0m");
	
	        // 게시물 번호를 쿠키에 추가
	        Cookie viewedCookie = new Cookie("viewed_" + boardNo, "true");
	        // 쿠키 유효기간 1일 설정
	        viewedCookie.setMaxAge(24 * 60 * 60);
	        response.addCookie(viewedCookie);
	    }
		
		model.addAllAttributes(map); 
		model.addAttribute("commentList", commentList);
		model.addAttribute("userId", userId);
		
		return "/board/boardOne"; 
	}
	
	// 게시물 작성
	@GetMapping("/board/addBoard")
	public String addBoard(Model model, HttpSession session, String boardCatCd) {
		String userId = (String)session.getAttribute("userId");
		log.debug("\u001B[41m"+ "addBoard loginUserId : " + userId + "\u001B[0m");	
		log.debug("\u001B[41m"+ "addBoard boardCatCd : " + boardCatCd + "\u001B[0m");
		
		model.addAttribute("userId", userId);
		model.addAttribute("boardCatCd", boardCatCd);
		return("/board/addBoard");
	}
	
	@PostMapping("/board/addBoard")	
	public String addBoard(HttpServletRequest request, Board board) {
		String path = request.getServletContext().getRealPath("/boardFile/");
		int row = boardService.insertBoard(board, path);
		log.debug("\u001B[41m"+ row + "입력 row" + "\u001B[0m");	
		return "redirect:/board/boardList";
	}
}	