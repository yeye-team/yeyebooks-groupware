package com.goodee.yeyebooks.vo;

import lombok.Data;

@Data
public class StoreSales {
	private String salesNo;
	private String storeNm;
	private String salesYmd;
	private String productCat;
	private String bookCat;
	private int salesPrice;
	private String cDate;
	private String uDate;
}
