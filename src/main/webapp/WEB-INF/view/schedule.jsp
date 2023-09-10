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
    <link href='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.css' rel='stylesheet' />
    <script src='${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/main.js'></script>
    <script src="${pageContext.request.contextPath}/fullcalendar-scheduler-5.11.5/lib/locales/ko.js"></script>
    <script>
    	//full calenader
		document.addEventListener('DOMContentLoaded', function() {	
        	const calendarEl = document.getElementById('calendar');
        	const userId = "${userId}";
        	// 헤더툴바 출력버튼
        	const headerToolbarBtn = {
        	        left: '오늘 이전,다음',
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
                },
                dateClick: function(info) {
                    // 클릭된 날짜 정보
                    const clickedDate = info.date;
                    
				    // 모달 열기
				    $('#insertScheduleModal').modal('show');
				
				    var insertStartYInput = document.getElementById('insertSkdStartY');
				    var insertEndYInput = document.getElementById('insertSkdEndY');
				
				    // 클릭된 날짜에 하루를 더해 시작일과 종료일로 설정
				    const startDate = new Date(clickedDate);
				    const endDate = new Date(clickedDate);
				    startDate.setDate(startDate.getDate() + 1);
				    endDate.setDate(endDate.getDate() + 1);
				
				    insertStartYInput.value = startDate.toISOString().split('T')[0];
				    insertEndYInput.value = endDate.toISOString().split('T')[0];
                },
	        });
        	
        	const customButtons = {
        		    회사: {
        		        text: '회사',
        		        click: clickCatCd('00')
        		    },
        		    개인: {
        		        text: '개인',
        		        click: clickCatCd('99')
        		    },
        		    부서: {
        		        text: '부서',
        		        click: clickCatCd('user')
        		    },
        		    초기화 : {
        		        text: '초기화',
        		        click: clickCatCd()
        		    },
        		    이전 : {
        		    	text: '이전',
        		    	click: prevHandler
        		    },
        		    다음 : {
        		    	text: '다음',
        		    	click: nextHandler
        		    },
        		   	오늘 : {
        		   		text: '오늘',
        		   		click: todayButtonClick
        		   	}
       		};
        	
        	// 버튼 옵션 추가
			calendar.setOption('customButtons', customButtons);
        	
			function todayButtonClick() {
			    // FullCalendar에서 모든 이벤트를 제거
			    calendar.removeAllEvents();

			    // 오늘 날짜로 이동
			    calendar.gotoDate(new Date());
			}
			
			$('.fc-customButton-today').click(todayButtonClick);
			
        	// 이전/다음버튼에 값을 부여, 버튼을 누르고 이동시 해당 버튼값 전달
			let selectedCategory = null;
			
			function prevHandler() {
		        // 이전 버튼 동작
		        calendar.prev();
				if (selectedCategory !== null) {
			        // FullCalendar의 gotoDate 메소드를 호출한 후에 getEvents 호출
			        selectAllSchedule(selectedCategory);
			    }
			};
			
			function nextHandler() {
		        // 다음 버튼 동작
		        calendar.next();
				if (selectedCategory !== null) {
			        // FullCalendar의 gotoDate 메소드를 호출한 후에 getEvents 호출
			        selectAllSchedule(selectedCategory);
			    }
			};
			
        	// 카테고리 버튼을 눌렀을때 카테고리 값을 버튼에 부여하여 함수실행
        	function clickCatCd(skdCatCd) {
    		    return function() {
    		    	selectedCategory = skdCatCd;
    		        selectAllSchedule(skdCatCd);
    		    };
    		};

			// 화사/개인/일정 버튼 누를때마다 값을 바꿈
			function selectAllSchedule(skdCatCd) {
				let eventSourceUrl = '';
				
				// skdCatCd에 따라 다른 이벤트 소스 URL 선택
			    if (skdCatCd === '00') {
			        eventSourceUrl = '${pageContext.request.contextPath}/events/adminSchedule';
			    } else if (skdCatCd === '99') {
			        eventSourceUrl = '${pageContext.request.contextPath}/events/personalSchedule';
			    } else if (skdCatCd === 'user') {
			        eventSourceUrl = '${pageContext.request.contextPath}/events/deptSchedule';
			    } else {
			        eventSourceUrl = '${pageContext.request.contextPath}/events/everySchedule';
			    }
			    // 'skdCatCd' 값을 서버로 전송하여 일정 목록을 가져오는 ajax 요청
			    $.ajax({
			        url: eventSourceUrl,
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
		             	
		             	// 작성자가 일치하지 않으면 수정/삭제 버튼을 숨김
		             	if(userId !== selectedEvent.skdUserId) {
		                    $('#deleteScheduleBtn').hide();
		                    $('#editScheduleBtn').hide();
		                } else {
		                	$('#deleteScheduleBtn').show();
		                    $('#editScheduleBtn').show();
		                }
		             	
		    	     	// 수정 버튼 클릭
		    	        $('#editScheduleBtn').off('click').on('click', function() {
						    openModifyModal(selectedEvent);
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

			// 일정 등록
			// insertScdBtn 버튼 클릭 시
			$('#insertScdBtn').on('click', function() {
			    // 일정 정보 가져오기
			    var insertScheduleData = {
			        skdCatCd: $('input[name="insertCd"]:checked').val(),
			        skdTitle: $('input[name="skdTitle"]').val(),
			        skdContents: $('input[name="skdContents"]').val(),
			        skdStartYmd: $('input[name="skdStartYmd"]').val(),
			        skdStartTime: $('input[name="skdStartTime"]').val(),
			        skdEndYmd: $('input[name="skdEndYmd"]').val(),
			        skdEndTime: $('input[name="skdEndTime"]').val()
			    };
			
			    // AJAX를 이용해 일정 등록 요청 보내기
			    $.ajax({
			        type: 'POST',
			        url: '${pageContext.request.contextPath}/events/insertSchedule',
			        data: JSON.stringify(insertScheduleData), // 데이터를 JSON 형식으로 변환하여 전송
			        contentType: 'application/json', // 전송 데이터 타입 설정
			        dataType: 'json',
			        success: function(response) {
			            if (response.success) {
			            	// 입력 필드 초기화
			            	$('input[name="skdTitle"]').val('');
			            	$('input[name="skdContents"]').val('');
			            	$('input[name="skdStartYmd"]').val('');
			            	$('input[name="skdStartTime"]').val('');
			            	$('input[name="skdEndYmd"]').val('');
			            	$('input[name="skdEndTime"]').val('');
			                // 성공한 경우, 모달 닫기
			                $('#insertScheduleModal').modal('hide');
			                // 달력 갱신
			                calendar.refetchEvents();
			                // 성공 메시지 표시
			                Swal.fire({
			                    icon: 'success',
			                    title: '등록 성공',
			                    text: '일정이 등록되었습니다.'
			                });
			            } else {
			                console.error('등록 실패');
			            }
			        },
			        error: function() {
			            console.error('등록 실패');
			        }
			    });
			});
			
		    // 일정수정
			function openModifyModal(selectedEvent) {
		    	console.log(selectedEvent);
		    	
				$('#scheduleOneModal').modal('hide');
			    $('#modifyScheduleModal').modal('show');
			    
			    // 카테고리 설정
			    var catCd = selectedEvent.skdCatCd;
			    
			    if (catCd == 99) {
			        $('#modifyCd2').prop('checked', true);
			    } else {
			        $('#modifyCd1').prop('checked', true);
			    }
			    
			    // 제목에서 카테고리 제외
			    var titleWithoutCat = selectedEvent.skdTitle.substring(selectedEvent.skdTitle.indexOf(']') + 2);
			    
			    // 날짜에서 시간 제외
				var skdStartYmd = selectedEvent.skdStartYmd.substring(0, 10);
				var skdEndYmd = selectedEvent.skdEndYmd.substring(0, 10); 
				
				// 상세정보 값 설정
				$('#modifyTitle').val(titleWithoutCat);
			    $('#modifyContents').val(selectedEvent.skdContents);
			    $('#modifyStartYmd').val(skdStartYmd);
			    $('#modifyStartTime').val(selectedEvent.skdStartTime);
			    $('#modifyEndYmd').val(skdEndYmd);
			    $('#modifyEndTime').val(selectedEvent.skdEndTime);
			
			    $('#modifyScdBtn').off('click');
		        // 수정 버튼 클릭 시 값 담기
			    $('#modifyScdBtn').on('click', function () {
					var skdNo = selectedEvent.skdNo;
					var userId = selectedEvent.skdUserId;
					var skdCatCd = $('input[name="modifyCd"]:checked').val();
					var skdTitle = $('#modifyTitle').val();
					var skdContents = $('#modifyContents').val();
					var skdStartYmd = $('#modifyStartYmd').val();
					var skdStartTime = $('#modifyStartTime').val();
					var skdEndYmd = $('#modifyEndYmd').val();
					var skdEndTime = $('#modifyEndTime').val();

			        // 수정 실행
				    $.ajax({
				        type: 'POST',
				        url: '${pageContext.request.contextPath}/events/modifySchedule',
				        contentType: 'application/json', // 전송 데이터 타입 설정
				        data: JSON.stringify({
				        	skdNo : skdNo,
				        	userId : userId,
				        	skdTitle : skdTitle,
				        	skdCatCd : skdCatCd,
				        	skdContents : skdContents,
				        	skdStartYmd : skdStartYmd,
				        	skdStartTime : skdStartTime,
				        	skdEndYmd : skdEndYmd,
				        	skdEndTime : skdEndTime
				        }), // 데이터를 JSON 형식으로 변환하여 전송
				        success: function(response) {
				        	$('#modifyScheduleModal').modal('hide');
				            Swal.fire({
				                title: '수정 완료',
				                text: '일정이 수정되었습니다.',
				                icon: 'success'
				            });
				            // 캘린더 새로고침
		                	calendar.refetchEvents();
				        },
				        error: function() {
				            console.error('일정 수정 실패');
				        }
					});
			    });
			
			    $('#cancelModifyBtn').on('click', function () {
			        // 취소 버튼 클릭 시 모달 닫기
			        $('#modifyScheduleModal').modal('hide');
			        $('#scheduleOneModal').modal('show');
			    });
			}
		    
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
    <script>
	$(document).ready(function() {
		// 공통 정규식
	    var titleRegex = /^[A-Za-z0-9가-힣!@#$%^&*()_+{}\[\]:;<>,.?~\s]{1,10}$/;
	    var contentsRegex = /^[A-Za-z0-9가-힣!@#$%^&*()_+{}\[\]:;<>,.?~\s]{1,50}$/;
	    var dateRegex = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
	    var timeRegex = /^[0-9]{2}:[0-9]{2}:[0-9]{2}$/;
        
	 	// 제목 입력란 blur 함수
	    $("#modifyTitle, input[name='skdTitle']").blur(function() {
	        var input = $(this);
	        var value = input.val();
	        
	        if (!titleRegex.test(value)) {
	        	Swal.fire({
	        		title: '경고',
	                text: '제목은 10자 이내의 한글, 영문, 숫자, 특수문자로 입력하세요.',
	                icon: 'warning',
	        	});
	            input.val("");
	        }
	    });

	    // 내용 입력란 blur 함수
	    $("#modifyContents, input[name='skdContents']").blur(function() {
	        var input = $(this);
	        var value = input.val();

	        if (!contentsRegex.test(value)) {
	        	Swal.fire({
	        		title: '경고',
	                text: '내용은 50자 이내의 한글, 영문, 숫자, 특수문자로 입력하세요.',
	                icon: 'warning',
	        	});
	            input.val("");
	        }
	    });
	    
	    $("#insertScdBtn, #modifyScdBtn").click(function() {
	        // 모든 입력란의 값을 가져옵니다.
	        var titleInput = $("#modifyTitle, input[name='skdTitle']");
	        var contentsInput = $("#modifyContents, input[name='skdContents']");
	        var startYmdInput = $("#modifyStartYmd, input[name='skdStartYmd']");
	        var endYmdInput = $("#modifyEndYmd, input[name='skdEndYmd']");
	        var startTimeInput = $("#modifyStartTime, input[name='skdStartTime']");
	        var endTimeInput = $("#modifyEndTime, input[name='skdEndTime']");

	        // 입력값이 빈 값인지 확인합니다.
	        var isEmpty = titleInput.val().trim() === "" ||
	                      contentsInput.val().trim() === "" ||
	                      startYmdInput.val().trim() === "" ||
	                      endYmdInput.val().trim() === "" ||
	                      startTimeInput.val().trim() === "" ||
	                      endTimeInput.val().trim() === "";

	        // 빈 값이 있다면 경고 메시지를 표시하고 함수를 종료합니다.
	        if (isEmpty) {
	            Swal.fire({
	                title: '경고',
	                text: '빈 입력창이 있습니다',
	                icon: 'warning'
	            });
	            return false;
	        }
	    });
	});
	</script>
    
	</head>

	<body>
	<!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
		<!-- Layout container -->
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
		            <li class="menu-item active">
		              <a class="menu-link">
		                <i class='menu-icon tf-icons bx bx-calendar'></i>
		                일정
		              </a>
		            </li>
	          	</ul>
	        </aside>
	        <!-- / Menu -->
	        
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
										            		<c:choose>
										            			<c:when test="${userId == 'admin'}">
										            				<label class="form-label">카테고리
									                                	<input type="radio" id="modifyCd" name="modifyCd" value="00" checked="checked">회사
										            				</label>
										            			</c:when>
										            			<c:otherwise>
												            		<div class="row mb-3">
									                                	<label class="form-label">카테고리
										                                	<input type="radio" id="modifyCd1" name="modifyCd" value="user">부서
									                                		<input type="radio" id="modifyCd2" name="modifyCd" value="99">개인
									                                	</label>
									                                </div>
										            			</c:otherwise>
										            		</c:choose>
										            		<div class="row mb-3">
							                                	<label class="form-label">제목
							                                		<input type="text" class="form-control" id="modifyTitle" name="modifyTitle" placeholder="제목을 입력하세요" required="required">
							                                	</label>
							                                </div>
								                            <div class="row mb-3">
							                                	<label class="form-label">내용
								                                	<input type="text" class="form-control" id="modifyContents" name="modifyContents" placeholder="내용을 입력하세요" required="required">
							                                	</label>
							                                </div>
							                                <div class="row g-1">
								                                <div class="col mb-0 row g-1">
								                                	<label class="form-label">시작일
									                                	<div class="col mb-1">
										                                	<input type="date" id="modifyStartYmd" class="form-control" required="required">
										                                </div>	
										                                <div class="col mb-0">
										                                	<input type="time" id="modifyStartTime" class="form-control" required="required">
									                                	</div>
								                                	</label>
								                                </div>
								                                <div class="col mb-0 row g-1">
								                                    <label class="form-label">종료일
								                                		<div class="col mb-1">
										                                	<input type="date" id="modifyEndYmd" class="form-control" required="required">
							                                			</div>
								                                		<div class="col mb-0">
										                                	<input type="time" id="modifyEndTime"class="form-control" required="required">
							                                			</div>
								                                    </label>
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
										<div class="modal fade" id="insertScheduleModal" tabindex="-1" aria-hidden="true">
										    <div class="modal-dialog modal-lg" role="document">
										        <div class="modal-content">
										            <div class="modal-header">
										                <h3 class="modal-title" id="exampleModalLabel3"><strong>일정 추가</strong></h3>
										                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
										            </div>
										            <div class="modal-body">
										            	<div class="row">
										            		<c:choose>
										            			<c:when test="${userId == 'admin'}">
										            				<label for="titleSm" class="form-label">카테고리</label>
								                                	<div class="col mb-0">
									                                	<input type="radio" id="titleSm" name="insertCd" class="insertCatCd" value="00" checked="checked">회사
									                                </div>	
										            			</c:when>
										            			<c:otherwise>
												            		<div class="row mb-3">
									                                	<label for="titleSm" class="form-label">카테고리</label>
									                                	<div class="col mb-0">
										                                	<input type="radio" id="titleSm" name="insertCd" class="insertCatCd" value="user">부서
										                                </div>	
										                                <div class="col mb-0">
									                                		<input type="radio" id="titleSm" name="insertCd" class="insertCatCd" value="99">개인
									                                	</div>
									                                </div>
										            			</c:otherwise>
										            		</c:choose>
										            		<div class="row mb-3">
							                                	<label class="form-label">제목
							                                		<input type="text" class="form-control" name="skdTitle" placeholder="제목을 입력하세요" required="required">
							                                	</label>
							                                </div>
								                            <div class="row mb-3">
							                                	<label class="form-label">내용
								                                	<input type="text" class="form-control" name="skdContents"placeholder="내용을 입력하세요" required="required">
							                                	</label>
							                                </div>
							                                <div class="row g-1">
								                                <div class="col mb-0 row g-1">
								                                	<label for="skdStartY" class="form-label">시작일</label>
								                                	<div class="col mb-5">
									                                	<input type="date" id="insertSkdStartY" name="skdStartYmd" class="form-control" required="required">
									                                </div>	
									                                <div class="col mb-0">
									                                	<input type="time" name="skdStartTime" class="form-control" required="required">
								                                	</div>
								                                </div>
								                                <div class="col mb-0 row g-1">
								                                    <label for="skdEndY" class="form-label">종료일</label>
							                                		<div class="col mb-5">
									                                	<input type="date" id="insertSkdEndY" name="skdEndYmd" class="form-control" required="required">
						                                			</div>
							                                		<div class="col mb-0">
									                                	<input type="time" name="skdEndTime" class="form-control" required="required">
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
