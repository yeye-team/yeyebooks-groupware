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
		$(document).ready(function() {
			// url파라미터값 삭제
			/* history.replaceState({}, null, location.pathname);  */
			
        	const calendarEl = document.getElementById('calendar');
        	const calendar = new FullCalendar.Calendar(calendarEl, {
        		customButtons: {
        			addSchedule: {
        				text: '일정 추가',
        				click: function(){
        					alert('일정추가');
        				}
        			}
        			/* dayGridMonth: {
        				text: '달력보기'
        			} */
        		},
        		
        		headerToolbar: {
                    //left: 'dayGridMonth,dayGridWeek,dayGridDay', 월/주/일별로 보기
                    left: 'today prev,next',
                    center: 'title',
                    right: 'addSchedule dayGridMonth'
                },
                locale: 'ko',
                selectable: true, // 날짜를 드래그를 통해 영역지정
                select: function (info) {
                    const selectedDate = info.start; // 선택한 날짜 정보
                    openModal(selectedDate); // 모달을 열기 위한 함수 호출
                  },
                selectMirror: true,
                navLinks: true, // 날짜 클릭시 세부스케줄 확인
                editable: false, // 스케줄 위치 옮길수있게
	        	googleCalendarApiKey: 'AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw',
		   	  	events: {
		   	    	googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
		   	  		color: 'red',
		   	  		textColor: 'white',
		   	  	}
	        });
	        calendar.render();
	        
	        // 날짜 선택시 모달 출력
	        function openModal(selectedDate) {
	        	  const modal = new bootstrap.Modal(document.getElementById('modalCenter'));
	        	  const modalTitle = document.getElementById('modalCenterTitle');
	        	  
	        	  const nextDate = new Date(selectedDate);
	        	  nextDate.setDate(nextDate.getDate());
	        	  const formattedDate = nextDate.getFullYear() + '-' + 
	        	                       ('0' + (nextDate.getMonth() + 1)).slice(-2) + '-' + 
	        	                       ('0' + nextDate.getDate()).slice(-2);
	        	  modalTitle.innerText = 'Selected Date: ' + formattedDate;
	        	  
	        	  $.ajax({
	        		    url: '/scheduleList', // 컨트롤러 경로
	        		    method: 'GET',
	        		    data: { targetDate: formattedDate },
	        		    success: function (response) {
	        		      // 받아온 일정 리스트를 모달 내에 삽입하는 작업
	        		      const scheduleListDiv = document.getElementById('scheduleList');
	        		      scheduleListDiv.innerHTML = '';
	        		      
	        		      response.forEach(s => {
	        		          const scheduleItem = document.createElement('div');
	        		          scheduleItem.className = 'mb-2';
	        		          scheduleItem.innerText = `[${s.skdCatCd}] ${s.skdStartTime} - ${s.skdEndTime}: ${s.skdTitle}`;
	        		          scheduleListDiv.appendChild(scheduleItem);
	        		        });

	        		        modal.show();
	        		    },
	        		    error: function (error) {
	        		      console.error('일정 불러오기 실패:', error);
	        		    }
	        		  });
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
									<div class="card-body ">
										<div class="mb-2 text-center">
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
										</div>
										<div id="calendar"></div>
										
										<!-- Modal -->
				                        <div class="modal fade" id="modalCenter" data-bs-backdrop="static" tabindex="-1" aria-hidden="true" style="display: none;">
				                          <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
				                            <div class="modal-content">
				                            <!-- 모달 제목 -->
				                              <div class="modal-header">
				                                <h5 class="modal-title" id="modalCenterTitle"></h5>
				                                <button
				                                  type="button"
				                                  class="btn-close"
				                                  data-bs-dismiss="modal"
				                                  aria-label="Close"
				                                ></button>
				                              </div>
				                              <!-- 모달 내용 -->
				                              <div class="modal-body">
												<div id="scheduleList">
												</div>
				                              </div>
				                              <div class="modal-footer">
				                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
				                                  Close
				                                </button>
				                                <button type="button" class="btn btn-primary">Save changes</button>
				                              </div>
				                            </div>
				                          </div>
				                        </div>
				                        <!-- modal end -->
				                        
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
