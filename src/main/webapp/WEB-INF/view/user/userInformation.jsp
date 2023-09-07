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
	<title>인사정보</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<style>
		.menu-link{
    		background-color: white;
	    	border: none;
	    	width: 88%;
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
	            <!-- 인사정보 -->
	            <li class="menu-item active" onclick="location.href='${pageContext.request.contextPath}/userInformation'">
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
				<li class="menu-item" onclick="location.href='${pageContext.request.contextPath}/addVacation'">
					<button class="menu-link">
						<i class='menu-icon tf-icons bx bxl-telegram'></i>
						휴가 신청
					</button>
				</li>
          	</ul>
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
						<div class="col-md-8">
							<h4 class="card-header"><strong>인사정보</strong></h4>
						</div>
						<div class="col-md-4" style="align-items: center">
						</div>
					</div>
				  	<hr class="m-0" />
				  	<div class="card-body">
                      	<div class="mt-3">
                        	<div class="row row-bordered">
                          		<div class="col-md-3 col-12 mb-3 mb-md-0">
                            		<div class="list-group">
			                           	<div
			                               class="list-group-item list-group-item-action active"
			                               data-bs-toggle="list"
			                               href="#list-home"
			                               >YeYeBooks
		                                 </div
		                                > 
			                            <c:forEach var="d" items="${deptList}">
				                           	<div
				                               class="list-group-item list-group-item-action"
				                               data-bs-toggle="list"
				                               href="#list-${d.deptCd}"
				                               ><span class="deptNm">${d.deptNm}</span>
				                               <input class="deptCd" type="hidden" value="${d.deptCd}">
				                               </div>
			                            </c:forEach>
                            		</div>
                          		</div>
                          		<div class="col-md-9 col-12">
                            		<div class="card overflow-hidden" style="height: 540px; box-shadow: none;">
						                    <div class="card-body" id="vertical-example">
					                    		<div class="tab-content p-0">
						                        	<div class="tab-pane fade show active" id="list-home">
						                            	<div class="row">
						                            	 <c:forEach var="uc" items="${userCnt}">
							                              	<c:if test="${uc.deptNm == null}">
							                              		<h6>YeYeBooks (${uc.cnt})	
							                              		</h6>
							                              	</c:if>
							                              	<c:if test="${uc.deptNm != null}">
							                              		<h6>${uc.deptNm} (${uc.cnt})
							                              		</h6>
							                              	</c:if>  
								                            	  <c:forEach var="u" items="${userList}">
								                            	  	<c:if test="${uc.deptCd == u.deptCd}">
								                            	  		<div class="col-md-6 mb-5 row">
										                              		<div class="col-md-3">
										                              			<c:set var="photoUrl" value="${pageContext.request.contextPath}/assets/img/avatars/default.png"></c:set>
																			    <c:if test="${u.userImg != null}">
																			    	<c:set var="photoUrl" value="/yeyebooks/${u.userImg}"></c:set>
																			    </c:if>
																			    <img src="${photoUrl}" alt="Avatar" class="rounded-circle" width="100%" />
										                              		</div>
										                              		<div class="col-md-9">
										                              			<h5 class="mb-0">${u.userNm}</h5>
										                              			<h6><small class="text-muted">${u.rankNm}<br>${u.phoneNo}<br>${u.mail}</small></h6>
										                              		</div>
											                            </div>
								                            	  	</c:if> 
								                            	  </c:forEach>
							                              </c:forEach>
						                              	</div>         
						                              </div>
						                              <c:forEach var="uc" items="${userCnt}">
						                              	<div class="tab-pane fade" id="list-${uc.deptCd}">
						                              		<h6>${uc.deptNm}(${uc.cnt}) 
						                              		</h6>
						                               		<div class="row">
							                            	  <c:forEach var="u" items="${userList}">
							                            	  	<c:if test="${uc.deptCd == u.deptCd}">
							                            	  		<div class="col-md-6 mb-5 row">
									                              		<div class="col-md-3">
									                              			<c:set var="photoUrl" value="${pageContext.request.contextPath}/assets/img/avatars/default.png"></c:set>
																			    <c:if test="${u.userImg != null}">
																			    	<c:set var="photoUrl" value="/yeyebooks/${u.userImg}"></c:set>
																			    </c:if>
																			    <img src="${photoUrl}" alt="Avatar" class="rounded-circle" width="100%" />
									                              		</div>
									                              		<div class="col-md-9">
									                              			<h5 class="mb-0">${u.userNm}</h5>
										                              		<h6><small class="text-muted">${u.rankNm}<br>${u.phoneNo}<br>${u.mail}</small></h6>
									                              		</div>
										                            </div>
							                            	  	</c:if> 
							                            	  </c:forEach>
							                              	</div>
						                                </div>
						                              </c:forEach>
						                            </div>
                    							</div>
                  							</div>
                          				</div>
                        			</div>
                      			</div>
                			</div>
			            </div>
			            <!--/ Supported content -->
		            </div>
		            <!-- / Content -->
					<jsp:include page="../inc/footer.jsp"></jsp:include>

            		<div class="content-backdrop fade"></div>
          		</div>
				<!-- Content wrapper -->
			</div>
        	<!-- / Layout page -->
		</div>
    </div>
	<!-- Overlay -->
	<div class="layout-overlay layout-menu-toggle"></div>
  
	<jsp:include page="../inc/coreJs.jsp"></jsp:include>
</body>
</html>