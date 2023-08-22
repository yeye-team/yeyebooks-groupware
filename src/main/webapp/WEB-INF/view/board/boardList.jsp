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

    <!-- 게시판 변경 시 타이틀 변경 -->
	<c:choose>
		<c:when test="${boardCatCd=='00'}">
			<title>공지사항 게시판</title>
		</c:when>
		<c:when test="${boardCatCd=='99'}">
			<title>전체 게시판</title>
		</c:when>
		<c:otherwise>
			<title>부서 게시판</title>
		</c:otherwise>
	</c:choose>
	
    <jsp:include page="../inc/head.jsp"></jsp:include>
    
    <script>
	    /* // url파라미터값 삭제
		history.replaceState({}, null, location.pathname);  */
    </script>
    <style>
    	.menu-link{
    		background-color: white;
	    	border: none;
	    	width: 88%;
    	}
    	.catScroll{
    		overflow-y: scroll;
    		overflow-x: hidden;
    		width: 100%;
    		height: 235px;
    	}
    	h2{
    		text-align: center;
    	}
    	
    	.addBtn{
    		display: flex;
 		   justify-content: flex-end;
    	}
    	
    	.table{
    		text-align: center;
    	}
    </style>
  </head>

  <body>
    <!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
		<div class="layout-container">
			<!-- Menu -->
			<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
				<div class="app-brand demo">
					<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png"
					style="width:100%">
				</div>
		
				<div class="menu-inner-shadow"></div>
				
				<!-- 메뉴바 게시판 클릭 구현부 -->
				<form action="/yeyebooks/board/boardList" method="post">
					<ul class="menu-inner py-1">
				         <!-- Dashboard -->
						<li class="menu-item">
							<button type="submit" name="boardCatCd" value="00" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">공지사항</div>
							</button>
						</li>
						<li class="menu-item">
							<button type="submit" name="boardCatCd" value="99" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">전체 게시판</div>
							</button>
						</li>
						<!-- 관리자 사용자 메뉴 구분 -->
						<c:choose>
							<c:when test="${userId != 'admin'}">
								<li class="menu-item">
									<button type="submit" name="boardCatCd" value="dept" class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">부서 게시판</div>
									</button>
								</li>
							</c:when>
							<c:otherwise>
								<li class="menu-item">
									<a class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">부서 게시판</div>
									</a>
									<div class="card overflow-hidden" style="height: 250px;">
						        		<div class="card-body" id="vertical-example">
											<c:forEach var="s" items="${selectAllCatCode}">
												<button type="submit" name="boardCatCd" value="${s.code}" class="menu-link">
													<i class='bx bx-clipboard'></i>
													<div data-i18n="Analytics">${s.codeNm} 게시판</div>
												</button>
											</c:forEach>
										</div>
									</div>
								</li>
							</c:otherwise>
						</c:choose>
					</ul>
				</form>
			</aside>
			<!-- / Menu -->

	        <!-- Layout container -->
	        <div class="layout-page">
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
		            	<!-- 게시판 변경 시 헤더 변경 -->
						<c:choose>
							<c:when test="${boardCatCd=='00'}">
								<h2 class="fw-bold py-3 mb-4">공지사항 게시판</h2>
							</c:when>
							<c:when test="${boardCatCd=='99'}">
								<h2 class="fw-bold py-3 mb-4">전체 게시판</h2>
							</c:when>
							<c:otherwise>
								<h2 class="fw-bold py-3 mb-4">부서 게시판</h2>
							</c:otherwise>
						</c:choose>
						
						<!-- 게시물 리스트 -->
				        <div class="card">
				          <div class="table-responsive text-nowrap">
				            <table class="table">
				              <thead>
				                <tr>
									<th>제목</th>
									<th>작성자</th>
									<th>작성날짜</th>
									<th>조회수</th>
				                </tr>
				              </thead>
				              <tbody class="table-border-bottom-0">
								<!-- 게시판 변경 시 내용변경 -->
								<c:forEach var="n" items="${selectBoard}">
									<tr style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/board/boardOne?boardNo=${n.boardNo}&userId=${n.userId}'">
										<td>${n.boardTitle}</td>
										<td>
											<input type="hidden" name="userId" value="${n.userId}" readonly="readonly">
											${n.userNm}
										</td>
										<td>${fn:substring(n.cDate,0,11)}</td>
										<td>${n.boardView}</td>
									</tr>
								</c:forEach>
							  </tbody>
							</table>
						  </div>
						</div><br>
	             		<!--/ 게시물 리스트 -->
	             		
	             		<!-- 작성버튼 구분 -->
						<div class="addBtn">
							<c:choose>
								<c:when test="${userId == 'admin' && boardCatCd == '00'}">
									<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard">공지 작성</button>
								</c:when>
								<c:when test="${userId != 'admin' && boardCatCd != '00'}">
									<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard">게시물 작성</button>
								</c:when>
							</c:choose>
						</div>
						
	             		<!-- 페이징 -->
		                <div class="card-body">
							<div class="row">
			                    <div class="col">
									<div class="demo-inline-spacing">
				                        <nav aria-label="Page navigation">
											<ul class="pagination">
					                          	<!-- 페이징 -->
												<c:if test="${currentPage!=1}">
													<li class="page-item first">
														<a class="page-link" href="/yeyebooks/board/boardList?boardCatCd=${boardCatCd}&currentPage=1">
															<i class="tf-icon bx bx-chevrons-left"></i>
														</a>
													</li>
												</c:if>
												<!-- 1페이지가 아닐때 출력 -->
												<c:if test="${minPage>1}">
													<li class="page-item prev">
														<a class="page-link" href="/yeyebooks/board/boardList?boardCatCd=${boardCatCd}&currentPage=${minPage-pagePerPage}">
															<i class="tf-icon bx bx-chevron-left"></i>
														</a>
													</li>
												</c:if>
												<!-- 페이지 5단위 출력 -->
												<c:forEach var="i" begin="${minPage}" end="${maxPage}">
													<c:choose>
														<c:when test="${i==currentPage}">
															<!-- 현재 페이지일때 출력 -->
															<li class="page-item active">
																<a class="page-link">${i}</a>
															</li>
														</c:when>
														<c:otherwise>
															<!-- 현재 페이지 아닐때 출력 -->
															<li class="page-item">
																<a class="page-link" href="/yeyebooks/board/boardList?boardCatCd=${boardCatCd}&currentPage=${i}">${i}</a>
															</li>
														</c:otherwise>
													</c:choose>
												</c:forEach>
												<!-- 마지막 페이지 아닐때 출력 -->
												<c:if test="${maxPage!=lastPage}">
													<li class="page-item next">
														<a class="page-link" href="/yeyebooks/board/boardList?boardCatCd=${boardCatCd}&currentPage=${minPage+pagePerPage}">
															<i class="tf-icon bx bx-chevron-right"></i>
														</a>
													</li>
												</c:if>
												<!-- 마지막 페이지일때 출력 -->
												<c:if test="${currentPage!=lastPage}">
													<li class="page-item last">
														<a class="page-link" href="/yeyebooks/board/boardList?boardCatCd=${boardCatCd}&currentPage=${lastPage}">
															<i class="tf-icon bx bx-chevrons-right"></i>
														</a>
													</li>
												</c:if>
											</ul>
				                        </nav>
									</div>
			                    </div>
							</div>
		                </div>
					</div>
				<!-- / Content -->
				</div>
	     	   <!-- / Layout page -->
			</div>
  		</div>
	<!-- / Layout wrapper -->
	</div>
    <jsp:include page="../inc/coreJs.jsp"></jsp:include>
  </body>
</html>
