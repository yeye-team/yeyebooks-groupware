<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approvalOne</title>
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
					<li class="menu-item active" onclick="location.href='${pageContext.request.contextPath}/addVacation'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							문서작성
						</button>
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
										<h2 class="mb-0"><strong>문&nbsp;서&nbsp;작&nbsp;성</strong></h2>
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
											<div id="03" style="margin-top: 20px;">
								    			<!-- 제목 입력 -->
								                <div class="mb-3">
									                <input maxlength="50" class="form-control" id="basic-default-company" readonly="readonly" value="${approval.aprvTitle}"/>
								                </div>
								                <!-- 내용 입력 -->
												<div class="mb-1">
													<!-- 네이버 에디터 -->
													<textarea 
															  class="form-control"
															  style="
															  	height: 380px;
															  	width: 100%"
															  	readonly="readonly"
								                         	  >${approval.aprvContents}</textarea>
													
											  	</div>
											</div>
											<br>
											
											<!-- 지출결의서 -->
											<div id="01" style="display: none; margin: 20px 0;">
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
								                        	<input type="text" name="aprvTitle" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>
														</td>
													</tr>
													<tr>
														<th>지출내용</th>
														<td colspan="3">
								                        	<textarea name="aprvContents" class="form-control" id="basic-default-company" placeholder="내용을 입력하세요" required="required"></textarea>
														</td>
													</tr>
													<tr>
														<th>사용내역</th>
														<td colspan="3">
				   											<textarea id="acntContents" name="acntContents" class="form-control" id="basic-default-company" placeholder="내용을 입력하세요" required="required"></textarea><br>
														</td>
													</tr>
													<tr>
														<th>지출날짜</th>
														<td>
															<div style="display: flex; justify-content: center;">
																<input type="date" id="acntYmd" name="acntYmd" class="form-control form-control-sm">
															</div>
														</td>
													
														<th>사용처</th>
														<td><input type="text" id="acntNm" name="acntNm" class="form-control form-control-sm"></td>
														
														
													</tr>
													<tr>
														<th>지출금액</th>
														<td><input type="number" id="acntAmount" name="acntAmount" value=0 class="form-control form-control-sm"></td>
														<th>구분</th>
														<td colspan="3">
															<select id="acntCreditCd" name="acntCreditCd" class="form-select">
													            <option value="01">법인</option>
													            <option value="02">개인</option>
													        </select>
														</td>
													</tr>
												</tbody>
											</table>
											</div>
											
	               							  		<c:forEach var="af" items="${aprvFile}">
														<a
															href="../approvalFile/${af.saveFilename}"
															download="${af.orginFilename}">
															${af.orginFilename}
														</a>
												</c:forEach>
										</form>
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