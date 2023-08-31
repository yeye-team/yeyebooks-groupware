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
        	// 헤더툴바 출력버튼
        	const headerToolbarBtn = {
        	        left: 'today prev,next',
        	        center: 'title',
        	        right: '회사 부서 개인 초기화'
        	    };
        	
        	// 관리자 로그인시 회사 일정만 보이게
        	if (userId === "admin") {
        		headerToolbarBtn.right = '';
            };
        	
        	// 캘린더 설정
        	const calendar = new FullCalendar.Calendar(calendarEl, {
        		googleCalendarApiKey: 'AIzaSyDZTRgjuENE0svix_V-Fzl6EKEOttucbHw',
                eventSources: [
                    {
                        googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
                        color: 'red',
                        textColor: 'white'
                    }
                ],
                
        		aspectRatio: 1.35,
        		headerToolbar: headerToolbarBtn,
        		initialView: "dayGridMonth",
                locale: 'ko',
                selectable: false, // 날짜를 드래그를 통해 영역지정
                events: '${pageContext.request.contextPath}/events/everySchedule',
                eventClick: function(info) {
                	info.jsEvent.preventDefault();
                   
                	var event = info.event;
    	            selectedEvent = event; // 선택한 일정 변수에 저장 : 상세보기/수정
    	            openEventModal(event); // 상세보기
                }
	        });
        	
        	const customButtons = {
        		    회사: {
        		        text: '회사',
        		        click: clickCatCd('00') // 클릭 핸들러 함수 생성 및 할당
        		    },
        		    개인: {
        		        text: '개인',
        		        click: clickCatCd('99') // 클릭 핸들러 함수 생성 및 할당
        		    },
        		    부서: {
        		        text: '부서',
        		        click: clickCatCd('user') // 클릭 핸들러 함수 생성 및 할당
        		    },
        		    초기화 : {
        		        text: '초기화',
        		        click: clickCatCd()
        		    }
        		};
        	// 버튼 옵션 추가
			calendar.setOption('customButtons', customButtons);
        	
        	// 카테고리 버튼을 눌렀을때 카테고리 값을 버튼에 부여하여 함수실행
        	function clickCatCd(skdCatCd) {
    		    return function() {
    		        selectAllSchedule(skdCatCd);
    		    };
    		};

			// 화사/개인/일정 버튼 누를때마다 값을 바꿈
			function selectAllSchedule(skdCatCd) {
			    // 'skdCatCd' 값을 서버로 전송하여 일정 목록을 가져오는 ajax 요청
			    $.ajax({
			        url: '${pageContext.request.contextPath}/events/everySchedule',
			        type: 'GET',
			        data: {
	        			skdCatCd: skdCatCd 
		        	},
			        dataType: 'json',
			        success: function(data) {
			            const events = data.map(item => ({
			                id: item.id,
			                title: item.title,
			                start: item.start,
			                end: item.end
			            }));
			            
			            calendar.removeAllEvents(); // 기존의 모든 이벤트 제거
			            calendar.addEventSource(events); // 새로운 이벤트 소스 추가
			            calendar.render(); // 캘린더 다시 그리기
			        },
			        error: function() {
			            console.error('조회 실패');
			        }
			    });
			}
			
			// 상세보기
		    function openEventModal(event) {
		        // 일정 상세 정보를 가져오는 Ajax 요청
		        $.ajax({
		            type: 'GET',
		            url: '${pageContext.request.contextPath}/events/scheduleOne',
		            data: {
		            	skdNo: event.id 
		            }, // 해당 일정의 id 값을 전달
		            success: function(response) {
		                $('#scheduleOneModal').modal('show');
		                $('.skdTitle').text(response.skdTitle);
		                $('.skdContents').text(response.skdContents);
		                $('.skdStartYmd').text(response.skdStartYmd);
		                $('.skdEndYmd').text(response.skdEndYmd);
		                
		             	// response 객체에서 일정 정보를 읽어와서 selectedEvent 객체 생성
		                var selectedEvent = {
		                    skdNo: response.skdNo,
		                    skdTitle: response.skdTitle,
		                    skdContents: response.skdContents,
		                    skdStartYmd: response.skdStartYmd,
		                    skdEndYmd: response.skdEndYmd,
		                    skdStartTime: response.skdStartTime,
		                    skdEndTime: response.skdEndTime,
		                    skdCatCd: response.skdCatCd,
		                    skdUserId: response.userId
		                };
		             	console.log(selectedEvent);
		                if(selectedEvent.skdUserId != userId){
		                	$('#deleteScheduleBtn').display('hide');
		                	$('#editScheduleBtn').display('hide');
		                }
		             	
		             	// 기존의 click 이벤트 핸들러를 제거
		                $('#deleteScheduleBtn').off('click');
		                
		             	// 일정상세에서 '삭제' 버튼 클릭 -> '확인' 클릭시 삭제 
		                $('#deleteScheduleBtn').on('click', function() {
		                    if (confirm('진짜 삭제하시겠습니까?')) {
		                        deleteSchedule(event.id);
		                    }
		                });
		    	        
		    	     	// 수정 버튼 클릭
		    	        $('#editScheduleBtn').on('click', function() {
		    	        	openEditModal(selectedEvent);
		    	        });
		             
		            },
		            error: function() {
		                console.error('상세 조회 실패');
		            }
		        });
		    }
			
			calendar.render();
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
										<!-- 상세보기 모달창 -->
										<div class="modal fade" id="scheduleOneModal" tabindex="-1" aria-hidden="true">
										    <div class="modal-dialog modal-lg" role="document">
										        <div class="modal-content">
										            <div class="modal-header">
										                <h5 class="modal-title" id="exampleModalLabel3">일정 상세보기</h5>
										                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
										            </div>
										            <div class="modal-body">
										            	<div class="row">
										            		<div class="row mb-3">
							                                	<label for="titleLarge" class="form-label">제목</label>
							                                	<span id="titleLarge" class="form-control skdTitle"></span>
							                                </div>
								                            <div class="row mb-3">
							                                	<label for="contentLarge" class="form-label">내용</label>
							                                	<span id="contentLarge" class="form-control skdContents"></span>
							                                </div>
							                                <div class="row g-1">
								                                <div class="col mb-0">
								                                	<label for="skdStartY" class="form-label">시작일</label>
								                                	<span id="skdStartY" class="form-control skdStartYmd"></span>
								                                </div>
								                                <div class="col mb-0">
								                                    <label for="skdEndY" class="form-label">종료일</label>
								                                    <span id="skdEndY" class="form-control skdEndYmd"></span>
																</div>
								                            </div>
										                </div>
										            </div>
										            <div class="modal-footer">
						                                <button type="button" class="btn btn-primary" id="editScheduleBtn">수정</button>
						                                <button type="button" class="btn btn-primary" id="deleteScheduleBtn">삭제</button>
											            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
										            </div>
										        </div>
										    </div>
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
	<jsp:include page="./inc/coreJs.jsp"></jsp:include>
	</body>
</html>
