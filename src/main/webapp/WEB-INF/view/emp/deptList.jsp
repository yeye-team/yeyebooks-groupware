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
	<title>조직도</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
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
	              <a href="index.html" class="menu-link">
	                <i class="menu-icon tf-icons bx bx-group"></i>
	                <div data-i18n="Analytics">조직관리</div>
	              </a>
	            </li>

	            <!--  -->
	            <li class="menu-item">
					<a href="javascript:void(0);" class="menu-link menu-toggle">
					  <i class="menu-icon tf-icons bx bx-user"></i>
					  <div data-i18n="Layouts">사용자관리</div>
					</a>

					<ul class="menu-sub">
					  <li class="menu-item">
					    <a href="layouts-without-menu.html" class="menu-link">
					      <div data-i18n="Without menu">Without menu</div>
					    </a>
					  </li>
					  <li class="menu-item">
					    <a href="layouts-without-navbar.html" class="menu-link">
					      <div data-i18n="Without navbar">Without navbar</div>
					    </a>
					  </li>
					  <li class="menu-item">
					    <a href="layouts-container.html" class="menu-link">
					      <div data-i18n="Container">Container</div>
					    </a>
					  </li>
					  <li class="menu-item">
					    <a href="layouts-fluid.html" class="menu-link">
					      <div data-i18n="Fluid">Fluid</div>
					    </a>
					  </li>
					  <li class="menu-item">
					    <a href="layouts-blank.html" class="menu-link">
					      <div data-i18n="Blank">Blank</div>
					    </a>
					  </li>
					</ul>
            	</li>
          	</ul>
        </aside>
        <!-- / Menu -->

        <!-- Layout container -->
        <div class="layout-page">
			<!-- Navbar -->
			<nav class="navbar navbar-expand-lg navbar-light bg-menu-theme">
				<div class="container-fluid">
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul class="navbar-nav me-auto mb-2 mb-lg-0">
						  <li class="nav-item">
						    <a class="nav-link" href="javascript:void(0)">조직</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" href="javascript:void(0)">구성원</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" href="javascript:void(0)">예약</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" href="javascript:void(0)">게시판</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" href="javascript:void(0)">일정</a>
						  </li>
						</ul>
						<ul class="navbar-nav flex-row align-items-center ms-auto">
				
						<!-- User -->
						<li class="nav-item navbar-dropdown dropdown-user dropdown">
						  <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
						    <div class="avatar avatar-online">
						      <img src="${pageContext.request.contextPath}/assets/img/avatars/1.png" class="w-px-40 h-auto rounded-circle" />
						   </div>
						 </a>
						 <ul class="dropdown-menu dropdown-menu-end">
						   <li>
						     <a class="dropdown-item" href="#">
						       <div class="d-flex">
						         <div class="flex-shrink-0 me-3">
						           <div class="avatar avatar-online">
						             <img src="${pageContext.request.contextPath}/assets/img/avatars/1.png" class="w-px-40 h-auto rounded-circle" />
						            </div>
						          </div>
						          <div class="flex-grow-1">
						            <span class="fw-semibold d-block">John Doe</span>
						            <small class="text-muted">Admin</small>
						          </div>
						        </div>
						      </a>
						    </li>
						    <li>
						      <div class="dropdown-divider"></div>
						    </li>
						    <li>
						      <a class="dropdown-item" href="#">
						        <i class="bx bx-user me-2"></i>
						        <span class="align-middle">My Profile</span>
						      </a>
						    </li>
						    <li>
						      <a class="dropdown-item" href="#">
						        <i class="bx bx-cog me-2"></i>
						        <span class="align-middle">Settings</span>
						      </a>
						    </li>
						    <li>
						      <a class="dropdown-item" href="#">
						        <span class="d-flex align-items-center align-middle">
						          <i class="flex-shrink-0 bx bx-credit-card me-2"></i>
						          <span class="flex-grow-1 align-middle">Billing</span>
						          <span class="flex-shrink-0 badge badge-center rounded-pill bg-danger w-px-20 h-px-20">4</span>
						        </span>
						      </a>
						    </li>
						    <li>
						      <div class="dropdown-divider"></div>
						    </li>
						    <li>
						      <a class="dropdown-item" href="auth-login-basic.html">
						        <i class="bx bx-power-off me-2"></i>
						        <span class="align-middle">Log Out</span>
						      </a>
						    </li>
						  </ul>
						</li>
						<!--/ User -->
						</ul>
					</div>
				</div>
          	</nav>
			<!-- / Navbar -->

			<!-- Content wrapper -->
			<div class="content-wrapper">
            <!-- Content -->
            <div class="container-xxl flex-grow-1 container-p-y">
				<div class="card mb-4">
]					<h5 class="card-header">조직관리</h5>
				  	<hr class="m-0" />
				  	<div class="card-body">
						<small class="text-light fw-semibold">YeYeBooks</small>
                      	<div class="mt-3">
                        	<div class="row">
                          		<div class="col-md-3 col-12 mb-3 mb-md-0">
                            		<div class="list-group">
			                           	<a
			                               class="list-group-item list-group-item-action active"
			                               id="list-home-list"
			                               data-bs-toggle="list"
			                               href="#list-home"
			                               >전체</a
			                             >
			                            <c:forEach var="d" items="${list}">
				                           	<a
				                               class="list-group-item list-group-item-action"
				                               id="list-home-list"
				                               data-bs-toggle="list"
				                               href="#list-home"
				                               >${d.codeNm}</a
				                             >
			                            </c:forEach>
                            		</div>
                          		</div>
                          		<div class="col-md-9 col-12">
                            		<div class="card overflow-hidden" style="height: 500px; box-shadow: none">
						                    <div class="card-body" id="vertical-example">
					                    		<div class="tab-content p-0">
						                        	<div class="tab-pane fade show active" id="list-home">
						                            	<div class="row">
							                            	<div class="col-md-6 mb-5 row">
							                              		<div class="col-md-3">
							                              			<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              		</div>
							                              		<div class="col-md-9">
							                              			<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              		</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                             
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                             <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
							                              <div class="col-md-6 mb-5 row">
							                              	<div class="col-md-3">
							                              		<img src="${pageContext.request.contextPath}/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle" width="100%" />
							                              	</div>
							                              	<div class="col-md-9">
							                              		<h5 class="mb-0">정석현 <br><small class="text-muted">사원</small></h5>
							                              	</div>
							                              </div>
						                              </div>         
						                              </div>
						                              <div class="tab-pane fade" id="list-profile">
						                                Muffin lemon drops chocolate chupa chups jelly beans dessert jelly-o. Soufflé gummies
						                                gummies. Ice cream powder marshmallow cotton candy oat cake wafer. Marshmallow
						                                gingerbread tootsie roll. Chocolate cake bonbon jelly beans lollipop jelly beans halvah
						                                marzipan danish pie. Oat cake chocolate cake pudding bear claw liquorice gingerbread
						                                icing sugar plum brownie. Toffee cookie apple pie cheesecake bear claw sugar plum wafer
						                                gummi bears fruitcake.
						                              </div>
						                              <div class="tab-pane fade" id="list-messages">
						                                Ice cream dessert candy sugar plum croissant cupcake tart pie apple pie. Pastry
						                                chocolate chupa chups tiramisu. Tiramisu cookie oat cake. Pudding brownie bonbon. Pie
						                                carrot cake chocolate macaroon. Halvah jelly jelly beans cake macaroon jelly-o. Danish
						                                pastry dessert gingerbread powder halvah. Muffin bonbon fruitcake dragée sweet sesame
						                                snaps oat cake marshmallow cheesecake. Cupcake donut sweet bonbon cheesecake soufflé
						                                chocolate bar.
						                              </div>
						                              <div class="tab-pane fade" id="list-settings">
						                                Marzipan cake oat cake. Marshmallow pie chocolate. Liquorice oat cake donut halvah
						                                jelly-o. Jelly-o muffin macaroon cake gingerbread candy cupcake. Cake lollipop lollipop
						                                jelly brownie cake topping chocolate. Pie oat cake jelly. Lemon drops halvah jelly
						                                cookie bonbon cake cupcake ice cream. Donut tart bonbon sweet roll soufflé gummies
						                                biscuit. Wafer toffee topping jelly beans icing pie apple pie toffee pudding. Tiramisu
						                                powder macaroon tiramisu cake halvah.
						                              </div>
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