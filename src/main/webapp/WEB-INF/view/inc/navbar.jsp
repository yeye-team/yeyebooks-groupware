<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
						        <span class="align-middle">마이페이지</span>
						      </a>
						    </li>
						    <li>
						      <a class="dropdown-item" href="auth-login-basic.html">
						        <i class="bx bx-power-off me-2"></i>
						        <span class="align-middle">로그아웃</span>
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