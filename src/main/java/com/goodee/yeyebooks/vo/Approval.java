package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class Approval {
	private String aprvNo;
	private String userId;
	private String docCatCd;
	private String aprvTitle;
	private String aprvContents;
	private String aprvYmd;
	private String rjctReason;
	private String aprvStatCd;
	private String reference;
	private String cDate;
	private String uDate;
}
