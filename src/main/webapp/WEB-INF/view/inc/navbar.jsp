<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-menu-theme">
	<div class="container-fluid">
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<c:choose>
				<c:when test="${sessionScope.userId == 'admin'}">
					<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">조직관리</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">구성원관리</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">게시판관리</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">회사일정관리</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">시설/비품관리</a>
					  </li>
					</ul>
				</c:when>
				<c:otherwise>
					<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">전자결재</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">인사</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="/yeyebooks/board/boardList">게시판</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">일정</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="javascript:void(0)">예약</a>
					  </li>
					</ul>
				</c:otherwise>
			</c:choose>
			
			<ul class="navbar-nav flex-row align-items-center ms-auto">
	
			<!-- User -->
			<li class="nav-item navbar-dropdown dropdown-user dropdown">
			  <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
			    <div class="avatar avatar-online">
			      <c:set var="photoUrl" value="${pageContext.request.contextPath}/assets/img/avatars/default.png"></c:set>
			      <c:if test="${sessionScope.userImg != null }">
			      	<c:set var="photoUrl" value="/yeyebooks/${sessionScope.userImg }"></c:set>
			      </c:if>	
			      <img src="${photoUrl }" class="w-px-40 h-auto rounded-circle" />
			   </div>
			 </a>
			 <ul class="dropdown-menu dropdown-menu-end">
			   <li>
			     <a class="dropdown-item" href="#">
			       <div class="d-flex">
			         <div class="flex-shrink-0 me-3">
			           <div class="avatar avatar-online">
			             <img src="${photoUrl }" class="w-px-40 h-auto rounded-circle" />
			            </div>
			          </div>
			          <div class="flex-grow-1">
			            <span class="fw-semibold d-block">${sessionScope.userNm }</span>
			            <small class="text-muted">${sessionScope.userRank ? sessionScope.userRank : '-'}</small>
			          </div>
			        </div>
			      </a>
			    </li>
			    <li>
			      <div class="dropdown-divider"></div>
			    </li>
					<c:if test="${sessionScope.userId != 'admin' }">
					    <li>
					      <a class="dropdown-item" href="/yeyebooks/mypage">
					        <i class="bx bx-user me-2"></i>
					        <span class="align-middle">마이페이지</span>
					      </a>
					    </li>
					</c:if>
			    <li>
			      <a class="dropdown-item" href="/yeyebooks/logout">
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
<script>
	window.onload = function() {
    	window.scrollTo(0, 0);
  	};
</script>
<!-- / Navbar -->