package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.BoardFile;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	@Autowired
	private BoardService boardService;
	@GetMapping("/board/boardList")
	// 공지사항 리스트 조회
	public String boardList(Model model,
							@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
							@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage,
							@RequestParam(name = "boardCatCd", defaultValue = "00") String boardCatCd) {
		Map<String,Object> resultMap = boardService.selectBoardList(currentPage, rowPerPage, boardCatCd);
		log.debug("\u001B[41m"+ resultMap + "< BoardController Get resultMap" + "\u001B[0m");	
		
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
	public String chgBoardList(HttpServletRequest request,
								@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
								@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage,
								@RequestParam(name = "boardCatCd") String boardCatCd) {
		
		Map<String,Object> resultMap = boardService.selectBoardList(currentPage, rowPerPage, boardCatCd);
		log.debug("\u001B[41m"+ resultMap + "< BoardController Post resultMap" + "\u001B[0m");
		
		return "redirect:/board/boardList?boardCatCd="+boardCatCd;
	}
	
	// 게시물 상세조회
	
	@GetMapping("/board/boardOne") 
	public String getBoardOne(Model model,
							@RequestParam(name = "boardNo") int boardNo,
							@RequestParam(name = "userId") String userId) { 
	Map<String, Object> map = boardService.getBoardOne(boardNo, userId);
	
	Board board = (Board)map.get("board"); 
	log.debug("\u001B[41m"+ board + "< BoardController getBoardOne board" + "\u001B[0m");
	
	BoardFile boardFile = (BoardFile) map.get("boardFile");
	log.debug("\u001B[41m"+ boardFile + "< BoardController getBoardOne boardFile" + "\u001B[0m");
	
	Map<String, Object> user = (Map<String, Object>)map.get("user");
	log.debug("\u001B[41m"+ user + "< BoardController getBoardOne user" + "\u001B[0m");
	
	model.addAllAttributes(map); 
	/*
	 * model.addAttribute("board",map.get("board"));
	 * model.addAttribute("boardFile",map.get("boardFile"));
	 * model.addAttribute("user",map.get("user"));
	 */
	
	return "/board/boardOne"; }
	 
}	