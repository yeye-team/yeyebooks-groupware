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
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
	<link href='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.css' rel='stylesheet' />
    <script src='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.js'></script>
  	<style>
  		.card-header, .card-header a{
  			color: #666;
			font-weight: bold;
			transition: all 0.2s linear;
  		}
  		.card-body .btn+.btn{
  			margin-left: 0.5rem;
  		}
  		#calendar .fc-scroller {
		  overflow-x: hidden !important;
		  overflow-y: auto;
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
		.table tbody tr{
			transition: all 0.2s linear;
		}
		.table tbody tr:hover{
			background-color: gray;
			color: white;
			cursor: pointer;
		}
		#nowTime{
			font-size: xxx-large;
			font-weight: bold;
			color: #555;
		}
		.time-check{
			width: 30%;
			font-weight: bold;
			color: #666;
		}
		.time-check button{
			width: 100%;
		}
		.time-check + .time-check{
			margin-left: 10%;
		}
		.fc-license-message{
			display: none;
		}
  	</style>
  	<script>
	  	 function moveToBoardOne(boardNo){
	     	location.href="/yeyebooks/board/boardOne?boardNo=" + boardNo; 
	     }
	  	 
		function updateTime(){
			let nowTime = dayjs().format('HH:mm:ss');
		 	$('#nowTime').text(nowTime);
		}
		
  		$(document).ready(function() {
  			updateTime();
  			
        	const calendarEl = document.getElementById('calendar');
        	const calendar = new FullCalendar.Calendar(calendarEl, {
	        	headerToolbar: false,
	        	googleCalendarApiKey: 'AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw',
		   	  	events: {
		   	    	googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
		   	  		color: 'red',
		   	  		textColor: 'white',
		   	  	},
	        });
	        calendar.render();
	        
	        setInterval(updateTime, 1000);
	        
	        $('#moveToNoticeAll').click(function(){
	        	location.href="/yeyebooks/board/boardList?boardCatCd=00";
	        })
	        
	        $('#moveToCalendarAll').click(function(){
	        	// 캘린더 주소
	        	location.href="/yeyebooks/schedule";
	        })
	        $('#moveToWaitingAll').click(function(){
	        	// 진행중인 문서 주소
	        	location.href="/yeyebooks/approval/approvalList?status=1"
	        })
	        $('#moveToWorkTimeAll').click(function(){
	        	// 근태현황 전체 주소
	        	location.href="/yeyebooks/vacationList"
	        })
	        $('#workStart').click(function(){
	        	const workStartTime = $('#nowTime').text();
	        	$.ajax({
	        		url: "/yeyebooks/workStart",
	        		type: "POST",
	        		data: {
	        			workStartTime: workStartTime
	        		},
	        		success: function(){
	        			Swal.fire({
			                icon: 'success',
			                title: '출근 성공',
			           }).then(function(){
			        	   $('#workStartTime').text(workStartTime);
			        	   $('#workEnd').prop('disabled', false);
			        	   $('#workStart').prop('disabled', true);
			           })
	        		}
	        	})
	        })
	        $('#workEnd').click(function(){
	        	const workEndTime = $('#nowTime').text();
	        	$.ajax({
	        		url: "/yeyebooks/workEnd",
	        		type: "POST",
	        		data: {
	        			workEndTime: workEndTime
	        		},
	        		success: function(){
	        			Swal.fire({
			                icon: 'success',
			                title: '퇴근 성공',
			           }).then(function(){
			        	   $('#workEndTime').text(workEndTime);
			        	   $('#workEnd').prop('disabled', true);
			           })
	        		}
	        	})
	        })
      });
	
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
						<!-- 대기중인 결재건수 -->
	                	<div class="card mb-4">
		                    <h5 class="card-header d-flex justify-content-between align-items-center">
		                    	<a>
		                    		대기중인 결재건
		                    		<span class="badge bg-warning rounded-pill">${approvalCnt + approveCnt }</span>
		                    	</a>
		                    	<button type="button" class="btn btn-secondary" id="moveToWaitingAll">전체보기</button>
		                 	</h5>
	                    	<div class="card-body ">
	                          <a href="approval/approvalList?status=2" class="btn btn-primary btn-lg">
	                            승인대기 결재건
	                            <span class="badge badge-center rounded-pill bg-label-warning">${approveCnt }</span>
	                          </a>
	                          <a href="approval/approvalList?status=3" class="btn btn-primary btn-lg">
	                            결재대기 결재건
	                            <span class="badge badge-center rounded-pill bg-label-warning">${approvalCnt }</span>
	                          </a>
	                    	</div>
	                  	</div>
	                  	<!-- 오늘의 일정 -->
	                  	<div class="card mb-4">
	                    	<h5 class="card-header d-flex justify-content-between align-items-center">
	                    		오늘의 일정
	                    		<button type="button" class="btn btn-secondary" id="moveToCalendarAll">일정전체</button>
	                    	</h5>
	                    	<div class="card-body ">
	                    		<div class="mb-2 text-center">
	                    			<c:if test="${scheduleList.size() == 0}">
	                    				<span class="badge bg-secondary">오늘 날짜의 일정이 없습니다.</span>
	                    			</c:if>
		                    		<c:forEach var="s" items="${scheduleList }">
		                    			<c:if test="${s.skdCategory == '전체' }">
		                    				<span class="badge bg-info">[전체]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
		                    			</c:if>
		                    			<c:if test="${s.skdCategory == '부서' }">
		                    				<span class="badge bg-success">[부서]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
		                    			</c:if>
		            					<c:if test="${s.skdCategory == '개인' }">
		                    				<span class="badge bg-dark">[개인]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
		                    			</c:if>
		                    		</c:forEach>
	                    		</div>
	                    		<div id="calendar"></div>
	                    	</div>
	                  	</div>
	                </div>
	                <div class="col-lg">
	                	<!-- 출퇴근 버튼 -->
	                  	<div class="card mb-4">
	                    	<h5 class="card-header d-flex justify-content-between align-items-center">
	                    		오늘의 출/퇴근
	                    		<button type="button" class="btn btn-secondary" id="moveToWorkTimeAll">근태전체</button>
	                    	</h5>
	                    	<div class="card-body text-center">
	                    		<span id="nowTime"></span>

	                    		<c:if test="${isInCompany == false}">
	                    			<c:set var="companyOnly" value="disabled"></c:set>
	                    		</c:if>
	                    		<c:if test="${workStartTime != null }">
	                    			<c:set var="workStarted" value="disabled"></c:set>
	                    		</c:if>
	                    		<c:if test="${workEndTime != null || workStartTime == null}">
	                    			<c:set var="workEnded" value="disabled"></c:set>
	                    		</c:if>
                    		
                    			<div class="d-flex align-items-center justify-content-center">
	                    			<div class="text-center time-check">
	                    				<button type="button" class="btn btn-primary" ${companyOnly} ${workStarted} id="workStart">출근</button>
	                    				<div>출근시간 : <span id="workStartTime">${workStartTime != null ? workStartTime : '--:--:--'}</span></div>
	                    			</div>
	                    			<div class="text-center time-check">
	                    				<button type="button" class="btn btn-primary" ${companyOnly} ${workEnded} id="workEnd">퇴근</button>
                    					<div>퇴근시간 : <span id="workEndTime">${workEndTime != null ? workEndTime : '--:--:--'}</span></div>
	                    			</div>
                    			</div>
	                    	</div>
	                  	</div>
	                  	<!-- 공지사항 목록(최근꺼) -->
	                  	<div class="card mb-4">
	                    	<h5 class="card-header d-flex justify-content-between align-items-center">
	                    		최근 공지사항
	                    		<button type="button" class="btn btn-secondary" id="moveToNoticeAll">공지전체</button>
	                    	</h5>
	                    	<div class="card-body">
	                    		<div class="table-responsive text-nowrap">
	                  				<table class="table">
					                    <thead>
					                    	<tr>
					                        	<th>공지제목</th>
					                        	<th class="text-center">공지일자</th>
					                        	<th class="text-center">조회수</th>
					                      	</tr>
					                    </thead>
					                    <tbody class="table-border-bottom-0">
					                    	<c:forEach var="b" items="${noticeList }">
					                    		<tr onclick="moveToBoardOne(${b.boardNo})">
					                    			<td>${b.boardTitle }</td>
					                    			<td class="text-center">${b.CDate }</td>
					                    			<td class="text-center">${b.boardView }</td>
					                    		</tr>
					                    	</c:forEach>
					                    </tbody>
									</table>
               					</div>
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