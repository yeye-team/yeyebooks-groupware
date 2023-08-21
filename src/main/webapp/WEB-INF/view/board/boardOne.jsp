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
  data-assets-path="../assets/"
  data-template="vertical-menu-template-free"
>
<head>
	<meta charset="utf-8" />
	<meta
	  name="viewport"
	  content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
	/>
	<title>YEYEBOOKS</title>
	<meta name="description" content="" />
	<!-- Favicon -->
	<link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_mini.png" />
	
	<!-- Fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
	<link
	  href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
	  rel="stylesheet"
	/>
	
	<!-- Icons. Uncomment required icon fonts -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/fonts/boxicons.css" />
	
	<!-- Core CSS -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/css/core.css" class="template-customizer-core-css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/demo.css" />
	
	<!-- Vendors CSS -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
	
	<!-- Page CSS -->
	
	<!-- Helpers -->
	<script src="${pageContext.request.contextPath}/assets/vendor/js/helpers.js"></script>
	
	<!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
	<!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
	<script src="${pageContext.request.contextPath}/assets/js/config.js"></script>
	
	<script>
		// url파라미터값 삭제
		/* history.replaceState({}, null, location.pathname);  */
	</script>
</head>
<body>
	<c:set value="${board}" var="b"></c:set>
	<c:set value="${boardFile}" var="f"></c:set>
	<c:set value="${user}" var="u"></c:set>
	<table border="1">
		<c:if test="${u.codeNm != null}">
			<tr>
				<th>부서</th>
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
	<!-- 공지사항은 댓글이 없음. 제외 -->
	<c:if test="${b.boardCatCd != '00'}">
		<form action="${pageContext.request.contextPath}/board/addComment" method="post">
			<a>댓글</a>
			<input type="hidden" name="boardNo" value="${b.boardNo}">
			<input type="hidden" name="loginId" value="${loginId}">
			<input type="hidden" name="userId" value="${u.userId}">
			<input type="text" name="comment" placeholder="댓글을 입력하세요" required="required">
			<button type="submit">등록</button>
		</form>
		<table>
			<tr>
				<th>작성자</th>
				<th>내용</th>
				<th>작성일자</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
			<c:forEach var="c" items="${commentList}">
				<tr>
					<td>${c.userNm}</td>
					<td>${c.cmntContents}</td>
					<td>${fn:substring(c.cDate,0,11)}</td>
					<c:if test="${c.userId == loginId}">
						<td>
							<a>수정</a>
						</td>
						<td>
							<a>삭제</a>
						</td>
					</c:if>
				</tr>
			</c:forEach>
		</table>
	</c:if>
	<!-- 목록으로 -->
	<div>
		<a href="${pageContext.request.contextPath}/board/boardList?boardCatCd=${b.boardCatCd}">목록으로</a>
	</div>
	<c:choose>
		<c:when test="${loginId == b.userId}">
			<a href="${pageContext.request.contextPath}/board/modifyBoard">수정</a>
			<a href="${pageContext.request.contextPath}/board/removeBoard">삭제</a>
		</c:when>
		<c:when test="${loginId == 'admin'}">
			<a href="${pageContext.request.contextPath}/board/removeBoard">삭제</a>
		</c:when>
	</c:choose>
	
	<!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/popper/popper.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="${pageContext.request.contextPath}/assets/vendor/js/menu.js"></script>
    <!-- endbuild -->

    <!-- Vendors JS -->

    <!-- Main JS -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    <!-- Page JS -->

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
</body>
</html>