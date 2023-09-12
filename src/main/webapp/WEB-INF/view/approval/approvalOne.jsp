<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문서상세</title>
<jsp:include page="../inc/head.jsp"></jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>


<script>

	function approve(){
		const signUrl = $('#approvalUserSign').val();
		console.log(signUrl);
		if(signUrl == ''){
			Swal.fire({
				icon: 'error',
				text: '사인을 먼저 등록하세요'
			}).then(function(){
				location.href="/yeyebooks/mypage";
			})
			return;
		}
		
		$.ajax({
			url: '/yeyebooks/approval/approveApproval',
			type: 'post',
			data: {
				aprvNo: "${approval.aprvNo}",
				userId: "${sessionScope.userId}",
			},
			success: function(){
				Swal.fire({
					icon: 'success',
					title: '성공',
					text: '승인처리 되었습니다.'
				}).then(function(){
					location.href="approvalList";
				})
			}
		})
	}
	// 확인 버튼 클릭 시
	function openRejectionModal() {
	  $('#modalCenter').modal('show');
	}
	function rejectConfirm(){
		var rejectReason = document.getElementById("rejectReason").value;
		var aprvNo = "${approval.aprvNo}";
		
		if(rejectReason == ''){
			Swal.fire({
				icon: 'warning',
				text: '반려사유를 입력하세요.'
			})
			return;
		}
		// AJAX 요청을 사용하여 서버로 사유를 전송
		$.ajax({
		    type: "POST",
		    url: "/yeyebooks/approval/rejectApproval",
		    data: {
		      aprvNo: aprvNo,
		      rejectReason: rejectReason
		    },
		    success: function() {
		      $('#modalCenter').modal('hide');
		      Swal.fire({
					icon: 'success',
					title: '성공',
					text: '반려처리 되었습니다.'
				}).then(function(){
					location.href="approvalList";
				})
		    },
		    error: function(error) {
		    	Swal.fire({
					icon: 'error',
					title: '실패',
					text: '오류가 발생하였습니다.'
				})
		    }
		  });
	}
</script>
<script>
</script>

<body>


<!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
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
					
		            <!-- Dashboard -->
		            <li class="menu-item active">
		              <a href="/yeyebooks/approval/approvalList?status=0" data-title="내 문서함" class="menu-link">
		                <i class="menu-icon tf-icons bx bx-layout"></i>
		                <div data-i18n="Analytics">내 문서함</div>
		              </a>
		            </li>
		            <li class="menu-item">
		              <a href="/yeyebooks/approval/addApproval" data-title="문서작성" class="menu-link">
		                <i class='menu-icon tf-icons bx bxl-telegram'></i>
		                <div data-i18n="Analytics">문서작성</div>
		              </a>
		            </li>
		        </ul>
	        </aside>
	        <!-- / Menu -->
			
			<!-- 입력 레이아웃 -->
			<div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
		            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
            			<div class="card">
							<!-- Basic Layout -->
							<div class="row">
								<div class="col-xl">
									<div class="card-header">
										<h2 class="mb-0"><strong>문&nbsp;서&nbsp;상&nbsp;세</strong></h2>
									</div>
									<!-- 구분선 -->
									<hr class="m-0">
      						    	<div class="card-body">
					                    <form action="${pageContext.request.contextPath}/addVacation" method="post" enctype="multipart/form-data">
					                    	 <!-- 선택된 결재자 정보를 저장할 hidden 필드 -->
										    <input type="hidden" name="approvalLine" value="">
											<input type="hidden" name="approvalLine" value="">
											<input type="hidden" name="approvalLine" value="">
					                    	
					                    	<!-- 문서 상단 -->
					                    	<div class="row" style="margin-bottom: 5px;">
					                    		<!-- 기안자 정보 -->
					                    		<div class="col-md-4">
					                    			<table class="table table-sm table-bordered infoTh">
			                    						<tbody>
			                    							<tr>
			                    								<th>기안자</th>
			                    								<td>${approval.userName}</td>
			                    							</tr>
			                    							<tr>
			                    								<th>기안일</th>
			                    								<td>
			                    									${approval.CDate}
			                    								</td>
			                    							</tr>
			                    							<tr>
			                    								<th>문서번호</th>
			                    								<td>${approval.aprvNo}</td>
			                    							</tr>
			                    							<tr>
			                    								<th>문서종류</th>
			                    								<td>
															        ${approval.codeName}
			                    								</td>
			                    							</tr>
			                    						</tbody>
			                    					</table>
					                    		</div>
					                    		
					                    		<div class="col-md-3">&nbsp;</div>
					                    		
					                    		<!-- 결재선 -->
					                    		<div class="col-md-5 table-bordered">
					                    			<!-- 결재 -->
					                    			<div class="row mb-1">
					                    				<label class="col-sm-1" 
					                    						style="font-weight: bolder; 
					                    								display: flex;
																        justify-content: center;
																        align-items: center;
																        border: 1px solid #d9dee3;">결재
														</label>
					                    				<div class="col-sm-11">
					                    					<!-- 선택된 결재자 정보를 표시할 HTML 요소 -->
															<div id="selectedApprovers">
																<c:forEach var="al" items="${aprvLine}">
																	<p>
																		<span>${al.userInfo}</span>
																		<c:set var="signUrl" value=""></c:set>
																		<c:if test="${al.userSign != null }">
																			<c:set var="signUrl" value="/yeyebooks/${al.userSign }"></c:set>
																		</c:if>
																			<c:if test="${al.aprvStat == '결재완료' }">
																				<img src="${signUrl}" width="100px">
																			</c:if>
																		<c:if test="${al.userId == approvalUser }">
																			<input type="hidden" id="approvalUserSign" value="${signUrl}">
																		</c:if>
																	</p>
																</c:forEach>
															</div>
								                        </div>
					                    			</div>
					                    			<!-- 참조 -->
					                    			<div class="row">
					                    				<label class="col-sm-1" 
					                    						style="font-weight: bolder; 
					                    								display: flex;
																        justify-content: center;
																        align-items: center;
																        border: 1px solid #d9dee3;">참조
														</label>
												        <div class="col-sm-11">
												        	<div class="table table-bordered">
													        	${approval.reference}
												        		
												        	</div>
												        </div>
					                    			</div>
					                    		</div>
					                    	</div>
					                    	
											<!-- 신청양식 -->
											<c:if test="${approval.docCatCd == '03' }">
											<div id="03" style=" margin-top: 20px;">
								    			<table class="table table-sm table-bordered">
												<tbody style="text-align: center;">
													<tr>
														<th colspan="4">
															<h2>일&nbsp;&nbsp;반&nbsp;&nbsp;문&nbsp;&nbsp;서</h2>
														</th>
													</tr>
													<tr>
														<th>제목</th>
														<td colspan="3">
								                        	${approval.aprvTitle}
														</td>
													</tr>
													<tr>
														<th>내용</th>
														<td colspan="3">
								                        	${approval.aprvContents}
														</td>
													</tr>
												</tbody>
											</table>
											</div>
											</c:if>
											<br>
											<c:if test="${approval.docCatCd == '01' }">
											<!-- 지출결의서 -->
											<div id="01" style=" margin: 20px 0;">
											<table class="table table-sm table-bordered">
												<tbody style="text-align: center;">
													<tr>
														<th colspan="4">
															<h2>지&nbsp;&nbsp;출&nbsp;&nbsp;내&nbsp;&nbsp;역</h2>
														</th>
													</tr>
													<tr>
														<th>제목</th>
														<td colspan="3">
								                        	${approval.aprvTitle}
														</td>
													</tr>
													<tr>
														<th>지출내용</th>
														<td colspan="3">
								                        	${approval.aprvContents}
														</td>
													</tr>
													<tr>
														<th>사용내역</th>
														<td colspan="3">
				   											${account.acntContents}<br>
														</td>
													</tr>
													<tr>
														<th>지출날짜</th>
														<td>
															${account.acntYmd}
														</td>
													
														<th>사용처</th>
														<td>${account.acntNm}</td>
														
														
													</tr>
													<tr>
														<th>지출금액</th>
														<td>${account.acntAmount}</td>
														<th>구분</th>
														<td>${account.acntCreditCd}</td>
													</tr>
												</tbody>
											</table>
											</div>
											</c:if>
											
											<c:if test="${approval.docCatCd == '02' }">
											<div id="02" style=" margin: 20px 0;">
											<br>
											
											<!-- 휴가 정보 -->
											<table class="table table-sm table-bordered">
												<tbody style="text-align: center;">
												<tr>
														<th colspan="4">
															<h2>휴&nbsp;&nbsp;가&nbsp;&nbsp;신&nbsp;&nbsp;청</h2>
														</th>
													</tr>
						                        	<!-- 휴가 종류 선택 -->
													<tr>
														<th class="vacationInfo">휴가 종류</th>
														<td colspan="3">
								                        	${dayoff.dayoffTypeCd}
														</td>
													</tr>
													<!-- 휴가 종류에 따른 기간 선택 폼 선택 -->
													<tr>
														<th class="vacationInfo">휴가 기간</th>
														<td id="dayoffDate">
															<div style="display: flex; justify-content: center;">
																${dayoff.dayoffYmd}
															</div>
														</td>
														<td id="dayoffDate2" style="display: none;">
															<div class="row" style="display: flex; justify-content: center;">
																<input class="form-control form-control-sm" type="date" id="dayoffInput2" name="dayoffYmd" style="width: 40%;" disabled required="required">
																&nbsp;-&nbsp;
																<input class="form-control form-control-sm" type="date" id="dayoffInput3" name="dayoffYmd" style="width: 40%;" disabled required="required">
															</div>
														</td>
													</tr>
													<tr>
														<th class="vacationInfo">휴가 사유</th>
														<td colspan="3">
															${approval.aprvContents}
														</td>
													</tr>
												</tbody>
											</table>
											</div>
											</c:if>
											
	               							  		<c:forEach var="af" items="${aprvFile}">
														<a
															href="../approvalFile/${af.saveFilename}"
															download="${af.orginFilename}">
															${af.orginFilename}
														</a>
												</c:forEach>
										</form>
										
										<c:if test="${sessionScope.userId == approvalUser && approval.aprvStatCd == '01'}">
									        <button class="btn btn-primary" type="button" onclick="approve()">승인</button>
									        <button class="btn btn-primary" type="button" onclick="openRejectionModal()">반려</button>
									   	</c:if>
										<!-- 반려 모달 창 -->
										
										<c:if test="${sessionScope.userId == approval.userId && approval.aprvStatCd != '04'}">
										    <button class="btn btn-primary" type="button" onclick="location.href='cancelApproval?aprvNo=${approval.aprvNo}'">회수</button>
										</c:if>
										<div>
											<c:if test="${approval.aprvStatCd == '03' }">
												반려사유 : ${approval.rjctReason}
											</c:if>
										</div>
										
										<div class="mt-3">
									        <!-- Modal -->
									        <div class="modal fade" id="modalCenter" tabindex="-1" aria-hidden="true">
									          <div class="modal-dialog modal-dialog-centered" role="document">
									            <div class="modal-content">
									              <div class="modal-header">
									                <h5 class="modal-title" id="modalCenterTitle">반려</h5>
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
									                    <label for="rejectReason" class="form-label">반려사유</label>
									                    <input
									                      type="text"
									                      id="rejectReason"
									                      class="form-control"
									                    />
									                  </div>
									                </div>
									              </div>
									              <div class="modal-footer">
									                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
									                  닫기
									                </button>
									                <button type="button" class="btn btn-primary" onclick="rejectConfirm()">반려</button>
									              </div>
									            </div>
									          </div>
									        </div>
									      </div>
										<!-- 문서 끝 -->
										<br>
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
   	   <!-- / Layout page -->
	</div>
	<!-- / Layout wrapper -->



<!--------------------------------------------------------------------------------->
   

        


	<!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="../assets/vendor/libs/jquery/jquery.js"></script>
    <script src="../assets/vendor/libs/popper/popper.js"></script>
    <script src="../assets/vendor/js/bootstrap.js"></script>
    <script src="../assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="../assets/vendor/js/menu.js"></script>
    <!-- endbuild -->

    <!-- Vendors JS -->

    <!-- Main JS -->
    <script src="../assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="../assets/js/ui-modals.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
</body>
</html>