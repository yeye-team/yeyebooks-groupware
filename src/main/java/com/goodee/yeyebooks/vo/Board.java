package com.goodee.yeyebooks.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Board {
	private int boardNo;
	private String userId;
	private String boardCatCd;
	private String boardTitle;
	private String boardContents;
	private int boardView;
	private String cDate;
	private String uDate;
	
	private List<MultipartFile> multipartFile;
}
