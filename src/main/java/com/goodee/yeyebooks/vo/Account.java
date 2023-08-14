package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class Account {
	private int acntNo;
	private String aprvNo;
	private String acntSubject;
	private String acntYmd;
	private String acntContents;
	private String acntNm;
	private int acntAmount;
	private String acntCreditCd;
	private String acntProofCd;
}
