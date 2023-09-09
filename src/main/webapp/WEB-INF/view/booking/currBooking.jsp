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
    	let startYmd = '';
    	let startTime = '';
    	let endYmd = '';
    	let endTime = '';
    	let trgtNo = 0;
    	$(document).ready(function() {
    	  var calendarDiv = document.getElementById('calendar');

    	  var calendar = new FullCalendar.Calendar(calendarDiv, {
    		height: '100%',
    		selectable: true,
    	    initialView: 'resourceTimelineDay',
    	    headerToolbar: {
    	      left: 'prev,next today',
    	      center: 'title',
    	      right: 'resourceTimelineWeek,timeGridDay'
    	    },
    	    resourceGroupField: 'building',
    	    resources: '/yeyebooks/booking/bookingTargets',
    	    events: '/yeyebooks/booking/bookingList',
    	    locale: 'ko',
   	      	select: function(info) {
   	      		const startInfo = info.startStr.split("T");
	        	startYmd = startInfo[0];
	        	startTime = startInfo[1].split("+")[0];
	        	const endInfo = info.endStr.split("T");
	        	endYmd = endInfo[0];
	        	endTime = endInfo[1].split("+")[0];
	        	trgtNo = info.resource.id;
	        	$.ajax({
	        		url: '/yeyebooks/booking/isOverlap',
	        		type: 'get',
	     			data: {
	     				bookingStart: startYmd + ' ' + startTime,
	     				bookingEnd: endYmd + ' ' + endTime,
	     				targetNo: trgtNo
	     			},
	     			dataType: 'json',
	     			success: function(data, textStatus, xhr){
	     				if(xhr.status === 200){
	     					if(data.success === true){
	     						$('#bookingTarget').val(info.resource.title);
		     		        	$('#bookingStart').val(startYmd + " " + startTime);
		     		        	$('#bookingEnd').val(endYmd + " " + endTime);
		     		        	$('#modalCenter').modal('show');
	     					}else{
	     						alert('중복값');
	     						calendar.unselect();
	     					}
	     				}else{
	     					alert('요청실패');
	     				}
	     			}
	        	})
   	      	}
    	  });

    	  calendar.render();
    	});
    	
    	function addBooking(){
    		const bkgPurpose = $('#bookingPurpose').val();
    		if(bkgPurpose == ''){
    			Swal.fire({
    				icon: 'warning',
    				title: '예약실패',
    				text: '예약목적을 입력하세요'
    			})
    			return;
    		}
    		$.ajax({
    			url: '/yeyebooks/booking/addBooking',
    			type: 'post',
    			data: {
    				bkgStartYmd: startYmd,
    				bkgStartTime: startTime,
    				bkgEndYmd: endYmd,
    				bkgEndTime: endTime,
    				trgtNo: trgtNo,
    				bkgPurpose: bkgPurpose
    			},
    			dataType: 'json',
    			success: function(response){
    				if(response.success){
    					Swal.fire({
        					icon: 'success',
        					title: '예약성공'
        				}).then(function(){
        					$('#modalCenter').modal('hide');
        					location.href="/yeyebooks/booking/bookingOne?bkgNo=" + response.bkgNo;
        				})
    				}else{
    					Swal.fire({
        					icon: 'error',
        					title: '예약실패'
        				})
    				}
    				
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
					<li class="menu-item">
						<button type="button" class="menu-link" onclick="location.href='myBooking'">
							<i class='bx bxs-user-detail'></i>
							<div data-i18n="Analytics">&nbsp;나의 예약목록</div>
						</button>
					</li>
					<li class="menu-item active">
						<button type="submit" class="menu-link" onclick="location.href='currBooking'">
							<i class='bx bxs-timer' ></i>
							<div data-i18n="Analytics">&nbsp;예약현황(예약하기)</div>
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
	<!-- Vertically Centered Modal -->

      <div class="mt-3">
        <!-- Modal -->
        <div class="modal fade" id="modalCenter" tabindex="-1" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="modalCenterTitle">예약하기</h5>
                <button
                  type="button"
                  class="btn-close"
                  data-bs-dismiss="modal"
                  aria-label="Close"
                ></button>
              </div>
              <div class="modal-body">
                <div class="row">
                  <div class="col mb-3">
                    <label for="bookingTarget" class="form-label">예약대상</label>
                    <input
                      type="text"
                      id="bookingTarget"
                      class="form-control"
                      readonly
                    />
                  </div>
                </div>
                <div class="row g-2">
                  <div class="col mb-0">
                    <label for="bookingStart" class="form-label">시작일시</label>
                    <input
                      type="datetime"
                      id="bookingStart"
                      class="form-control"
                      readonly
                    />
                  </div>
                  <div class="col mb-0">
                    <label for="bookingEnd" class="form-label">종료일시</label>
                    <input
                      type="datetime"
                      id="bookingEnd"
                      class="form-control"
                      readonly
                    />
                  </div>
                </div>
                <div class="row">
                  <div class="col mb-3">
                    <label for="bookingPurpose" class="form-label">예약목적</label>
                    <input
                      type="text"
                      id="bookingPurpose"
                      class="form-control"
                    />
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                  닫기
                </button>
                <button type="button" class="btn btn-primary" onclick="addBooking()">예약하기</button>
              </div>
            </div>
          </div>
        </div>
      </div>

   	<!-- card End -->

    <jsp:include page="../inc/coreJs.jsp"></jsp:include>
  </body>
</html>