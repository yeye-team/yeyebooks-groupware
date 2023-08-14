package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class Comment {
	private int cmntNo;
	private int boardNo;
	private String userId;
	private String cmntContents;
	private String cDate;
	private String uDate;
}
