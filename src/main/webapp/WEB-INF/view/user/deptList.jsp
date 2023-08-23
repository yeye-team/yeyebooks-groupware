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
	<title>부서관리</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<script>
		$(document).ready(function(){
			$('#addDeptBtn').on('click',function(){
				$.ajax({
					async : false, 
					url : 'rest/deptList',
					type : 'get',
					success : function(model) {
						var d = 0;
						$(model).each(function(index, item){
							if(item.deptNm == $('#addDeptNm').val()){
								d = 1;
								return false;
							}
						});
						if(d == 1) {
							Swal.fire({
			                    icon: 'warning',
			                    title: '중복된 부서명 입니다.'
			                });
							
						} else if(d == 0){
							$('#addDeptForm').submit();	
						}
					}
				});
			});
			
			var mdBtn = $('.modifyDeptBtn');
			mdBtn.on('click',function(){
				var indexNo = mdBtn.index(this);
				var mdForm = $('.modifyDeptForm').get(indexNo);
				var mdNm = $('.modifyDeptNm').get(indexNo);
				$.ajax({
					async : false, 
					url : 'rest/deptList',
					type : 'get',
					success : function(model) {
						var d = 0;
						$(model).each(function(index, item){
							if(item.deptNm == $(mdNm).val()){
								d = 1;
								return false;
							}
						});
						if(d == 1) {
							Swal.fire({
			                    icon: 'warning',
			                    title: '중복된 부서명 입니다.'
			                });
							
						} else if(d == 0){
							$(mdForm).submit()	
						}
					}
				});
			});
		});
	</script>
</head>
<body>
	<!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
		<div class="layout-container">
		<!-- Menu -->
		<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
			<div class="app-brand demo">
				<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png" style="width:100%">
			</div>

			<div class="menu-inner-shadow"></div>
			
			<ul class="menu-inner py-1">
	            <!-- 부서관리 -->
	            <li class="menu-item active">
	              <a href="${pageContext.request.contextPath}/deptList" class="menu-link">
	                <i class="menu-icon tf-icons bx bx-group"></i>
	                부서관리
	              </a>
	            </li>

	            <!-- 사용자관리 -->
	            <li class="menu-item">
					<a href="${pageContext.request.contextPath}/userList" class="menu-link">
					  <i class="menu-icon tf-icons bx bx-user"></i>
					  사용자관리
					</a>
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
							<h4 class="card-header"><strong>부서관리</strong></h4>
						</div>
						<div class="col-md-4" style="align-items: center">
							<button type="button" class="btn btn-secondary m-3" data-bs-toggle="modal" data-bs-target="#modalAddDept" style="float: right">부서생성</button>
							<!-- Modal -->
	                        <div class="modal fade" id="modalAddDept" tabindex="-1" aria-hidden="true">
	                          <div class="modal-dialog modal-dialog-centered" role="document">
	                            <div class="modal-content">
	                              <div class="modal-header">
	                                <h5 class="modal-title" id="modalAddDeptTitle">부서생성</h5>
	                                <button
	                                  type="button"
	                                  class="btn-close"
	                                  data-bs-dismiss="modal"
	                                  aria-label="Close"
	                                ></button>
	                              </div>
	                              <form action="${pageContext.request.contextPath}/addDept" method="post" id="addDeptForm">
		                              <div class="modal-body pb-0">
		                                <div class="row">
		                                  <div class="col mb-3">
		                                    <label for="addDeptNm" class="form-label">부서명</label>
		                                    <input
		                                      type="text"
		                                      id="addDeptNm"
		                                      name="deptNm"
		                                      class="form-control"
		                                      placeholder="부서명을 입력하세요"
		                                      required="required"
		                                    />
		                                  </div>
		                                </div>
		                              </div>
		                              <div class="modal-footer">
		                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
		                                  취소
		                                </button>
		                                <button type="button" class="btn btn-secondary" id="addDeptBtn">생성</button>
		                              </div>
	                              </form>
	                            </div>
	                          </div>
	                        </div>
						</div>
					</div>
				  	<hr class="m-0" />
				  	<div class="card-body">
                      	<div class="mt-3">
                        	<div class="row">
                          		<div class="col-md-3 col-12 mb-3 mb-md-0">
                            		<div class="list-group">
			                           	<div
			                               class="list-group-item list-group-item-action active"
			                               id="list-home-list"
			                               data-bs-toggle="list"
			                               href="#list-home"
			                               >YeYeBooks
		                                 </div
		                                > 
			                            <c:forEach var="d" items="${deptList}">
				                           	<div
				                               class="list-group-item list-group-item-action"
				                               id="list-${d.deptCd}-list"
				                               data-bs-toggle="list"
				                               href="#list-${d.deptCd}"
				                               >${d.deptNm}
				                               <span class="dropdown" style="float: right">
					                              <a
					                                class="p-0"
					                                type="button"
					                                id="cardOpt3"
					                                data-bs-toggle="dropdown"
					                                aria-haspopup="true"
					                                aria-expanded="false"
					                              >
					                                &nbsp;<i class="bx bx-dots-vertical-rounded"></i>&nbsp;
					                              </a>
					                              <span class="dropdown-menu dropdown-menu-end" aria-labelledby="cardOpt3">
					                                <button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalModify${d.deptCd}">수정</button>
					                                <c:if test="${d.cnt == 0}">
					                                	<a class="dropdown-item" href="${pageContext.request.contextPath}/removeDept?deptCd=${d.deptCd}">삭제</a>
					                                </c:if>
					                              </span>
						                        </span> 
				                               </div>
			                            </c:forEach>
                            		</div>
                            		<c:forEach var="d" items="${deptList}">
	                         		<!-- Modal -->
			                        <div class="modal fade" id="modalModify${d.deptCd}" tabindex="-1" aria-hidden="true">
			                          <div class="modal-dialog modal-dialog-centered" role="document">
			                            <div class="modal-content">
			                              <div class="modal-header">
			                                <h5 class="modal-title" id="modalmodifyDeptTitle">부서변경</h5>
			                                <button
			                                  type="button"
			                                  class="btn-close"
			                                  data-bs-dismiss="modal"
			                                  aria-label="Close"
			                                ></button>
			                              </div>
			                              <form action="${pageContext.request.contextPath}/modifyDept" method="post" class="modifyDeptForm">
				                              <div class="modal-body pb-0">
				                                <div class="row">
				                                  <div class="col mb-3">
				                                    <label for="modifyDeptNm" class="form-label">부서명</label>
				                                    <input type="hidden" name="deptCd" value="${d.deptCd}">
				                                    <input
				                                      type="text"
				                                      name="deptNm"
				                                      class="form-control modifyDeptNm"
				                                      placeholder="부서명을 입력하세요"
				                                      value="${d.deptNm}"
				                                      required="required"
				                                    />
				                                  </div>
				                                </div>
				                              </div>
				                              <div class="modal-footer">
				                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
				                                  취소
				                                </button>
				                                <button type="button" class="btn btn-secondary modifyDeptBtn">변경</button>
				                              </div>
			                              </form>
			                            </div>
			                          </div>
			                        </div>
			                        </c:forEach>
                          		</div>
                          		<div class="col-md-9 col-12">
                            		<div class="card overflow-hidden" style="height: 540px; box-shadow: none;">
						                    <div class="card-body" id="vertical-example">
					                    		<div class="tab-content p-0">
						                        	<div class="tab-pane fade show active" id="list-home">
						                            	<div class="row">
						                            	 <c:forEach var="uc" items="${userCnt}">
							                              	<c:if test="${uc.deptNm == null}">
							                              		<h6>YeYeBooks (${uc.cnt}) <i class='bx bx-user-minus' data-bs-toggle="modal" data-bs-target="#addUserToDept"></i></h6>
							                              	</c:if>
							                              	<c:if test="${uc.deptNm != null}">
							                              		<h6>${uc.deptNm} (${uc.cnt}) <i class='bx bx-user-plus' data-bs-toggle="modal" data-bs-target="#addUserToDept${uc.deptCd}"></i></h6>
							                              	</c:if>  
								                            	  <c:forEach var="u" items="${userList}">
								                            	  	<c:if test="${uc.deptCd == u.deptCd}">
								                            	  		<div class="col-md-6 mb-5 row">
										                              		<div class="col-md-3">
										                              			<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
										                              		</div>
										                              		<div class="col-md-9">
										                              			<h5 class="mb-0">${u.userNm}</h5>
										                              			<h6><small class="text-muted">${u.rankNm}</small></h6>
										                              		</div>
											                            </div>
								                            	  	</c:if> 
								                            	  </c:forEach>
							                              </c:forEach>
						                              	</div>         
						                              </div>
						                              <c:forEach var="uc" items="${userCnt}">
						                              	<div class="tab-pane fade" id="list-${uc.deptCd}">
						                              		<h6>${uc.deptNm}(${uc.cnt}) <i class='bx bx-user-plus' data-bs-toggle="modal" data-bs-target="#addUserToDept${uc.deptCd}"></i></h6>
						                               		<div class="row">
							                            	  <c:forEach var="u" items="${userList}">
							                            	  	<c:if test="${uc.deptCd == u.deptCd}">
							                            	  		<div class="col-md-6 mb-5 row">
									                              		<div class="col-md-3">
									                              			<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
									                              		</div>
									                              		<div class="col-md-9">
									                              			<h5 class="mb-0">${u.userNm}</h5>
										                              		<h6><small class="text-muted">${u.rankNm}</small></h6>
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
                  							<!-- Modal -->
					                        <div class="modal fade" id="addUserToDept" tabindex="-1" aria-hidden="true">
					                          <div class="modal-dialog modal-dialog-centered" role="document">
					                            <div class="modal-content">
					                              <div class="modal-header">
					                              	<h5 class="modal-title">부서에서 사용자 제외</h5>
					                                <button
					                                  type="button"
					                                  class="btn-close"
					                                  data-bs-dismiss="modal"
					                                  aria-label="Close"
					                                ></button>
					                              </div>
					                              <form action="${pageContext.request.contextPath}/modifyUserDept" method="post">
						                              <div class="modal-body pb-0 card overflow-hidden" style="height: 500px; box-shadow: none;">
						                                <div class="row card-body vertical-scroll">
						                                  <c:forEach var="uc" items="${userCnt}">
							                              	<c:if test="${uc.deptNm == null}">
							                              		<h6>YeYeBooks (${uc.cnt})</h6>
							                              	</c:if>
							                              	<c:if test="${uc.deptNm != null}">
							                              		<h6>${uc.deptNm} (${uc.cnt})</h6>
							                              	</c:if>  
								                            	  <c:forEach var="u" items="${userList}">
								                            	  	<c:if test="${uc.deptCd == u.deptCd}">
								                            	  		<div class="col-md-6 mb-5 row">
										                              		<div class="col-md-3">
										                              			<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
										                              		</div>
										                              		<div class="col-md-9">
										                              			<div class="row">
										                              				<div class="col">
										                              					<h5 class="mb-0">${u.userNm}</h5>
										                              					<h6><small class="text-muted">${u.rankNm}</small></h6>
										                              				</div>
										                              				<div class="col">
										                              					<input class="form-check-input" type="checkbox" value="${u.userId}" name="userId"/>
										                              				</div>
										                              			</div>
										                              		</div>
											                            </div>
								                            	  	</c:if> 
								                            	  </c:forEach>
							                              </c:forEach>
						                                </div>
						                              </div>
						                              <div class="modal-footer">
						                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
						                                  취소
						                                </button>
						                                <button type="submit" class="btn btn-secondary">추가</button>
						                              </div>
					                              </form>
					                            </div>
					                          </div>
					                        </div>
					                        
                  							<c:forEach var="d" items="${deptList}">
			                         		<!-- Modal -->
					                        <div class="modal fade" id="addUserToDept${d.deptCd}" tabindex="-1" aria-hidden="true">
					                          <div class="modal-dialog modal-dialog-centered" role="document">
					                            <div class="modal-content">
					                              <div class="modal-header">
					                              	<h5 class="modal-title">${d.deptNm}에 사용자 추가</h5>
					                                <button
					                                  type="button"
					                                  class="btn-close"
					                                  data-bs-dismiss="modal"
					                                  aria-label="Close"
					                                ></button>
					                              </div>
					                              <form action="${pageContext.request.contextPath}/modifyUserDept" method="post">
						                              <div class="modal-body pb-0 card overflow-hidden" style="height: 500px; box-shadow: none;">
						                                <div class="row card-body vertical-scroll">
						                              	<c:if test="${d.deptNm != null}">
						                              		<input type="hidden" value="${d.deptCd}" name="deptCd"/>
						                              	</c:if>
						                                  <c:forEach var="uc" items="${userCnt}">
							                              	<c:if test="${uc.deptNm == null}">
							                              		<h6>YeYeBooks (${uc.cnt})</h6>
							                              	</c:if>
							                              	<c:if test="${uc.deptNm != null}">
							                              		<h6>${uc.deptNm} (${uc.cnt})</h6>
							                              	</c:if>  
								                            	  <c:forEach var="u" items="${userList}">
								                            	  	<c:if test="${uc.deptCd == u.deptCd}">
								                            	  		<div class="col-md-6 mb-5 row">
										                              		<div class="col-md-3">
										                              			<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
										                              		</div>
										                              		<div class="col-md-9">
										                              			<div class="row">
										                              				<div class="col">
										                              					<h5 class="mb-0">${u.userNm}</h5>
										                              					<h6><small class="text-muted">${u.rankNm}</small></h6>
										                              				</div>
										                              				<div class="col">
										                              					<input class="form-check-input" type="checkbox" value="${u.userId}" name="userId"/>
										                              				</div>
										                              			</div>
										                              		</div>
											                            </div>
								                            	  	</c:if> 
								                            	  </c:forEach>
							                              </c:forEach>
						                                </div>
						                              </div>
						                              <div class="modal-footer">
						                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
						                                  취소
						                                </button>
						                                <button type="submit" class="btn btn-secondary">추가</button>
						                              </div>
					                              </form>
					                            </div>
					                          </div>
					                        </div>
					                        </c:forEach>
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