<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%><!-- jstl substring호출 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 게시판</title>
</head>
<body>
	<h1>공지사항</h1>
	<table>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성날짜</th>
			<th>조회수</th>
		</tr>
		<c:forEach var="n" items="${selectNotice}">
			<tr style="cursor:pointer;" onclick="location.href=''">
				<td>${n.boardNo}</td>
				<td>${n.boardTitle}</td>
				<td>${n.userId}</td>
				<td>${fn:substring(n.CDate,0,11)}</td>
				<td>${n.boardView}</td>
			</tr>
		</c:forEach>
	</table>
	
	<!-- 페이징 -->
	<c:if test="${currentPage!=1}">
		<a href="/yeyebooks/board/noticeBoard?currentPage=1">첫 페이지</a>
	</c:if>
	<!-- 1페이지가 아닐때 출력 -->
	<c:if test="${minPage>1}">
		<a href="/yeyebooks/board/noticeBoard?currentPage=${minPage-pagePerPage}">이전</a>
	</c:if>
	<!-- 페이지 5단위 출력 -->
	<c:forEach var="i" begin="${minPage}" end="${maxPage}">
    <c:choose>
        <c:when test="${i==currentPage}">
	    	<!-- 현재 페이지일때 출력 -->
            <span>${i}</span>
        </c:when>
        <c:otherwise>
	        <!-- 현재 페이지 아닐때 출력 -->
            <a href="/yeyebooks/board/noticeBoard?currentPage=${i}">${i}</a>
        </c:otherwise>
    </c:choose>
	</c:forEach>
	<!-- 마지막 페이지 아닐때 출력 -->
	<c:if test="${maxPage!=lastPage}">
		<a href="/yeyebooks/board/noticeBoard?currentPage=${minPage+pagePerPage}">다음</a>
	</c:if>
	<!-- 마지막 페이지일때 출력 -->
	<c:if test="${currentPage!=lastPage}">
		<a href="/yeyebooks/board/noticeBoard?currentPage=${lastPage}">마지막 페이지</a>
	</c:if>
</body>
</html>