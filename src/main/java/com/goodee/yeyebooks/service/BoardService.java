package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.yeyebooks.mapper.BoardFileMapper;
import com.goodee.yeyebooks.mapper.BoardMapper;
import com.goodee.yeyebooks.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class BoardService {
	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private BoardFileMapper boardfileMapper;
	
	// 공지사항 리스트 조회
	public Map<String, Object> selectNoticeList(int currentPage, int rowPerPage) {
		// 첫행
		int beginRow = (currentPage-1) * rowPerPage;
		
		// map에 담아 변수로 넘기게
		Map<String, Object> paramMap = new HashMap<String,Object>();
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		log.debug("\u001B[31m"+ paramMap + "< paramMap" + "\u001B[0m");	
		
		// 공지사항 리스트 조회
		List<Board> selectNotice = boardMapper.selectNotice(paramMap);
		log.debug("\u001B[31m"+ selectNotice + "< selectNotice" + "\u001B[0m");	
		
		// 페이징을 위한 공지사항 전체 개수 
		int boardCount = boardMapper.selectNoticeCount();
		
		// ================ 페이지 =================
		// 마지막행
		int endRow = beginRow + (rowPerPage -1);
		if(endRow > boardCount) {
			endRow = boardCount;
		}
		
		// 페이지 선택 버튼
		int pagePerPage = 5;
			
		// 마지막 페이지
		int lastPage = boardCount / rowPerPage;
		if(boardCount % rowPerPage != 0) {
			lastPage += 1; // lastPage =lastPage +1; 
		}
		
		// 페이지 선택 버튼 최소값
		int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
		
		// 페이지 선택 버튼 최대값
		int maxPage = minPage + (pagePerPage - 1);
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		// ========================================
		
		// 맵에 담아 넘기기
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("selectNotice", selectNotice);
		resultMap.put("currentPage", currentPage);
		resultMap.put("lastPage", lastPage);
		resultMap.put("endRow", endRow);
		resultMap.put("pagePerPage", pagePerPage);
		resultMap.put("minPage", minPage);
		resultMap.put("maxPage", maxPage);
		
		return resultMap;
	}
	
	// 공지사항 상세조회
	public Map<String, Object> getBoardOne(int boardNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("board", boardMapper.selectnNoticeOne(boardNo));
		map.put("boardFiles", boardfileMapper.selectBoardFile(boardNo));
		
		return map;
	}
}
