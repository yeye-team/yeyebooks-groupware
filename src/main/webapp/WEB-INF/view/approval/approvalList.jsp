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

            // AJAX 요청 보내기
            $.ajax({
                url: "/approval/approvalList", // 서버 URL 설정
                method: "GET",
                data: { status: newStatus }, // 전달할 데이터 설정
                success: function(data) {
                    // 성공 시 데이터를 처리하는 코드
                    // 예를 들어, 받아온 데이터를 테이블에 업데이트
                    $("#approvalTable").html(data);
                },
                error: function(error) {
                    console.error("AJAX request error:", error);
                }
            });
        });
    });
</script>
</head>
<body>
	<h1 id="pageTitle">내 문서함</h1>
	
	<div>
        <!-- 카테고리 바 -->
		<div>
			<a href="#" class="status-link" data-title="내 문서함">내 문서함</a>
			<a href="#" class="status-link" data-title="진행중인 문서">진행중인 문서</a>
			<a href="#" class="status-link" data-title="승인대기 문서">승인대기 문서</a>
			<a href="#" class="status-link" data-title="결재대기 문서">결재대기 문서</a>
			<a href="#" class="status-link" data-title="처리 완료된 문서">처리 완료된 문서</a>
			<a href="#" class="status-link" data-title="반려된 문서">반려된 문서</a>
			<a href="#" class="status-link" data-title="회수된 문서">회수된 문서</a>
		</div>

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
		<c:forEach var="m" items="${approvalList}">
			<tr>
				<td>${m.aprvNo}</td>
				<td>${m.userId}</td>
				<td>${m.docCatCd}</td>
				<td>${m.aprvTitle}</td>
				<td>${m.aprvContents}</td>
				<td>${m.reference}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>