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
	<title>예약현황</title>
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
    	.fc-license-message{
    		display:none;
    	}
    	.card, .card-body{
    		height: 120%;
    	}
    	.fc-scrollgrid-section-header .fc-datagrid-cell-main{
    		display: none;
    	}
    </style>
	<link href='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.css' rel='stylesheet' />
    <script src='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.js'></script>
    <script src="${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/locales/ko.js"></script>
    <script>
    $(document).ready(function() {
    	  var calendarDiv = document.getElementById('calendar');

    	  var calendar = new FullCalendar.Calendar(calendarDiv, {
    		height: '100%',
    		selectable: false,
    	    initialView: 'resourceTimelineDay',
    	    headerToolbar: {
    	      left: 'prev,next today',
    	      center: 'title',
    	      right: 'resourceTimelineWeek,timeGridDay'
    	    },
    	    resourceGroupField: 'building',
    	    resources: '${pageContext.request.contextPath}/booking/bookingTargets',
    	    events: '${pageContext.request.contextPath}/booking/bookingList',
    	    locale: 'ko'
    	  });

    	  calendar.render();
    	});
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
					<li class="menu-item">
						<button type="button" class="menu-link" onclick="location.href='myBooking'">
							<i class='bx bxs-user-detail'></i>
							<div data-i18n="Analytics">&nbsp;나의 예약목록</div>
						</button>
					</li>
					<li class="menu-item active">
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
										<h2 class="fw-bold py-0 mb-2">예약현황</h2>
			            			</div>
				            	</div>
		            		</div>
		            		
		            		<!-- 구분선 -->
							<hr class="m-0">

							<div class="card-body">
								<div id='calendar'></div>
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