package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class ApprovalFile {
	private int aprvFileNo;
	private String aprvNo;
	private String orginFilename;
	private String saveFilename;
	private String filetype;
	private String path;
}
