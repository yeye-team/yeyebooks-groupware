package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class ApprovalLine {
	private String aprvNo;
	private String userId;
	private String aprvStatCd;
	private int aprvSequence;
	private String aprvYmd;
}
