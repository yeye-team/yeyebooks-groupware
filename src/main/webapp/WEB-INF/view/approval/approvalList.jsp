<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
</head>
<body>
	<h1 id="pageTitle">My Documents</h1>
	
	<div>
        <!-- 카테고리 바 -->
        <div>
            <a href="#" onclick="changeStatus('A001','내 문서함')">내 문서함</a>
            <a href="#" onclick="changeStatus('01','진행중인 문서')">진행중인 문서</a>
            <a href="#" onclick="changeStatus('A001','승인대기 문서')">승인대기 문서</a>
            <a href="#" onclick="changeStatus('A001','결재완료')">결재대기 문서</a>
            <a href="#" onclick="changeStatus('A001','처리 완료된 문서')">처리 완료된 문서</a>
            <a href="#" onclick="changeStatus('A001','반려')">반려된 문서</a>
            <a href="#" onclick="changeStatus('A001','회수')">회수된 문서</a>
        </div>

        <!-- JavaScript 함수 -->
        <script>
            function changeStatus(newStatus, newTitle) {
            	
                document.getElementById("statusInput").value = newStatus;
                document.getElementById("pageTitle").textContent = newTitle;
                document.getElementById("filterForm").submit();
            }
            
        </script>

        <!-- 검색 폼 -->
        <form id="filterForm" action="/approval/approvalList" method="get">
            <input type="hidden" id="statusInput" name="status" value="">
        </form>
    </div>
	
	<table border="1">
		<tr>
			<th>Approval Number</th>
			<th>User ID</th>
			<th>Document Category</th>
			<th>Approval Title</th>
			<th>Approval Contents</th>
			<th>Reference</th>
		</tr>
		<c:forEach var="m" items="${documents}">
			<tr>
				<td>${m.aprv_no}</td>
				<td>${m.user_id}</td>
				<td>${m.doc_cat_cd}</td>
				<td>${m.aprv_title}</td>
				<td>${m.approval_contents}</td>
				<td>${m.reference}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>