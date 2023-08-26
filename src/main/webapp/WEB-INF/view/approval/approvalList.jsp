<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <jsp:include page="../inc/head.jsp"></jsp:include>
    <style>
	    tr:hover {
	        background-color: lightgray; /* 마우스를 올렸을 때 배경색 변경 */
	    }
	</style>
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
    		table-layout: fixed;
       		width: 100%; /* 테이블의 전체 너비 */
    	}
    	
    	.table th,
   		.table td:nth-child(1) {
	        width: 25%;
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
					<a href="${pageContext.request.contextPath}">
						<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png"
						     style="width:100%">
					</a>
				</div>
		
				<div class="menu-inner-shadow"></div>
				
				<!-- 메뉴바 게시판 클릭 구현부 -->
				<form action="/yeyebooks/approval/approvalList" method="get">
					<ul class="menu-inner py-1">
						<!-- 각 게시판을 클릭한 각각의 경우별로 active 부여 -->
						<!-- Dashboard -->
						<c:choose>
							<c:when test="${boardCatCd=='00'}">
								<li class="menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="status" value="1" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">공지사항</div>
							</button>
						</li>
						<c:choose>
							<c:when test="${boardCatCd=='99'}">
								<li class="menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="boardCatCd" value="99" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">전체 게시판</div>
							</button>
						</li>
						<!-- 사용자 관리자 메뉴 구분 -->
						<c:choose>
							<c:when test="${userId != 'admin'}">
								<c:choose>
									<c:when test="${boardCatCd != '00' && boardCatCd != '99'}">
										<li class="menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-item">
									</c:otherwise>
								</c:choose>
									<button type="submit" name="boardCatCd" value="${ud.deptCd}" class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">${ud.deptNm} 게시판</div>
									</button>
								</l i>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${boardCatCd != '00' && boardCatCd != '99'}">
										<li class="menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-item">
									</c:otherwise>
								</c:choose>
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
						<!-- /각 게시판을 클릭한 각각의 경우별로 active 부여 -->
					</ul>
				</form>
				<!-- /메뉴바 게시판 클릭 구현부 -->
			</aside>
			<!-- / Menu -->

	        <!-- Layout container -->
	        <div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
		            	<!-- 게시판 변경 시 헤더 변경 -->
						<h1 id="pageTitle" class="text-center"></h1>
						
						<!-- 게시물 리스트 -->
				        <div class="card" style="height: 600px;">
				          <div class="table-responsive text-nowrap" style="height: 500px;">
				            <table class="table">
				              <thead>
				                <tr>
									<th>문서번호</th>
									<th>기안자</th>
									<th>제목</th>
									<th>참조</th>
									<th>결재선</th>
									<th>문서종류</th>
									<th>진행상태</th>
								</tr>
				              </thead>
				              <tbody class="table-border-bottom-0">
								<!-- 게시판 변경 시 내용변경 -->
								<c:forEach var="m" items="${approvalList}">
									<tr onclick="window.location.href='<c:url value='/approval/approvalOne'><c:param name='aprvNo' value='${m.aprvNo}'/></c:url>';" style="cursor: pointer;">
										<td>${m.aprvNo}</td>
										<td>${m.userName}</td>
										<td>${m.aprvTitle}</td>
										<td>${m.reference}</td>
										<td>${m.ulUserName}</td>
										<td>${m.codeName}</td>
										<td>${m.statName}</td>
									</tr>
								</c:forEach>
							  </tbody>
							</table>
							<!-- 구분선 -->
							<hr class="m-0">
						  </div>
						
		             		<!-- 페이징 -->
			                <div class="card-body" 
			                	style="height: 30px;
			                		   display: flex;
        							   justify-content: space-between;">
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
				             		<!-- 작성버튼 구분 -->
									<div class="addBtn">
										<c:choose>
											<c:when test="${userId == 'admin' && boardCatCd == '00'}">
												<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=00'">공지 작성</button>
											</c:when>
											<c:when test="${userId != 'admin' && boardCatCd == '99'}">
												<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=99'">게시물 작성</button>
											</c:when>
											<c:when test="${userId != 'admin' && boardCatCd != '00' && boardCatCd != '99'}">
												<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=${ud.deptCd}'">게시물 작성</button>
											</c:when>
										</c:choose>
									</div>
									<!-- / 작성버튼 -->
			                </div>
			                <!-- / 페이징 -->
			                
						</div>
	             		<!--/ 게시물 리스트 -->
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
 