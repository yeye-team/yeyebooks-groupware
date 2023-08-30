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
	<title>일정관리</title>
	
    <jsp:include page="./inc/head.jsp"></jsp:include>
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <link href='${pageContext.request.contextPath}/fullcalendar-5.11.5/lib/main.css' rel='stylesheet' />
    <script src='${pageContext.request.contextPath}/fullcalendar-5.11.5/lib/main.js'></script>
    <script src="${pageContext.request.contextPath}/fullcalendar-5.11.5/lib/locales/ko.js"></script>
    <script>
    	//full calenader
		document.addEventListener('DOMContentLoaded', function() {	
        	const calendarEl = document.getElementById('calendar');
        	const userId = "${userId}";
        	
        	const calendar = new FullCalendar.Calendar(calendarEl, {
        		aspectRatio: 1.35,
        		headerToolbar: {
                    //left: 'dayGridMonth,dayGridWeek,dayGridDay', 월/주/일별로 보기
                    left: 'today prev,next',
                    center: 'title',
                    right: '회사 부서 개인 초기화 dayGridMonth'
                },
                customButtons: {
                    회사: {
                        text: '회사',
                        click: function() {
                            fetchEventsByCategory('00'); // '회사' 버튼을 클릭하면 '00' 값을 넘김
                        }
                    },
                    개인: {
                        text: '개인',
                        click: function() {
                            fetchEventsByCategory('99'); // '개인' 버튼을 클릭하면 '99' 값을 넘김
                        }
                    },
                    부서: {
                        text: '부서',
                        click: function() {
                        	fetchEventsByCategory('user');
                        }
                    },
                    초기화 : {
                    	text: '초기화',
                    	click: function(){
                    		fetchInitialEvents();
                    	}
                    }
                },
                locale: 'ko',
                selectable: true, // 날짜를 드래그를 통해 영역지정
                selectMirror: true,
                navLinks: true, // 날짜 클릭시 세부스케줄 확인
                editable: false, // 스케줄 위치 옮길수있게
                events: function(info, successCallback, failureCallback) { // 모든 일정
                	fetchEvents(successCallback, failureCallback);
                },
                googleCalendarApiKey: 'AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw', // Google API 키 입력
                eventSources: [
                    {
                        googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
                        color: 'red',
                        textColor: 'white'
                    }
                ]
	        });
        	
        	calendar.render();
		
        	// 최초 실행 함수
        	function fetchEvents(successCallback, failureCallback) {
		        $.ajax({
		            url: '${pageContext.request.contextPath}/events',
		            dataType: 'json',
		            success: function(data) {
		                const events = data.map(item => ({
		                    title: item.skdTitle,
		                    start: item.skdStartYmd,
		                    color: getColorByCategory(item.skdCatCd)
		                }));
		                successCallback(events);
		            },
		            error: function() {
		                failureCallback();
		            }
		        });
		    }
        	
			// 화사/개인/일정 버튼 누를때마다 값을 바꿈
			function fetchEventsByCategory(category) {
		        $.ajax({
		            url: '${pageContext.request.contextPath}/events',
		            data: { category: category }, // 선택된 카테고리 값을 파라미터로 전달
		            dataType: 'json',
		            success: function(data) {
		                const events = data.map(item => ({
		                    title: item.skdTitle,
		                    start: item.skdStartYmd,
		                    color: getColorByCategory(item.skdCatCd)
		                }));
		                const googleCalendarEvents = {
                                googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
                                color: 'red',
                                textColor: 'white'
                        };
		                calendar.getEvents().forEach(event => event.remove()); // 일정 제거
		                calendar.addEventSource(events);
		                calendar.addEventSource(googleCalendarEvents);
		            },
		            error: function() {
		                alert('조회 실패');
		            }
		        });
		    }
			
			// 초기화 함수
			function fetchInitialEvents() {
				$.ajax({
                    url: '${pageContext.request.contextPath}/events',
                    dataType: 'json',
                    success: function(data) {
                        const events = data.map(item => ({
                            title: item.skdTitle,
                            start: item.skdStartYmd,
                            color: getColorByCategory(item.skdCatCd)
                        }));
                        const googleCalendarEvents = {
                                googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
                                color: 'red',
                                textColor: 'white'
                        };
                        calendar.removeAllEvents();
                        calendar.addEventSource(events);
                        calendar.addEventSource(googleCalendarEvents);
                    },
                    error: function() {
                        alert('초기화 실패');
                    }
                });
		    }
	    	
			// 각 일정마다 다르게 색 부여
			function getColorByCategory(category) {
			   if(category === '00'){ // 전체
				   return 'purple';
			   } else if(category === '99'){ // 개인
				   return 'blue';
			   } else { // 부서
				   return 'green'
			   }
			}
		});
    </script>
    <style>
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
    </style>
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
								<!-- 오늘의 일정 -->
								<div class="card mb-4">
									<!-- <h5 class="card-header d-flex justify-content-between align-items-center">
										오늘의 일정
									</h5> -->
									<div class="card-body">
										<%-- <div class="mb-2 text-center">
											<c:if test="${scheduleList.size() == 0}">
												<span class="badge bg-secondary">오늘 날짜의 일정이 없습니다.</span>
											</c:if>
											<c:forEach var="s" items="${scheduleList}">
												<c:choose>
													<c:when test="${s.skdCategory == '전체'}">
														<span class="badge bg-info">[전체]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
													</c:when>
													<c:when test="${s.skdCategory == '부서'}">
														<span class="badge bg-success">[부서]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
													</c:when>
													<c:when test="${s.skdCategory == '개인'}">
														<span class="badge bg-dark">[개인]${s.skdStartTime.substring(0,2)}시 ${s.skdStartTime.substring(3,5)}분 ${s.skdTitle }</span>
													</c:when>
												</c:choose>
											</c:forEach>
										</div> --%>
										<div id="calendar"></div>
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
	<jsp:include page="./inc/coreJs.jsp"></jsp:include>
	</body>
</html>
