package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class Schedule {
	private int skdNo;
	private String userId;
	private String skdCatCd;
	private String skdTitle;
	private String skdYmd;
	private String skdStartTime;
	private String skdEndTime;
	private String skdContents;
	private String cDate;
	private String uDate;
}
