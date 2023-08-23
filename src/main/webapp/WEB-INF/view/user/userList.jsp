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
	<title>사용자 관리</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
	<style>
		.swal2-container{
			z-index: 1100;
		}
	</style>
	<script>
		$(document).ready(function(){
			$.ajax({
				async : false, 
				url : 'rest/deptList',
				type : 'get',
				success : function(model) {
					$(model).each(function(index, item){
						let str = '<option value="'+item.deptCd+'">'+item.deptNm+'</option>';
						$('#deptList').append(str);	
					});
				}
			});
			$.ajax({
				async : false, 
				url : 'rest/rankList',
				type : 'get',
				success : function(model) {
					$(model).each(function(index, item){
						let str = '<option value="'+item.rankCd+'">'+item.rankNm+'</option>';
						$('#rankList').append(str);	
					});
				}
			});
			
			$('#addUserBtn').on('click',function(){
				$('#addUserForm').submit();
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
	            <!-- 조직관리 -->
	            <li class="menu-item">
	              <a href="${pageContext.request.contextPath}/deptList" class="menu-link">
	                <i class="menu-icon tf-icons bx bx-group"></i>
	                부서관리
	              </a>
	            </li>

	            <!-- 사용자관리 -->
	            <li class="menu-item active">
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
							<h4 class="card-header"><strong>사용자관리</strong></h4>
						</div>
					</div>
				  	<hr class="m-0" />
				  	<div class="card-body">
	                	<div class="table-responsive text-nowrap">
	                	<form action="${pageContext.request.contextPath}/addUser" method="post" id="addUserForm">
		                  <table class="table">
		                    <thead>
		                      <tr>
		                        <th>이름</th>
		                        <th>사원번호</th>
		                        <th>비밀번호</th>                     
		                        <th>부서</th>
		                        <th>직급</th>
		                        <th>성별</th>
		                        <th>전화번호</th>
		                        <th>입사일</th>
		                        <th>퇴사일</th>
		                        <th>남은연차</th>
		                        <th>상태</th>
		                      </tr>
		                    </thead>
		                    <tbody class="table-border-bottom-0">                    
		                    	<tr>
			                      	<td colspan="2"><input type="text" name="userNm" class="form-control" placeholder="이름 입력" required="required"></td>
			                      	<td colspan="2">
				                      <div>
				                        <select id="deptList" name="deptCd" class="form-select">
				                          <option value=" ">부서 선택</option>
				                        </select>
				                      </div>
			                      	</td>
			                      	<td colspan="2">
				                      <div>
				                        <select id="rankList" name="rankCd" class="form-select" required="required">
				                          <option value="">직급 선택</option>
				                        </select>
				                      </div>
			                      	</td>
			                      	<td>
				                      <div>
				                        <select name="gender" class="form-select" required="required">
				                          <option value="">성별 선택</option>
				                          <option value="1">남</option>
				                          <option value="2">여</option>
				                        </select>
				                      </div>
			                      	</td>
			                      	<td colspan="2"><input name="joinYmd" type="date" class="form-control" required="required"></td>
			                      	<td colspan="2" style="text-align: center;"><button type="button" class="btn btn-secondary" id="addUserBtn">추가</button></td>
	                      		</tr>
		                    	<c:forEach var="u" items="${list}">
		                    		<tr>
				                      	<td>${u.userNm}</td>
				                      	<td>${u.userId}</td>
				                      	<td>******</td>
				                      	<td>${u.deptNm}</td>
				                      	<td>${u.rankNm}</td>
				                      	<c:if test="${u.gender == 1}">
				                      		<td>남</td>
				                      	</c:if>
				                      	<c:if test="${u.gender == 2}">
				                      		<td>여</td>
				                      	</c:if>
				                      	<td>${u.phoneNo}</td>
				                      	<td>${u.joinYmd}</td>
				                      	<td>${u.leavYmd}</td>
				                      	<td align="center">${u.dayoffCnt}</td>
				                      	<td>${u.userStatNm}</td>
		                      		</tr>
		                    	</c:forEach>
		                    </tbody>
		                  </table>
		                  </form>
		                </div>
		                <div class="mt-3">
		                <!-- Basic Pagination -->
                        <nav aria-label="Page navigation">
                          <ul class="pagination justify-content-center">
                            <c:if test="${currentPage != 1}">
	                            <li class="page-item first">
	                              <a class="page-link" href="${pageContext.request.contextPath}/userList?currentPage=1"
	                                ><i class="tf-icon bx bx-chevrons-left"></i
	                              ></a>
	                            </li>
		                    </c:if>
                            <c:if test="${minPage > 1}">
	                            <li class="page-item prev">
	                              <a class="page-link" href="${pageContext.request.contextPath}/userList?currentPage=${minPage-PagePerPage}"
	                                ><i class="tf-icon bx bx-chevron-left"></i
	                              ></a>
	                            </li>
                            </c:if>
                            <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
	                            <li class="page-item">
	                              <a class="page-link" href="${pageContext.request.contextPath}/userList?currentPage=${i}">${i}</a>
	                            </li>
                            </c:forEach>
                            <c:if test="${maxPage != lastPage}">
	                            <li class="page-item next">
	                              <a class="page-link" href="${pageContext.request.contextPath}/userList?currentPage=${minPage+PagePerPage}"
	                                ><i class="tf-icon bx bx-chevron-right"></i
	                              ></a>
	                            </li>
                            </c:if>  
                            <c:if test="${currentPage != lastPage}">
	                            <li class="page-item last">
	                              <a class="page-link" href="${pageContext.request.contextPath}/userList?currentPage=${lastPage}"
	                                ><i class="tf-icon bx bx-chevrons-right"></i
	                              ></a>
	                            </li>
                            </c:if>
                          </ul>
                        </nav>
                        <!--/ Basic Pagination -->
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