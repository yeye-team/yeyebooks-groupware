package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class BookingTarget {
	private int trgtNo;
	private String trgtCatCd;
	private String trgtNm;
	private String trgtInfo;
	private String saveFilename;
	private String filetype;
	private String path;
	private String cDate;
	private String uDate;
}
