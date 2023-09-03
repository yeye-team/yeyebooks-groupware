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
		                
		                console.log(response);
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
		             	//console.log(selectedEvent);
		             	
		             	// 작성자가 일치하지 않으면 수정/삭제 버튼을 숨김
		             	if(userId !== selectedEvent.skdUserId) {
		                    $('#deleteScheduleBtn').hide();
		                    $('#editScheduleBtn').hide();
		                } else {
		                	$('#deleteScheduleBtn').show();
		                    $('#editScheduleBtn').show();
		                }
		             	
		    	     	// 수정 버튼 클릭
		    	        $('#editScheduleBtn').on('click', function() {
		    	        	openEditModal(selectedEvent);
		    	        });
		    	     	
		             	// 일정상세에서 '삭제' 버튼 클릭 -> '확인' 클릭시 삭제 
		                $('#deleteScheduleBtn').on('click', function() {
	                    	Swal.fire({
	                            title: '경고',
	                            text: "일정을 삭제하시겠습니까?",
	                            icon: 'warning',
	                            showCancelButton: true,
	                            confirmButtonColor: '#3085d6',
	                            cancelButtonColor: '#d33',
	                            confirmButtonText: '삭제',
	                            cancelButtonText: '취소'
	                        }).then((result) => {
	                            if (result.isConfirmed) {
		                        	deleteSchedule(selectedEvent.skdNo);
		                    	}
	                        });
		                });
		    	        
		            },
		            error: function() {
		                console.error('상세 조회 실패');
		            }
		        });
		    }

		    // 일정수정
			function openEditModal(selectedEvent) {
				$('#scheduleOneModal').modal('hide');
			    $('#modifyScheduleModal').modal('show');
			    
			    // 카테고리 설정
			    var catCd = selectedEvent.skdCatCd;
		    	// 수정대상이 개인일경우 99 check	
			    if(catCd == 99){
			    	$('.modifyCatCd[value="99"]').prop('checked', true);
			    } else {
			    	$('.modifyCatCd[value="user"]').prop('checked', true);
			    }
			    
			    // 제목에서 카테고리 제외
			    var titleWithoutCat = selectedEvent.skdTitle.substring(selectedEvent.skdTitle.indexOf(']') + 2);
			    
			    // 날짜에서 시간 제외
				var skdStartYmd = selectedEvent.skdStartYmd.substring(0, 10);
				var skdEndYmd = selectedEvent.skdEndYmd.substring(0, 10); 
				
			    // 수정 모달에 일정 정보 채우기
			    $('.modifyTitle').val(titleWithoutCat);
			    $('.modifyContents').val(selectedEvent.skdContents);
			    $('.modifyStartYmd').val(skdStartYmd);
			    $('.modifyStartTime').val(selectedEvent.skdStartTime);
			    $('.modifyEndYmd').val(skdEndYmd);
			    $('.modifyEndTime').val(selectedEvent.skdEndTime);
			
			    $('#modifyScdBtn').on('click', function () {
			        // 수정 버튼 클릭 시 값 담기
			        var modifiedEvent = {
			            skdNo: selectedEvent.skdNo,
			           	userId: selectedEvent.skdUserId,
			            skdCatCd: $('.modifyCatCd:checked').val(),
			            skdTitle: $('.modifyTitle').val(), 
			            skdContents: $('.modifyContents').val(),
			            skdStartYmd: $('.modifyStartYmd').val(),
			            skdStartTime: $('.modifyStartTime').val(),
			            skdEndYmd: $('.modifyEndYmd').val(),
			            skdEndTime: $('.modifyEndTime').val(),
			        };

			     	// 라디오 버튼 부서로 설정 시 사용자의 부서번호를 value로 설정
			        if (modifiedEvent.skdCatCd == "user") {
			            modifiedEvent.skdCatCd = selectedEvent.skdCatCd;
			        }
			     	console.log(modifiedEvent);
			        // 수정 실행
			        modifySchedule(modifiedEvent);
			    });
			
			    $('#cancelModifyBtn').on('click', function () {
			        // 취소 버튼 클릭 시 모달 닫기
			        $('#modifyScheduleModal').modal('hide');
			        $('#scheduleOneModal').modal('show');
			    });
			}
		    
		    // 수정 실행
		    function modifySchedule(modifiedEvent) {
			    $.ajax({
			        type: 'POST',
			        url: '${pageContext.request.contextPath}/events/modifySchedule',
			        data: JSON.stringify(modifiedEvent), // 데이터를 JSON 형식으로 변환하여 전송
			        contentType: 'application/json', // 전송 데이터 타입 설정
			        dataType: 'json',
			        success: function(response) {
			            Swal.fire({
			                title: '수정 완료',
			                text: '일정이 수정되었습니다.',
			                icon: 'success',
			                confirmButtonColor: '#3085d6',
			                confirmButtonText: '확인'
			            }).then((result) => {
			                if (result.isConfirmed) {
			                	$('#modifyScheduleModal').modal('hide');
			                	openEventModal({ id: modifiedEvent.skdNo });
			                }
			            });
			        },
			        error: function() {
			            console.error('일정 수정 실패');
			        }
			    });
		    };
		    
			// 일정삭제
		    function deleteSchedule(skdNo) {
		    	$.ajax({
		            type: 'POST',
		            url: '${pageContext.request.contextPath}/events/deleteSchedule',
		            data: {
		                skdNo: skdNo
		            },
		            success: function(response) {
		                if (response.success) {
		                	$('#scheduleOneModal').modal('hide');
		                    calendar.refetchEvents();
		                    Swal.fire({
		                        icon: 'success',
		                        title: '삭제 성공',
		                        text: '일정이 삭제되었습니다.'
		                    });
		                } else {
		                    console.error('삭제실패');
		                }
		            },
		            error: function() {
		                console.error('삭제실패');
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
										                <h3 class="modal-title" id="exampleModalLabel3"><strong>일정 상세</strong></h3>
										                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
										            </div>
										            <div class="modal-body">
										            	<div class="row">
										            		<div class="row mb-3">
							                                	<label class="form-label">제목
							                                		<span class="form-control skdTitle">제목</span>
							                                	</label>
							                                </div>
								                            <div class="row mb-3">
							                                	<label class="form-label">내용
								                                	<span class="form-control skdContents"></span>
							                                	</label>
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
										
										<!-- 수정하기 모달창 -->
										<div class="modal fade" id="modifyScheduleModal" tabindex="-1" aria-hidden="true">
										    <div class="modal-dialog modal-lg" role="document">
										        <div class="modal-content">
										            <div class="modal-header">
										                <h3 class="modal-title" id="exampleModalLabel3"><strong>일정 수정</strong></h3>
										                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
										            </div>
										            <div class="modal-body">
										            	<div class="row">
										            		<c:if test="${userId != 'admin'}">
											            		<div class="row mb-3">
								                                	<label for="titleSm" class="form-label">카테고리</label>
								                                	<div class="col mb-0">
									                                	<input type="radio" id="titleSm" name="modifyCd" class="modifyCatCd" value="user">부서
									                                </div>	
									                                <div class="col mb-0">
								                                		<input type="radio" id="titleSm" name="modifyCd" class="modifyCatCd" value="99">개인
								                                	</div>
								                                </div>
										            		</c:if>
										            		<div class="row mb-3">
							                                	<label class="form-label">제목
							                                		<input type="text" class="form-control modifyTitle" placeholder="제목을 입력하세요">
							                                	</label>
							                                </div>
								                            <div class="row mb-3">
							                                	<label class="form-label">내용
								                                	<input type="text" class="form-control modifyContents" placeholder="내용을 입력하세요">
							                                	</label>
							                                </div>
							                                <div class="row g-1">
								                                <div class="col mb-0 row g-1">
								                                	<label for="skdStartY" class="form-label">시작일</label>
								                                	<div class="col mb-5">
									                                	<input type="date" id="skdStartY" class="form-control modifyStartYmd">
									                                </div>	
									                                <div class="col mb-0">
									                                	<input type="time" class="form-control modifyStartTime">
								                                	</div>
								                                </div>
								                                <div class="col mb-0 row g-1">
								                                    <label for="skdEndY" class="form-label">종료일</label>
							                                		<div class="col mb-5">
									                                	<input type="date" id="skdEndY" class="form-control modifyEndYmd">
						                                			</div>
							                                		<div class="col mb-0">
									                                	<input type="time" class="form-control modifyEndTime">
						                                			</div>
																</div>
								                            </div>
										                </div>
										            </div>
										            <div class="modal-footer">
						                                <button type="button" class="btn btn-primary" id="modifyScdBtn">수정</button>
						                                <button type="button" class="btn btn-primary" id="cancelModifyBtn">취소</button>
											            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
										            </div>
										        </div>
										    </div>
										</div>
										
										<!-- 작성하기 모달창 -->
										<form>
											<div class="modal fade" id="insertScheduleModal" tabindex="-1" aria-hidden="true">
											    <div class="modal-dialog modal-lg" role="document">
											        <div class="modal-content">
											            <div class="modal-header">
											                <h3 class="modal-title" id="exampleModalLabel3"><strong>일정 작성</strong></h3>
											                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
											            </div>
											            <div class="modal-body">
											            	<div class="row">
											            		<c:if test="${userId != 'admin'}">
												            		<div class="row mb-3">
									                                	<label for="titleSm" class="form-label">카테고리</label>
									                                	<div class="col mb-0">
										                                	<input type="radio" id="titleSm" name="insertCd" value="user">부서
										                                </div>	
										                                <div class="col mb-0">
									                                		<input type="radio" id="titleSm" name="insertCd" value="99">개인
									                                	</div>
									                                </div>
											            		</c:if>
											            		<div class="row mb-3">
								                                	<label class="form-label">제목
								                                		<input type="text" class="form-control" placeholder="제목을 입력하세요">
								                                	</label>
								                                </div>
									                            <div class="row mb-3">
								                                	<label class="form-label">내용
									                                	<input type="text" class="form-control" placeholder="내용을 입력하세요">
								                                	</label>
								                                </div>
								                                <div class="row g-1">
									                                <div class="col mb-0 row g-1">
									                                	<label for="skdStartY" class="form-label">시작일</label>
									                                	<div class="col mb-5">
										                                	<input type="date" id="skdStartY" name="skdStartYmd" class="form-control">
										                                </div>	
										                                <div class="col mb-0">
										                                	<input type="time" name="skdStartTime" class="form-control">
									                                	</div>
									                                </div>
									                                <div class="col mb-0 row g-1">
									                                    <label for="skdEndY" class="form-label">종료일</label>
								                                		<div class="col mb-5">
										                                	<input type="date" id="skdEndY" name="skdEndYmd" class="form-control">
							                                			</div>
								                                		<div class="col mb-0">
										                                	<input type="time" name="skdEndTime" class="form-control">
							                                			</div>
																	</div>
									                            </div>
											                </div>
											            </div>
											            <div class="modal-footer">
							                                <button type="button" class="btn btn-primary" id="insertScdBtn">등록</button>
							                                <button type="button" class="btn btn-primary" id="cancelInsertBtn">취소</button>
												            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
											            </div>
											        </div>
											    </div>
											</div>
										</form>
										
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
