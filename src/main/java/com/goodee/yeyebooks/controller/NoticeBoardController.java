package com.goodee.yeyebooks.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.yeyebooks.vo.Board;
import com.goodee.yeyebooks.vo.BoardFile;
import com.goodee.yeyebooks.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class NoticeBoardController {
	@Autowired
	private BoardService boardService;
	@GetMapping("/board/noticeBoard")
	// 공지사항 리스트 조회
	public String noticeList(Model model,
							@RequestParam(name = "currentPage", defaultValue = "1") int currentPage, 
							@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage) {
		Map<String,Object> resultMap = boardService.selectNoticeList(currentPage, rowPerPage);
		log.debug("\u001B[31m"+ resultMap + "< NoticeBoardController resultMap" + "\u001B[0m");	
		
		model.addAttribute("selectNotice", resultMap.get("selectNotice"));
		model.addAttribute("currentPage", resultMap.get("currentPage"));
		model.addAttribute("lastPage", resultMap.get("lastPage"));
		model.addAttribute("endRow", resultMap.get("endRow"));
		model.addAttribute("pagePerPage", resultMap.get("pagePerPage"));
		model.addAttribute("minPage", resultMap.get("minPage"));
		model.addAttribute("maxPage", resultMap.get("maxPage"));
		
		return "/board/noticeBoard";
	}
	
	/*
	 * // 공지사항 상세조회
	 * 
	 * @GetMapping("/board/noticeOne") public String getBoardOne(Model model,
	 * 
	 * @RequestParam(name = "boardNo") int boardNo) { Map<String, Object> map =
	 * boardService.getBoardOne(boardNo);
	 * 
	 * Board board = (Board)map.get("board"); List<BoardFile> boardFiles =
	 * (List<BoardFile>) map.get("boardFiles");
	 * 
	 * model.addAttribute("board", board); model.addAttribute("boardFile",
	 * boardFiles);
	 * 
	 * return "/board/noticeOne"; }
	 */
}	