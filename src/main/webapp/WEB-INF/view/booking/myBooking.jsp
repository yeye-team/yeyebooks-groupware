<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>나의예약목록</title>
    <jsp:include page="../inc/head.jsp"></jsp:include>
    
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
    	tbody tr:hover {
    		background-color: lightgray;
    		cursor: pointer;
    	}
    	.form-check-input{
    		cursor: pointer;
    	}
    	#searchBtn{
    		margin-right: 2rem;
		    margin-left: 0.5rem;
		}
    </style>
    <script>
    	let labelTexts = [];
    	let searchCat = '';
    	let searchNm = '';
    	let currentPage;
    	
    	function statCheckChange(){
    		$('input[type="checkbox"]:checked').each(function() {
    	     	const labelText = $("label[for='" + $(this).attr('name') + "']").text();
    	      	labelTexts.push(labelText);
    	    });
			if(labelTexts.length == 0){
				$('#bookingList').html('');
				return;
			}
			updateBookingList();
    	}
    	
    	function searchNmChange(){
    		searchNm = $('input[name="searchNm"]').val();
    	}
    	
    	function searchCatChange(){
    		searchCat = $('#searchCat').val();
    	}
    	function movePage(pageNum){
    		currentPage = pageNum;
    		updateBookingList();
    	}
    	function updateBookingList(){
    		$.ajax({
     		   type: 'get',
     		   url: '/yeyebooks/booking/myBooking',
     		   data: {
     			   status: labelTexts,
     			   searchCat: searchCat,
     			   searchNm: searchNm,
     			   currentPage: currentPage
     		   },
     		   success: function(response){
     			   Swal.fire({
     				   icon: 'success',
     				   title: '성공'
     			   })
     			   const paginationChildren = $(response).find('#bookingPagination').children();
     			   $('#bookingPagination').html(paginationChildren);
     			  const searchChildren = $(response).find('#searchForm').children();
    			   $('#searchForm').html(searchChildren);
    			   const bookingListChildren = $(response).find('#bookingList').children();
     			   $('#bookingList').html(bookingListChildren);
     		   }
     	   })
    	}
    </script>
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
				<ul class="menu-inner py-1">
					<li class="menu-item active">
						<button type="button" class="menu-link" onclick="location.href='myBooking'">
							<i class='bx bxs-user-detail'></i>
							<div data-i18n="Analytics">&nbsp;나의 예약목록</div>
						</button>
					</li>
					<li class="menu-item">
						<button type="submit" class="menu-link" onclick="location.href='currBooking'">
							<i class='bx bxs-timer' ></i>
							<div data-i18n="Analytics">&nbsp;예약현황</div>
						</button>
					</li>
					<li class="menu-item">
						<button type="submit" class="menu-link">
							<i class='bx bx-list-plus' ></i>
							<div data-i18n="Analytics">&nbsp;예약하기</div>
						</button>
					</li>
				</ul>
			</aside>
			<!-- / Menu -->

	        <!-- Layout container -->
	        <div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
		            	<h2 class="fw-bold py-3 mb-4">나의 예약목록</h2>
						<form class="d-flex align-items-center justify-content-end mb-2" id="searchForm">
							<div class="px-1">
								<select id="searchCat" class="form-select" onchange="searchCatChange()">
									<option value="">분류선택</option>
									<c:forEach var="cat" items="${bookingCategory}">
										<c:set var="isSelect" value=""></c:set>
										<c:if test="${searchCat == cat }">	
											<c:set var="isSelect" value="selected"></c:set>
										</c:if>
										<option ${isSelect}>${cat }</option>
									</c:forEach>
								</select>
							</div>
							<div class="px-1">
								<input type="text" name="searchNm" class="form-control" placeholder="예약대상" value="${searchNm }" onchange="searchNmChange()">
							</div>
							<div>
								<button type="button" class="btn btn-primary" id="searchBtn" onclick="updateBookingList()">검색</button>
							</div>
							<div class="form-check px-3">
								<input type="checkbox" name="isBooking" class="form-check-input" ${isBooking} onchange="statCheckChange()">
								<label for="isBooking">예약완료</label>
							</div>
							<div class="form-check px-3">
								<input type="checkbox" name="isUsing" class="form-check-input" ${isUsing} onchange="statCheckChange()">
								<label for="isUsing">이용중</label>
							</div>
							<div class="form-check px-3">
								<input type="checkbox" name="isUsed" class="form-check-input" ${isUsed} onchange="statCheckChange()">
								<label for="isUsed">이용완료</label>
							</div>
							<div class="form-check px-3">
								<input type="checkbox" name="isCanceled" class="form-check-input" ${isCanceled} onchange="statCheckChange()">
								<label for="isCanceled">예약취소</label>
							</div>
							
						</form>
				        <div class="card" style="height: 600px;">
				          <div class="table-responsive text-nowrap" style="height: 500px;">
				            <table class="table">
				              <thead>
				                <tr>
				                	<th>예약대상분류</th>
									<th>예약대상명</th>
									<th>예약일시</th>
									<th>예약상태</th>
				                </tr>
				              </thead>
				              <tbody class="table-border-bottom-0" id="bookingList">
								<c:forEach var="b" items="${myBookingList}">
									<tr onclick="location.href='${pageContext.request.contextPath}/booking/bookingOne?bkgNo=${b.bkgNo}'">
										<td>${b.trgtCatNm }</td>
										<td>${b.trgtNm}</td>
										<td>${b.bkgStartYmd}, ${b.bkgStartTime}&nbsp;~&nbsp;${b.bkgEndYmd}, ${b.bkgEndTime}</td>
										<td>${b.bkgStatus}</td>
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
												<ul class="pagination" id="bookingPagination">
						                          	<!-- 페이징 -->
													<c:if test="${currentPage!=1}">
														<li class="page-item first">
															<button type="button" class="page-link" onclick="movePage(1)">
																<i class="tf-icon bx bx-chevrons-left"></i>
															</button>
														</li>
													</c:if>
													<!-- 1페이지가 아닐때 출력 -->
													<c:if test="${minPage != 1}">
														<li class="page-item prev">
															<button type="button" class="page-link" onclick="movePage(${minPage-pagePerPage})">
																<i class="tf-icon bx bx-chevron-left"></i>
															</button>
														</li>
													</c:if>
													<!-- 페이지 5단위 출력 -->
													<c:forEach var="i" begin="${minPage}" end="${maxPage}">
														<c:choose>
															<c:when test="${i == currentPage}">
																<!-- 현재 페이지일때 출력 -->
																<li class="page-item active">
																	<button type="button" class="page-link">${i}</button>
																</li>
															</c:when>
															<c:otherwise>
																<!-- 현재 페이지 아닐때 출력 -->
																<li class="page-item">
																	<button type="button" class="page-link" onclick="movePage(${i})">${i}</button>
																</li>
															</c:otherwise>
														</c:choose>
													</c:forEach>
													<!-- 마지막 페이지 아닐때 출력 -->
													<c:if test="${maxPage!=lastPage}">
														<li class="page-item next">
															<button type="button" class="page-link" onclick="movePage(${maxPage+1})">
																<i class="tf-icon bx bx-chevron-right"></i>
															</button>
														</li>
													</c:if>
													<!-- 마지막 페이지일때 출력 -->
													<c:if test="${currentPage!=lastPage}">
														<li class="page-item last">
															<button type="button" class="page-link" onclick="movePage(${lastPage})">
																<i class="tf-icon bx bx-chevrons-right"></i>
															</button>
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
