package com.goodee.yeyebooks.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

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

	// 게시판 별 게시물 리스트 조회
	public Map<String, Object> selectBoardList(HttpSession session, int currentPage, int rowPerPage, String boardCatCd) {
		// 첫행
		int beginRow = (currentPage - 1) * rowPerPage;

		String userId = (String)session.getAttribute("userId");
		log.debug("\u001B[41m" + userId + "< userId" + "\u001B[0m");
		String deptCd = boardMapper.selectUserDept(userId);
		log.debug("\u001B[41m" + deptCd + "< deptCd" + "\u001B[0m");

		// 부서게시판 클릭시 부서 value값과 동일하다면 사용자의 부서코드를 저장
		if (boardCatCd.equals("dept")) {
			boardCatCd = deptCd;
		}
		
		// map에 담아 변수로 넘기게
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		paramMap.put("boardCatCd", boardCatCd);
		log.debug("\u001B[41m" + paramMap + "< paramMap" + "\u001B[0m");

		// 각 리스트 조회
		List<Map<String, Object>> selectBoard = boardMapper.selectBoard(paramMap);
		log.debug("\u001B[41m" + selectBoard + "< selectBoard" + "\u001B[0m");

		// 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = boardMapper.selectAllCatCode();
		log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
		// ================ 페이지 =================
		// 페이징을 위한 게시판 별 게시물 전체 개수
		int boardCount = boardMapper.selectBoardCount(boardCatCd);

		// 마지막행
		int endRow = beginRow + (rowPerPage - 1);
		if (endRow > boardCount) {
			endRow = boardCount;
		}

		// 페이지 선택 버튼
		int pagePerPage = 5;

		// 마지막 페이지
		int lastPage = boardCount / rowPerPage;
		if (boardCount % rowPerPage != 0) {
			lastPage += 1; // lastPage =lastPage +1;
		}

		// 페이지 선택 버튼 최소값
		int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;

		// 페이지 선택 버튼 최대값
		int maxPage = minPage + (pagePerPage - 1);
		if (maxPage > lastPage) {
			maxPage = lastPage;
		}

		// ========================================

		// 맵에 담아 넘기기
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("selectBoard", selectBoard);
		resultMap.put("currentPage", currentPage);
		resultMap.put("lastPage", lastPage);
		resultMap.put("endRow", endRow);
		resultMap.put("pagePerPage", pagePerPage);
		resultMap.put("minPage", minPage);
		resultMap.put("maxPage", maxPage);
		resultMap.put("userId", userId);
		resultMap.put("selectAllCatCode",selectAllCatCode);

		return resultMap;
	}

	// 게시물 상세조회 
	public Map<String, Object> getBoardOne(int boardNo, String userId) {
		Map<String, Object> map = new HashMap<>(); 
		// 게시물 정보
		map.put("board", boardMapper.selectBoardOne(boardNo)); 
		// 첨부파일 정보
		map.put("boardFile", boardfileMapper.selectBoardFile(boardNo));
		// 게시자 정보
		map.put("user", boardMapper.selectUser(userId));
		log.debug("\u001B[41m"+ boardMapper.selectUser(userId) + "< BoardService getBoardOne user" + "\u001B[0m");
		
		return map; 
	}
	
	// 조회수 증가
	public int updateView(int boardNo) {
		int row = boardMapper.updateView(boardNo);
		log.debug("\u001B[41m"+ "boardService row : " + row + "\u001B[0m");
		
		return row;
	}
	
}
