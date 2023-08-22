<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%><!-- jstl substring호출 -->
<!DOCTYPE html>
<html
  lang="en"
  class="light-style layout-menu-fixed"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="${pageContext.request.contextPath}/assets/"	
  data-template="vertical-menu-template-free"
>
<head>
	<title>YEYEBOOKS</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
		// url파라미터값 삭제
		/* history.replaceState({}, null, location.pathname);  */
		
			// 댓글 수정
		    $(".modifyCommentBtn").click(function() {
		        // 해당 댓글 행에서 수정 버튼이 클릭된 댓글 찾기
		        var commentRow = $(this).closest("tr");

		        // 기존 댓글과 드롭다운 숨기기
		        commentRow.find(".oriComment").hide();
		        commentRow.find(".dropDown").hide();
		        
		        // 댓글 수정 폼 표시
	        	commentRow.find(".modifyBox").show();
		    });

		    // 댓글 수정 취소 버튼 클릭 시
		    $(".modifyCancel").click(function() {
		        var commentRow = $(this).closest("tr");
		        
		        // 댓글 수정 폼 숨기기
		        commentRow.find(".modifyBox").hide();

		        // 기존 댓글과 드롭다운 메뉴 표시
		        commentRow.find(".oriComment").show();
		        commentRow.find(".dropDown").show();
		    });
		    
		    // 댓글 삭제
	$(".deleteCommentBtn").click(function() {
		// 삭제 alert
		var deleteCk = confirm("댓글을 삭제하시겠습니까?");
		if (deleteCk) {
			var deleteRow = $(this).closest("tr");
			var boardNo = deleteRow.find("[name='boardNo']").val();
			var userId = deleteRow.find("[name='userId']").val();
			var cmntNo = deleteRow.find("[name='cmntNo']").val();
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/board/deleteComment",
				data: {
					boardNo: boardNo,
					userId: userId,
					cmntNo: cmntNo
				},
				success: function(response) {
					window.location.href = "${pageContext.request.contextPath}/board/boardOne?boardNo=" + boardNo + "&userId=" + userId;
				},
				error: function() {
					alert("댓글 삭제 실패");
				}
			});
		}
	});
		});
	</script>
</head>
<body>
	<c:set value="${board}" var="b"></c:set>
	<c:set value="${boardFile}" var="f"></c:set>
	<c:set value="${user}" var="u"></c:set>
	<table border="1">
		<c:if test="${u.codeNm != null}">
			<tr>
				<th>직급</th>
				<td>${u.codeNm}</td>
			</tr>
		</c:if>
		<tr>
			<th>제목</th>
			<td>${b.boardTitle}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<c:choose>
				<c:when test="${u.userNm == null}">
					<td>관리자</td>
				</c:when>
				<c:otherwise>
					<td>${u.userNm}</td>
				</c:otherwise>
			</c:choose>
		</tr>
		<tr>
			<th>작성일자</th>
			<td>${fn:substring(b.CDate,0,11)}</td>
		</tr>
		<!-- 첨부파일이 있을때만 표시 -->
		<c:if test="${f.originFilename != null}">
			<tr>
				<th>첨부파일</th>
				<td>
					<a 
						href="${pageContext.request.contextPath}/${f.path}/${f.saveFilename}" 
						download="${f.saveFilename}">${f.originFilename}
					</a>
				</td>
			</tr>
		</c:if>
		<tr>
			<th>내용</th>
			<td>${b.boardContents}</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${b.boardView}</td>
		</tr>
	</table>
	<c:choose>
		<c:when test="${loginId == b.userId}">
			<a href="${pageContext.request.contextPath}/board/modifyBoard">수정</a>
			<a href="${pageContext.request.contextPath}/board/removeBoard">삭제</a>
		</c:when>
		<c:when test="${loginId == 'admin'}">
			<a href="${pageContext.request.contextPath}/board/removeBoard">삭제</a>
		</c:when>
	</c:choose>
	<br>
	<br>
	<!-- 공지사항은 댓글이 없음. 제외 -->
	<c:if test="${b.boardCatCd != '00'}">
		<table>
			<tr>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
			<c:forEach var="c" items="${commentList}">
				<tr>
					<td>${c.userNm}</td>
					<td>
						<!-- 기존 댓글 -->
						<span class="oriComment">${c.cmntContents}</span>
						
						<!-- 댓글 수정 입력 폼 -->
						<div class="modifyBox" style="display: none;">
							<form action="${pageContext.request.contextPath}/board/modifyComment" method="post">
								<input type="hidden" name="userId" value="${u.userId}" readonly="readonly">
								<input type="hidden" name="boardNo" value="${c.boardNo}" readonly="readonly">
								<input type="hidden" name="cmntNo" value="${c.cmntNo}" readonly="readonly">
								<textarea name="modifyComment" rows="2" cols="50" required="required" placeholder="댓글을 남겨보세요"></textarea>
								<button type="submit">등록</button>
								<button class="modifyCancel">취소</button>
							</form>
						</div>
					</td>
					<td>${fn:substring(c.cDate,0,11)}</td>
					<c:if test="${c.userId == loginId}">
						<td>
							<!-- 댓글 수정삭제 버튼 -->
							<div class="dropDown col-lg-3 col-sm-6 col-12">
								<button type="button" data-bs-toggle="dropdown">
									<i class="bx bx-dots-vertical-rounded"></i>
								</button>
								<ul class="dropdown-menu dropdown-menu-end">
									<li>
										<a class="dropdown-item modifyCommentBtn" href="javascript:void(0);">수정</a>
									</li>
									<li><a class="dropdown-item deleteCommentBtn" href="javascript:void(0);">삭제</a></li>
								</ul>
							</div>
						</td>
					</c:if>
				</tr>
			</c:forEach>
		</table>
		<br>
		<form action="${pageContext.request.contextPath}/board/addComment" method="post">
			<a>${u.userNm}</a><br>
			<input type="hidden" name="boardNo" value="${b.boardNo}">
			<input type="hidden" name="loginId" value="${loginId}">
			<input type="hidden" name="userId" value="${u.userId}">
			<textarea rows="2" cols="50" name="comment" required="required" placeholder="댓글을 남겨보세요"></textarea><br>
			<button type="submit">등록</button>
		</form>
	</c:if>
	<br>
	<!-- 목록으로 -->
	<div>
		<a href="${pageContext.request.contextPath}/board/boardList?boardCatCd=${b.boardCatCd}">목록으로</a>
	</div>
	
	<jsp:include page="../inc/coreJs.jsp"></jsp:include>
</body>
</html>