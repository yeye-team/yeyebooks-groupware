<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>Home</title>

    <jsp:include page="./inc/head.jsp"></jsp:include>
	<link href='${pageContext.request.contextPath}/fullcalendar-5.11.5/lib/main.css' rel='stylesheet' />
    <script src='${pageContext.request.contextPath}/fullcalendar-5.11.5/lib/main.js'></script>
  	<style>
  		.card-header, .card-header a{
  			color: #666;
			font-weight: bold;
			transition: all 0.2s linear;
  		}
		.card-header a:hover{
			color: black;
		}
  		.card-body .btn+.btn{
  			margin-left: 0.5rem;
  		}
  		#calendar .fc-scroller {
		  overflow-x: hidden !important;
		  overflow-y: hidden !important;
		}
		/* 일요일 날짜 빨간색 */
		.fc-day-sun a {
		  color: red;
		  text-decoration: none;
		}
		
		/* 토요일 날짜 파란색 */
		.fc-day-sat a {
		  color: blue;
		  text-decoration: none;
		}
  	</style>
  	<script>
  	document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        let calendar = new FullCalendar.Calendar(calendarEl, {
       	  googleCalendarApiKey: 'AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw',
       	  events: {
       	    googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
       	  	color: 'red',
       	  	textColor: 'white'
       	  }
        });
        calendar.render();
      });
  		/* $(document).ready(function(){
  			const calendarEl = $('#calendar');
  	  		const calendar = new FullCalendar.Calendar(calendarEl, {
  	  			googleCalendarApiKey: "AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw",
  	  			events: [
  	  				{
  		  				googleCalendarId: '814508606902-gcmu2h1eb1cqscmgplvq97d9vnj9b2o8.apps.googleusercontent.com',
  		  				color: 'white',
  		  				textColor: 'red'
  	  				}
  	  			]
  	  		})
  	  		calendar.render();
  		}) */
  	</script>
  	
  </head>

  <body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar layout-without-menu">
      <div class="layout-container">

        <!-- Layout container -->
        <div class="layout-page">
          <!-- Navbar -->
          <jsp:include page="./inc/navbar.jsp"></jsp:include>
          <!-- / Navbar -->

          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->

            <div class="container-xxl flex-grow-1 container-p-y">
				<div class="row">
					<div class="col-lg">
	                  <div class="card mb-4">
	                    <h5 class="card-header">
	                    	<a href="#">
	                    		대기중인 결재건
	                    		<span class="badge bg-warning rounded-pill">${approvalCnt + approveCnt }</span>
	                    	</a>
	                    </h5>
	                    <div class="card-body">
                           <a href="#" class="btn btn-primary">
                             승인대기 결재건
                             <span class="badge badge-center rounded-pill bg-label-warning">${approveCnt }</span>
                           </a>
                           <a href="#" class="btn btn-primary">
                             결재대기 결재건
                             <span class="badge badge-center rounded-pill bg-label-warning">${approvalCnt }</span>
                           </a>
	                    </div>
	                  </div>
	                </div>
	                <div class="col-lg">
	                  <div class="card mb-4">
	                    <h5 class="card-header">오늘의 출/퇴근</h5>
	                    <div class="card-body">
	                    </div>
	                  </div>
	                </div>
				</div>
				<div class="row">
					<div class="col-lg">
	                  <div class="card mb-4">
	                    <h5 class="card-header">
	                    	이번달 일정
	                    </h5>
	                    <div class="card-body">
	                    	<div id="calendar"></div>
	                    </div>
	                  </div>
	                </div>
	                <div class="col-lg">
	                  <div class="card mb-4">
	                    <h5 class="card-header">최근 공지사항</h5>
	                    <div class="card-body">
	                    </div>
	                  </div>
	                </div>
				</div>
              </div>
      		</div>

		    <!-- Overlay -->
		    <div class="layout-overlay layout-menu-toggle"></div>
    	</div>
   	</div>
   </div>
    <!-- / Layout wrapper -->
    </div>


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
    <script src="${pageContext.request.contextPath}/assets/js/pages-account-settings-account.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
  	
  </body>
</html>