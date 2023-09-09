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
	<title>휴가 신청</title>
	
    <jsp:include page="inc/head.jsp"></jsp:include>
    <script>
		$(document).ready(function() {
			$('.dayoffCd01').click(function(){
				$('#dayoffDate').show();
				$('#dayoffDate2').hide();
				
				$('#dayoffInput1').prop('disabled', false);
				$('#dayoffInput2').prop('disabled', true);
				$('#dayoffInput3').prop('disabled', true);
			});
			
			$('#dayoffCd03').click(function(){
				$('#dayoffDate').hide();
				$('#dayoffDate2').show();
				
				$('#dayoffInput1').prop('disabled', true);
				$('#dayoffInput2').prop('disabled', false);
				$('#dayoffInput3').prop('disabled', false);
			});
			
			// 연차 선택시 입력값 기본설정
			document.getElementById("dayoffInput2").addEventListener("change", function() {
			    // dayoffInput2의 값을 가져옴
			    var selectedDate = this.value;

			    // dayoffInput3에 선택된 날짜를 설정
			    document.getElementById("dayoffInput3").value = selectedDate;
			});
		});
    </script>
    
    
    
    <style>
    	.menu-link{
    		background-color: white;
	    	border: none;
	    	width: 88%;
    	}
    	
    	h2{
    		text-align: center;
    	}
    	.infoTh th {
    		font-weight: bolder;
    		text-align: center;
    		width: 20%;
    	}
    	.infoTh td {
    		width: 50%;
    	}
    	.aprvTh th {
    		font-weight: bolder;
    		text-align: center;
    	}
    	.aprvTd {
    		height: 40px;
    		text-align: center;
    	}
    	input::placeholder {
	        text-align: center;
	    }
	    .form-control[readonly]{
	    	background-color: white;
	    	height: 50px;
	    }
	</style>    	
</head>
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
					<li class="menu-item" onclick="location.href='${pageContext.request.contextPath}/userInformation'">
		            	<button class="menu-link">
							<i class="menu-icon tf-icons bx bx-group"></i>
		                	인사정보
						</button>
		            </li>
					<li class="menu-item" onclick="location.href='${pageContext.request.contextPath}/vacationList'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청 내역
						</button>
					</li>
					<li class="menu-item active" onclick="location.href='${pageContext.request.contextPath}/addVacation'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청
						</button>
					</li>
				</ul>
	        </aside>
	        <!-- / Menu -->
			
			<!-- 입력 레이아웃 -->
			<div class="layout-page">
	        	<jsp:include page="inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
		            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
            			<div class="card">
							<!-- Basic Layout -->
							<div class="row">
								<div class="col-xl">
									<div class="card-header">
										<h2 class="mb-0"><strong>휴&nbsp;가&nbsp;신&nbsp;청</strong></h2>
									</div>
									<!-- 구분선 -->
									<hr class="m-0">
      						    	<div class="card-body">
					                    <form action="${pageContext.request.contextPath}/addVacation" method="post" enctype="multipart/form-data">
					                    	<!-- 문서 상단 -->
					                    	<div class="row" style="margin-bottom: 5px;">
					                    		<!-- 기안자 정보 -->
					                    		<div class="col-md-4">
					                    			<table class="table table-sm table-bordered infoTh">
			                    						<tbody>
			                    							<tr>
			                    								<th>기안자</th>
			                    								<td>${aprvInfo.userNm}</td>
			                    							</tr>
			                    							<tr>
			                    								<th>기안부서</th>
			                    								<td>인사팀</td>
			                    							</tr>
			                    							<tr>
			                    								<th>기안일</th>
			                    								<td>
			                    									<a id="aprvYmd">${today}</a>
			                    								</td>
			                    							</tr>
			                    							<tr>
			                    								<th>문서번호</th>
			                    								<td>&nbsp;</td>
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
					                    					<table class="table table-bordered aprvTh">
					                    						<thead>
					                    							<tr>
					                    								<c:forEach items="${aprvLine}" var="line" varStatus="loop">
						                    								<th>
						                    									<a id="aprvSequence${loop.index+1}">
						                    										${line.codeNm}
					                    										</a>
						                    								</th>
					                    								</c:forEach>
					                    							</tr>
					                    						</thead>
					                    						<tbody class="aprvTd">
					                    							<tr>
					                    								<c:forEach items="${aprvLine}" var="lineNm">
				                    										<input type="hidden" name="lineUserId" value="${lineNm.userId}">
						                    								<td>${lineNm.userNm}</td>
					                    								</c:forEach>
					                    							</tr>
					                    						</tbody>
					                    					</table>
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
													        	<input 
													        		class="form-control" 
													        		type="text" 
													        		name="reference" 
													        		placeholder="참조를 선택하세요" 
													        		readonly="readonly" 
													        		value="<c:forEach items="${referList}" var="item">${item.userNm} ${item.codeNm} </c:forEach>" 
										        				 />
												        	</div>
												        </div>
					                    			</div>
					                    		</div>
					                    	</div>
					                    	
											<!-- 신청양식 -->
											<!-- 신청인 정보 -->
											<table class="table table-sm table-bordered">
												<thead>
													<tr>
														<th style="font-size: 14px; text-align: center;">신청인</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>
															<table class="table table-sm table-bordered infoTh">
																<tr>
																	<th>소속</th>
																	<td>${aprvInfo.deptNm}</td>
																</tr>
																<tr>
																	<th>직책</th>
																	<td>${aprvInfo.rankNm}</td>
																</tr>
																<tr>
																	<th>성명</th>
																	<td>${aprvInfo.userNm}</td>
																</tr>
															</table>
														</td>
													</tr>
												</tbody>
											</table>
											<br>
											
											<!-- 휴가 정보 -->
											<table class="table table-sm table-bordered">
												<tbody style="text-align: center;">
						                        	<!-- 휴가 종류 선택 -->
													<tr>
														<th class="vacationInfo">휴가 종류</th>
														<td colspan="3">
								                        	<input
									                              name="dayoffTypeCd"
									                              class="form-check-input dayoffCd01"
									                              type="radio"
									                              value="01"
									                              checked="checked"
									                        > 오전반차 &nbsp;&nbsp;
								                        	<input
									                              name="dayoffTypeCd"
									                              class="form-check-input dayoffCd01"
									                              type="radio"
									                              value="02"
									                        > 오후반차 &nbsp;&nbsp;
								                        	<input
									                              name="dayoffTypeCd"
									                              class="form-check-input"
									                              type="radio"
									                              value="03"
									                              id="dayoffCd03"
									                        > 연차
														</td>
													</tr>
													<!-- 휴가 종류에 따른 기간 선택 폼 선택 -->
													<tr>
														<th class="vacationInfo">휴가 기간</th>
														<td id="dayoffDate">
															<div style="display: flex; justify-content: center;">
																<input class="form-control form-control-sm" type="date" id="dayoffInput1" name="dayoffYmd" style="width: 60%" required="required">
															</div>
														</td>
														<td id="dayoffDate2" style="display: none;">
															<div class="row" style="display: flex; justify-content: center;">
																<input class="form-control form-control-sm" type="date" id="dayoffInput2" name="dayoffYmd" style="width: 40%;" disabled required="required">
																&nbsp;-&nbsp;
																<input class="form-control form-control-sm" type="date" id="dayoffInput3" name="dayoffYmd" style="width: 40%;" disabled required="required">
															</div>
														</td>
														<th class="vacationInfo">잔여연차</th>
														<td>${aprvInfo.dayoffCnt}</td>
													</tr>
													<tr>
														<th class="vacationInfo">휴가 사유</th>
														<td colspan="3">
															<input class="form-control form-control-sm" type="text" name="aprvContents" placeholder="사유를 입력하세요" required="required">
														</td>
													</tr>
												</tbody>
											</table>
											
               							  	<!-- 첨부 파일 -->
							                <div class="mb-1" style="margin-top: 10px;">
							                	<div id="files">
							                		<input class="form-control boardFiles" type="file" name="multipartFile"><br>
							                	</div>
							                </div>
							                <div>
												<button type="submit" class="btn btn-primary" style="float: right;" id="submitBtn">신청</button>
						                	</div>
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
</body>
</html>