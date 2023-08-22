<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		$(".status-link").click(function(e) {
			e.preventDefault();
			var newStatus = $(this).data("status");
			var newTitle = $(this).data("title");
			var statusValue = $(this).data("status-value");
			
			$("#statusInput").val(newStatus);
			$("#pageTitle").text(newTitle);
			$("#statusHiddenInput").val(statusValue);
			
			$("#filterForm").submit();
		});
	});
</script>
</head>
<body>
	<h1 id="pageTitle">My Documents</h1>
	
	<div>
        <!-- 카테고리 바 -->
		<div>
			<a href="#" class="status-link" data-status="A001" data-title="내 문서함" data-status-value="">내 문서함</a>
			<a href="#" class="status-link" data-status="A001" data-title="진행중인 문서" data-status-value="01">진행중인 문서</a>
			<a href="#" class="status-link" data-status="A001" data-title="승인대기 문서" data-status-value="">승인대기 문서</a>
			<a href="#" class="status-link" data-status="A001" data-title="결재대기 문서" data-status-value="">결재대기 문서</a>
			<a href="#" class="status-link" data-status="A001" data-title="처리 완료된 문서" data-status-value="02">처리 완료된 문서</a>
			<a href="#" class="status-link" data-status="A001" data-title="반려된 문서" data-status-value="03">반려된 문서</a>
			<a href="#" class="status-link" data-status="A001" data-title="회수된 문서" data-status-value="04">회수된 문서</a>
		</div>

        <!-- 검색 폼 -->
        <form id="filterForm" action="/approval/approvalList" method="get">
            <input type="hidden" id="statusInput" name="status" value="">
            <input type="hidden" id="statusHiddenInput" name="statusHidden" value="${statusHidden}">
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
		<c:forEach var="m" items="${approvalList}">
			<tr>
				<td>${m.userId}</td>
				<td>${m.docCatCd}</td>
				<td>${m.aprvTitle}</td>
				<td>${m.approvalContents}</td>
				<td>${m.reference}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>