<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>
	const pageTitles = ["내 문서함", "진행중인 문서", "승인대기 문서", "결재대기 문서", "처리 완료된 문서", "반려된 문서", "회수된 문서"];
     $(document).ready(function() {
    	 $("#pageTitle").text(pageTitles[${status}]);
        
        // 페이지 로딩 시 초기 데이터 설정
        var initialStatus = window.location.search.split("=")[1] || "0";
        if (initialStatus == undefined){
        	initialStatus = "0";
        }
        $(".status-link[data-status='" + initialStatus + "']").click();
    });
</script>
</head>
<body>
	<h1 id="pageTitle"></h1>
	
	<div>
        <!-- 카테고리 바 -->
		<div>
			<a href="/yeyebooks/approval/approvalList?status=0" class="status-link" data-title="내 문서함">내 문서함</a>
			<a href="/yeyebooks/approval/approvalList?status=1" class="status-link" data-title="진행중인 문서">진행중인 문서</a>
			<a href="/yeyebooks/approval/approvalList?status=2" class="status-link" data-title="승인대기 문서">승인대기 문서</a>
			<a href="/yeyebooks/approval/approvalList?status=3" class="status-link" data-title="결재대기 문서">결재대기 문서</a>
			<a href="/yeyebooks/approval/approvalList?status=4" class="status-link" data-title="처리 완료된 문서">처리 완료된 문서</a>
			<a href="/yeyebooks/approval/approvalList?status=5" class="status-link" data-title="반려된 문서">반려된 문서</a>
			<a href="/yeyebooks/approval/approvalList?status=6" class="status-link" data-title="회수된 문서">회수된 문서</a>
		</div>

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