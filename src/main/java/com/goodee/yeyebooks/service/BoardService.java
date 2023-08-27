package com.goodee.yeyebooks.service;

import java.io.File;


import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.yeyebooks.vo.BoardFile;
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

	// 사용자 : 본인부서 게시판 이름으로 관리자 : 메인메뉴에 뿌릴 전체 부서 게시판리스트
	public Map<String, Object> mainMenu(HttpSession session){
		String userId = (String)session.getAttribute("userId");
		
		Map<String, Object> map = new HashMap<>();
		
		List<Map<String, Object>> selectAllCatCode = boardMapper.selectAllCatCode();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		// 메인메뉴바 사용자 소속 부서 게시판 선택을 위한 사용자 부서 정보
		Map<String, Object> userDept = null;
		if(!userId.equals("admin")) {
			userDept = boardMapper.selectUserDept(userId);
			//log.debug("\u001B[41m" + userDept + "< userDept" + "\u001B[0m");
		}
		
		map.put("selectAllCatCode", selectAllCatCode);
		map.put("userDept", userDept);
		
		return map;
	}
	// 게시판 별 게시물 리스트 조회
	public Map<String, Object> selectBoardList(HttpSession session, int currentPage, int rowPerPage, String boardCatCd) {
		// 첫행
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 로그인 아이디
		String userId = (String)session.getAttribute("userId");
		//log.debug("\u001B[41m" + userId + "< userId" + "\u001B[0m");
		
		Map<String, Object> userDept = null;
		if(!userId.equals("admin")) {
			userDept = boardMapper.selectUserDept(userId);
			//log.debug("\u001B[41m" + userDept + "< userDept" + "\u001B[0m");
			
			// 부서게시판 클릭시 부서 value값과 동일하다면 사용자의 부서코드를 저장
			if (!boardCatCd.equals("00") && !boardCatCd.equals("99")) {
				boardCatCd = (String)userDept.get("deptCd");
				//log.debug("\u001B[41m" + boardCatCd + "< userDept.get(deptCd)" + "\u001B[0m");
			}
		}
		
		// map에 담아 변수로 넘기게
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		paramMap.put("boardCatCd", boardCatCd);
		//log.debug("\u001B[41m" + paramMap + "< paramMap" + "\u001B[0m");

		// 각 리스트 조회
		List<Map<String, Object>> selectBoard = boardMapper.selectBoard(paramMap);
		//log.debug("\u001B[41m" + selectBoard + "< selectBoard" + "\u001B[0m");

		// 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = boardMapper.selectAllCatCode();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
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
		resultMap.put("selectAllCatCode",selectAllCatCode);
		resultMap.put("userDept", userDept);

		return resultMap;
	}

	// 게시물 상세조회 
	public Map<String, Object> getBoardOne(HttpSession session, int boardNo) {

		// 로그인 아이디
		String userId = (String)session.getAttribute("userId");
		
		// 메인메뉴바 사용자 소속 부서 게시판 선택을 위한 사용자 부서 정보
		Map<String, Object> userDept = null;
		if(!userId.equals("admin")) {
			userDept = boardMapper.selectUserDept(userId);
			//log.debug("\u001B[41m" + userDept + "< userDept" + "\u001B[0m");
		}
		
		// 관리자 메인메뉴바 : 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = boardMapper.selectAllCatCode();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
		// 첨부파일
		List<BoardFile> boardFileList = boardfileMapper.selectBoardFile(boardNo);
		log.debug("\u001B[41m"+  "BoardService getBoardOne boardFileList : " + boardFileList + "\u001B[0m");
		
		Map<String, Object> map = new HashMap<>(); 
		// 게시물 정보
		map.put("board", boardMapper.selectBoardOne(boardNo)); 
		// 첨부파일 정보
		map.put("boardFile", boardFileList);
		// 메인메뉴바 구현 위한 유저정보
		map.put("userDept", userDept);
		// 메인메뉴바 관리자 구현
		map.put("selectAllCatCode",selectAllCatCode);
		
		//log.debug("\u001B[41m"+  "BoardService getBoardOne map : " + map + "\u001B[0m");
		
		return map; 
	}
	
	// 조회수 증가
	public int updateView(int boardNo) {
		int row = boardMapper.updateView(boardNo);
		log.debug("\u001B[41m"+ "boardService row : " + row + "\u001B[0m");
		
		return row;
	}
	
	// 게시글 입력
	public int insertBoard(Board board, String path) {
		//log.debug("\u001B[41m"+ "boardService board : " +  board + "\u001B[0m");
		
		// 관리자 메인메뉴바 : 모든 부서 코드 조회
		List<Map<String, Object>> selectAllCatCode = boardMapper.selectAllCatCode();
		//log.debug("\u001B[41m" + selectAllCatCode + "< selectAllCatCode" + "\u001B[0m");
		
		int row = boardMapper.insertBoard(board);
		//log.debug("\u001B[41m" + "insertBoard row : " + row + "\u001B[0m");
		// addboard 성공 및 첨부된 파일이 1개 이상 있다면
		List<MultipartFile> fileList = board.getMultipartFile();
		if(row == 1 && fileList != null && fileList.size() > 0) {
			int boardNo = board.getBoardNo();
			//log.debug("\u001B[41m" + "insertBoard boardFile boardNo : " + boardNo + "\u001B[0m");
			for(MultipartFile mf : fileList) { // 첨부 파일 개수만큼 반복
				if(mf.getSize() > 0) {
					BoardFile bf = new BoardFile();
					bf.setBoardNo(boardNo); // 부모키값
					bf.setOriginFilename(mf.getOriginalFilename()); // 파일원본이름
					bf.setFileCatCd("02");
					bf.setFiletype(mf.getContentType()); // 파일타입(MIME : Multipurpose Internet Mail Extensions = 파일변환타입)
					bf.setPath(path);
					
					// 저장될 파일 이름
					// 확장자
					int lastIdx = mf.getOriginalFilename().lastIndexOf(".");
					String ext = mf.getOriginalFilename().substring(lastIdx); // 마지막 .의 위치값 > 확장자 ex) A.jpg 에서 자른다
					//log.debug("\u001B[41m" + "insertBoard boardFile lastIdx : " + lastIdx + "\u001B[0m");
					//log.debug("\u001B[41m" + "insertBoard boardFile ext : " + ext + "\u001B[0m");
					// 새로운 이름 + 확장자
					bf.setSaveFilename(UUID.randomUUID().toString().replace("-", "") + ext); 
					
					// 테이블에 저장
					boardfileMapper.insertBoardfile(bf);
					// 파일저장(저장위치필요 > path변수 필요)
					// path 위치에 저장파일이름으로 빈파일을 생성
					File f = new File(path+bf.getSaveFilename());
					// 빈파일에 첨부된 파일의 스트림을 주입한다.
					log.debug("\u001B[41m" + "insertBoard boardFile f : " + f + "\u001B[0m");
					log.debug("\u001B[41m" + "insertBoard boardFile f.getAbsolutePath() : " + f.getAbsolutePath() + "\u001B[0m");
					try {
						mf.transferTo(f);
					} catch(IllegalStateException | IOException e) {
						// 트랜잭션 작동을 위해 예외 발생이 필요
						e.printStackTrace();
						// 트랜잭션 작동을 위해 예외(try catch 강요하지 않는 예외 ex) RuntimeException) 발생 필요
						throw new RuntimeException();
					}
				}
			}
		}
		return row;
	}
	
	// 게시물 수정
	public int modifyBoard(Board board) {
		int row = boardMapper.modifyBoard(board);
		/*
		 * // 게시물 수정된거 확인해서 지우기 List<MultipartFile> fileList = board.getMultipartFile();
		 * if(row == 1 && fileList != null && fileList.size() > 0) { int boardNo =
		 * board.getBoardNo(); //log.debug("\u001B[41m" +
		 * "insertBoard boardFile boardNo : " + boardNo + "\u001B[0m");
		 * for(MultipartFile mf : fileList) { // 첨부 파일 개수만큼 반복 if(mf.getSize() > 0) {
		 * BoardFile bf = new BoardFile(); bf.setBoardNo(boardNo); // 부모키값
		 * bf.setOriginFilename(mf.getOriginalFilename()); // 파일원본이름
		 * bf.setFileCatCd("02"); bf.setFiletype(mf.getContentType()); // 파일타입(MIME :
		 * Multipurpose Internet Mail Extensions = 파일변환타입) bf.setPath(path);
		 * 
		 * // 저장될 파일 이름 // 확장자 int lastIdx = mf.getOriginalFilename().lastIndexOf(".");
		 * String ext = mf.getOriginalFilename().substring(lastIdx); // 마지막 .의 위치값 > 확장자
		 * ex) A.jpg 에서 자른다 //log.debug("\u001B[41m" +
		 * "insertBoard boardFile lastIdx : " + lastIdx + "\u001B[0m");
		 * //log.debug("\u001B[41m" + "insertBoard boardFile ext : " + ext +
		 * "\u001B[0m"); // 새로운 이름 + 확장자
		 * bf.setSaveFilename(UUID.randomUUID().toString().replace("-", "") + ext);
		 * 
		 * // 테이블에 저장 boardfileMapper.insertBoardfile(bf); // 파일저장(저장위치필요 > path변수 필요)
		 * // path 위치에 저장파일이름으로 빈파일을 생성 File f = new File(path+bf.getSaveFilename()); //
		 * 빈파일에 첨부된 파일의 스트림을 주입한다. log.debug("\u001B[41m" + "insertBoard boardFile f : "
		 * + f + "\u001B[0m"); log.debug("\u001B[41m" +
		 * "insertBoard boardFile f.getAbsolutePath() : " + f.getAbsolutePath() +
		 * "\u001B[0m"); try { mf.transferTo(f); } catch(IllegalStateException |
		 * IOException e) { // 트랜잭션 작동을 위해 예외 발생이 필요 e.printStackTrace(); // 트랜잭션 작동을 위해
		 * 예외(try catch 강요하지 않는 예외 ex) RuntimeException) 발생 필요 throw new
		 * RuntimeException(); } } } }
		 */
		return row;
	}
	
	// 게시글 삭제
	public int deleteBoard(Board board, String path) {
		List<BoardFile> boardFile = boardfileMapper.selectBoardFile(board.getBoardNo());
		for(BoardFile bf : boardFile) {
			File f = new File(path+bf.getSaveFilename());
			if(f.exists()) {
				f.delete();
			}
		}
		int row = boardfileMapper.deleteBoardfile(board.getBoardNo());
		row = boardMapper.deleteBoard(board.getBoardNo());
		
		return row;
	}
	
	// 최근 공지사항 리스트 조회
	public List<Board> selectRecentNotice(){
		return boardMapper.selectRecentNotice();
	}
}
