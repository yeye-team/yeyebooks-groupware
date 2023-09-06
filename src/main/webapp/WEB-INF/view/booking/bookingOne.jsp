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
	<title>YEYEBOOKS</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
    <script>
		
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

				<ul class="menu-inner py-1">
					<li class="menu-item active">
						<button type="button" class="menu-link" onclick="location.href='myBooking'">
							<i class='bx bxs-user-detail'></i>
							<div data-i18n="Analytics">&nbsp;나의 예약목록</div>
						</button>
					</li>
					<li class="menu-item">
						<button type="submit" class="menu-link">
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
	            		<div class="card">
		            		<div class="row">
		            			<div class="col-md-11">
					            	<div class="card-header">
										<h2 class="fw-bold py-0 mb-2">예약세부내역</h2>
			            			</div>
				            	</div>
				            	
				            	<div class="col-md-1" 
				            		 style="display: flex;
       										justify-content: center;
       										align-items: center; ">
       								<c:if test="${sessionScope.userId == user.userId}">
       									<div class="dropdown">
											<button
												class="btn p-0"
												type="button"
												id="cardOpt3"
												data-bs-toggle="dropdown"
												aria-haspopup="true"
												aria-expanded="false"
											>
												<i style="font-size: 28px;" class="bx bx-dots-vertical-rounded"></i>
											</button>
											<div class="dropdown-menu dropdown-menu-end" aria-labelledby="cardOpt3">
												<a class="dropdown-item" href="deleteBooking?bkgNo=${booking.bkgNo }">예약취소</a>
											</div>
										</div>
       								</c:if>
				            	</div>
		            		</div>
		            		
		            		<!-- 구분선 -->
							<hr class="m-0">

							<div class="card-body">
								<h4><b>예약정보</b></h4>
								<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약번호</b></div>
		                        	<div class="col-md-10">${booking.bkgNo}</div>
		                     	</div>
		                    	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약시작일시</b></div>
		                        	<div class="col-md-10">${booking.bkgStartYmd}, ${booking.bkgStartTime}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약종료일시</b></div>
		                        	<div class="col-md-10">${booking.bkgEndYmd}, ${booking.bkgEndTime}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약상태</b></div>
		                        	<div class="col-md-10">${booking.bkgStatus}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약목적</b></div>
		                        	<div class="col-md-10">${booking.bkgPurpose}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약자</b></div>
		                        	<div class="col-md-10">${user.dept} ${user.rank} ${user.userNm}</div>
		                     	</div>
		                     </div>
		                     	
	                     	 <!-- 구분선 -->
							 <hr class="m-0">
							 
							 <div class="card-body">
								<h4><b>예약대상정보</b></h4>
		                    	
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약대상분류</b></div>
		                        	<div class="col-md-10">${booking.trgtCatNm}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약대상명</b></div>
		                        	<div class="col-md-10">${booking.trgtNm}</div>
		                     	</div>
		                     	<div class="mb-3 row">
		                        	<div class="col-md-2"><b>예약대상정보</b></div>
		                        	<div class="col-md-10">${booking.trgtInfo}</div>
		                     	</div>
		                      	<div>
		                      		<div class="col-md-2"><b>예약대상이미지</b></div>
		                        	<div class="col-md-10">
		                        		<img src="/yeyebooks${booking.path}${booking.saveFilename}">
		                        	</div>
		                      	</div>
	                    	</div>
	                  	</div>
             		</div>
             		<!-- card End -->
				</div>
				<!-- / Content -->
			</div>
			<!-- / Content Wrapper -->
		</div>
	</div>
   	<!-- card End -->

    <jsp:include page="../inc/coreJs.jsp"></jsp:include>
  </body>
</html>