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
  	<title>내문서함</title>
    <jsp:include page="../inc/head.jsp"></jsp:include>
    <style>
	   tbody tr:hover {
	        background-color: lightgray; /* 마우스를 올렸을 때 배경색 변경 */
	    }
	</style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script>
		const pageTitles = ["내 문서함", "진행중인 문서", "승인대기 문서", "결재대기 문서", "처리 완료된 문서", "반려된 문서", "회수된 문서"];
		history.replaceState({}, null, location.pathname);
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
					<ul class="menu-inner py-1">
					
		            <!-- Dashboard -->
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=0" data-title="내 문서함" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">내 문서함</div>
		              </a>
		            </li>
		
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=1" data-title="진행중인 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">진행중인 문서</div>
		              </a>
		            </li>
		
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=2" data-title="승인대기 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">승인대기 문서</div>
		              </a>
		            </li>
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=3" data-title="결재대기 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">결재대기 문서</div>
		              </a>
		            </li>
		
		
		            </li>
					<li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=4" data-title="처리 완료된 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">처리 완료된 문서</div>
		              </a>
		            </li>
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=5" data-title="반려된 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">반려된 문서</div>
		              </a>
		            </li>
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/approvalList?status=6" data-title="회수된 문서" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">회수된 문서</div>
		              </a>
		            </li>
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
					                        <%-- <nav aria-label="Page navigation">
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
					                        </nav> --%>
										</div>
				                    </div>
								</div>

				             		<!-- 작성버튼 구분 -->
									<div class="addBtn">
										<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/approval/addApproval'">문서 작성</button>
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
 