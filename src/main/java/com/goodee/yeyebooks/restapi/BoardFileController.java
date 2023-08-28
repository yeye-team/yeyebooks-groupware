package com.goodee.yeyebooks.restapi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.yeyebooks.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/board")
public class BoardFileController {

    @Autowired
    private BoardService boardService;
    
    // 게시물 수정시 기존 첨부파일 중 삭제한 파일만 따로 삭제
    @PostMapping("/deleteFilesAndModify")
    public ResponseEntity<String> deleteFilesAndModify(@RequestBody Map<String, Object> requestData,HttpServletRequest request) {
    	//log.debug("\u001B[41m" + "Controller deleteBoardFile requestData : " + requestData + "\u001B[0m");
    	int boardNo = Integer.parseInt((String) requestData.get("boardNo"));
    	//log.debug("\u001B[41m" + "Controller deleteBoardFile boardNo : " + boardNo + "\u001B[0m");
	    List<Integer> filesToDelete = (List<Integer>) requestData.get("filesToDelete");
	    //log.debug("\u001B[41m" + "Controller deleteBoardFile filesToDelete : " + filesToDelete + "\u001B[0m");
	    String path = request.getServletContext().getRealPath("/boardFile/");
	    
        boolean success = boardService.deleteFiles(boardNo, filesToDelete, path);
        //log.debug("\u001B[41m" + "Controller deleteBoardFile success : " + success + "\u001B[0m");

        if (success) {
            return ResponseEntity.ok().body("삭제완료");
        } else {
            return ResponseEntity.badRequest().body("삭제실패");
        }
    }
}
