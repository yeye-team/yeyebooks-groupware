<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approvalOne</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
</head>
<body>
	<h1>hello</h1>
	
	<table border="1">
		<tr>
			<th>문서번호</th>
			<th>문서종류</th>
			<th>제목</th>
			<th>상세내용</th>
			<th>기안부서</th>
			<th>기안자</th>
			<th>첨부파일</th>
			<th>기안날짜</th>
		</tr>
		<c:forEach var="o" items="${selectApprovalOne}">
			<tr>
				<td>${o.aprvNo}</td>
				<td>${o.codeName}</td>
				<td>${o.aprvTitle}</td>
				<td>${o.aprvContents}</td>
				<td>${o.aprvNo}</td>
				<td>${o.userName}</td>
				<td>${o.aprvNo}</td>
				<td>${o.CDate}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>