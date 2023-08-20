package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class UserFile {
	private int userFileNo;
	private String userId;
	private String fileCategory;
	private String saveFilename;
	private String filetype;
	private String path;
	private String cDate;
	private String uDate;
}
