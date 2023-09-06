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
	<title>휴가 신청 내역</title>
	
    <jsp:include page="inc/head.jsp"></jsp:include>
    
    <script>
    $(document).ready(function() {
    	// 검색
    	$("#searchDate").change(function() {
            var selectedDate = $("#searchDate").val();
            
	    	$.ajax({
				type: 'GET',
				url: '${pageContext.request.contextPath}/vacationList',
				data: {
					searchDate: selectedDate
				},
				success: function(response){
					const vacationListChildren = $(response).find('#vacationList').children();
					const pageListChildren = $(response).find('#pageList').children();
					$('#vacationList').html(vacationListChildren);
					$('#pageList').html(pageListChildren);
					
					if (vacationListChildren.length === 0) {
						Swal.fire({
		                    title: '경고',
		                    text: "내역이 존재하지 않습니다.",
		                    icon: 'warning'
			        	});	                    
	                }
				}
			})
    	});
    });
    
    // 페이지 변동 시 검색값 유지
	function changePage(pageNumber) {
	    // 검색어 가져오기
	    var searchDate = document.getElementById("searchDate").value;
	    
	    $.ajax({
	        type: 'GET',
	        url: '${pageContext.request.contextPath}/vacationList',
	        data: {
	            currentPage: pageNumber,
	            searchDate: searchDate
	        },
	        success: function (response) {
	            const vacationListChildren = $(response).find('#vacationList').children();
	            const pageListChildren = $(response).find('#pageList').children();
	            $('#vacationList').html(vacationListChildren);
	            $('#pageList').html(pageListChildren);
	        }
	    });
	}
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
    	
    	.table{
    		text-align: center;
    		table-layout: fixed;
       		width: 100%; /* 테이블의 전체 너비 */
    	}
    	
    	.table th,
   		.table td:nth-child(1) {
	        width: 25%;
    	}
    	tbody tr:hover {
    		background-color: lightgray;
    	}
    	
    	.container {
    		margin-bottom: 7px;
    		
    	}
    	@media (max-width: 767px) {
		    .col-md-2 {
		        display: block; /* 블록 레이아웃으로 변경 */
		        width: 100%; /* 너비를 100%로 설정 */
		    }
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
						<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png" style="width:100%">
					</a>
				</div>
	
				<div class="menu-inner-shadow"></div>
				
				<ul class="menu-inner py-1">
					<li class="menu-item active" onclick="location.href='${pageContext.request.contextPath}/vacationList'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청 내역
						</button>
					</li>
					<li class="menu-item" onclick="location.href='${pageContext.request.contextPath}/addVacation'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청
						</button>
					</li>
				</ul>
	        </aside>
	        <!-- / Menu -->

	        <!-- Layout container -->
	        <div class="layout-page">
	        	<jsp:include page="inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
						<h2 class="fw-bold py-3 mb-4">휴가 신청 내역</h2>
						
						<!-- 검색 창 -->
						<div class="container">
							<div class="row">
								<div class="col-md-10">
								&nbsp;
								</div>
								<div class="col-md-2">
									<input type="date" id="searchDate" class="form-control">
								</div>	
							</div>
						</div> 
						
						<!-- 휴가내역 리스트 -->
				        <div class="card" style="height: 600px;">
				          <div class="table-responsive text-nowrap" style="height: 500px;">
				            <table class="table">
				              <thead>
				                <tr>
									<th>제목</th>
									<th>휴가 날짜</th>
									<th>구분</th>
									<th>상신일</th>
									<th>상태</th>
				                </tr>
				              </thead>
				              <tbody class="table-border-bottom-0" id="vacationList">
								<c:forEach var="v" items="${selectVacationList}">
									<tr style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/vacationOne?aprv_no=${v.aprvNo}'">
										<td>${v.aprvTitle}</td>
										<td>${v.dayoffYmd}</td>
										<td>${v.dayoffTypeNm}</td>
										<td>${v.aprvYmd}</td>
										<td>${v.aprvStatNm}</td>
									</tr>
								</c:forEach>
							  </tbody>
							</table>
							<!-- 구분선 -->
							<hr class="m-0">
						  </div>
						
		             		<!-- 페이징 -->
			                <div class="card-body"
			                	 id="pageList" 
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
															<a class="page-link" href="javascript:void(0);" onclick="changePage(1)">
																<i class="tf-icon bx bx-chevrons-left"></i>
															</a>
														</li>
													</c:if>
													<!-- 1페이지가 아닐때 출력 -->
													<c:if test="${minPage>1}">
														<li class="page-item prev">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${minPage - pagePerPage})">
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
																	<a class="page-link" href="javascript:void(0);" onclick="changePage(${i})">${i}</a>
																</li>
															</c:otherwise>
														</c:choose>
													</c:forEach>
													<!-- 마지막 페이지 아닐때 출력 -->
													<c:if test="${maxPage!=lastPage}">
														<li class="page-item next">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${minPage+pagePerPage})">
																<i class="tf-icon bx bx-chevron-right"></i>
															</a>
														</li>
													</c:if>
													<!-- 마지막 페이지일때 출력 -->
													<c:if test="${currentPage!=lastPage}">
														<li class="page-item last">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${lastPage})">
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
			                <!-- / 페이징 -->
						</div>
	             		<!--/ 휴가내역 리스트 -->
					</div>
				<!-- / Content -->
				</div>
	     	   <!-- / Layout page -->
			</div>
  		</div>
	<!-- / Layout wrapper -->
	</div>
    <jsp:include page="inc/coreJs.jsp"></jsp:include>
  </body>
</html>
