package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class User {
	private String userId;
	private String userPw;
	private String userNm;
	private String rank;
	private String dept;
	private String userStatus;
	private String gender;
	private String phoneNo;
	private String mail;
	private String joinYmd;
	private String leaveYmd;
	private int dayoffCnt;
	private String cDate;
	private String uDate;
}
