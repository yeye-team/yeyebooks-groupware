<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%><!-- jstl substring호출 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>YEYEBOOKS</title>
</head>
<body>
	<c:set value="${board}" var="b"></c:set>
	<c:set value="${boardFile}" var="f"></c:set>
	<c:set value="${user}" var="u"></c:set>
	<table>
		<tr>
			<th>부서</th>
			<td>${u.codeNm}</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${b.boardTitle}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${u.userNm}</td>
		</tr>
		<tr>
			<th>작성일자</th>
			<td>${fn:substring(b.CDate,0,11)}</td>
		</tr>
		<!-- 첨부파일이 있을때만 표시 -->
		<c:if test="${f.originFilename != null}">
			<tr>
				<th>첨부파일</th>
				<td>${f.originFilename}</td>
			</tr>
		</c:if>
		<tr>
			<th>내용</th>
			<td>${b.boardContents}</td>
		</tr>
	</table>
	<table>
		<tr>
			<th>댓글</th>
			<td>
				<div>
					<input type="text" name="comment" placeholder="댓글을 입력하세요">
				</div>
			</td>
		</tr>
	</table>
</body>
</html>