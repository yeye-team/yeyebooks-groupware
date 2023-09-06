package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class Booking {
	private int bkgNo;
	private String userId;
	private int trgtNo;
	private String trgtNm;
	private String trgtInfo;
	private String saveFilename;
	private String path;
	private String trgtCatNm;
	private String bkgStartYmd;
	private String bkgEndYmd;
	private String bkgStartTime;
	private String bkgEndTime;
	private String bkgStatCd;
	private String bkgStatus;
	private String bkgPurpose;
	private String cDate;
	private String uDate;
}
