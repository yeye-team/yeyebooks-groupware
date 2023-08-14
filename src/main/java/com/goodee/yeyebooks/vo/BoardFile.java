package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class BoardFile {
	private int boardFileNo;
	private int boardNo;
	private String FileCatCd;
	private String originFilename;
	private String saveFilename;
	private String filetype;
	private String path;
	private String cDate;
	private String uDate;
}
