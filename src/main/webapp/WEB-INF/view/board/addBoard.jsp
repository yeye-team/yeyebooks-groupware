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
<title>YEYEBOOKS</title>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<!-- 네이버 스마트 에디터 스크립트 -->
	<!-- <script type="text/javascript" src="smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
	<!-- <script>
	let oEditors = [];

    smartEditor = function() {
           nhn.husky.EZCreator.createInIFrame({
               oAppRef: oEditors,
               elPlaceHolder: "editorTxt0", //textarea에 부여한 아이디와 동일해야한다.
               sSkinURI: "/static/smarteditor/SmartEditor2Skin.html", //자신의 프로젝트에 맞게 경로 수
               fCreator: "createSEditor2"
           })
       }
		
	    $(document).ready(function() {
	     	//스마트에디터 적용
	          smartEditor(); 
	              //값 불러오기
	           function preview(){
	            	// 에디터의 내용을 textarea에 적용
	            	oEditors.getById["editorTxt0"].exec("UPDATE_CONTENTS_FIELD", []);
	                // textarea 값 불러오기 
	            	var content = document.getElementById("editorTxt0").value;
	            	alert(content);
	            	return;
	        }
	           
	     })
	</script> -->
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
    </style>
</head>
<body>
	<!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
		<div class="layout-container">
			<!-- Menu -->
			<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
				<div class="app-brand demo">
					<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png"
					style="width:100%">
				</div>
		
				<div class="menu-inner-shadow"></div>
				
				<!-- 메뉴바 게시판 클릭 구현부 -->
				<form action="/yeyebooks/board/boardList" method="post">
					<ul class="menu-inner py-1">
						<!-- Dashboard -->
						<li class="menu-item">
							<button type="submit" name="boardCatCd" value="00" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">공지사항</div>
							</button>
						</li>
						<li class="menu-item">
							<button type="submit" name="boardCatCd" value="99" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">전체 게시판</div>
							</button>
						</li>
						<!-- 관리자 사용자 메뉴 구분 -->
						<c:choose>
							<c:when test="${userId != 'admin'}">
								<li class="menu-item">
									<button type="submit" name="boardCatCd" value="dept" class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">부서 게시판</div>
									</button>
								</li>
							</c:when>
							<c:otherwise>
								<li class="menu-item">
									<a class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">부서 게시판</div>
									</a>
									<div class="card overflow-hidden" style="height: 250px;">
						        		<div class="card-body" id="vertical-example">
											<c:forEach var="s" items="${selectAllCatCode}">
												<button type="submit" name="boardCatCd" value="${s.code}" class="menu-link">
													<i class='bx bx-clipboard'></i>
													<div data-i18n="Analytics">${s.codeNm} 게시판</div>
												</button>
											</c:forEach>
										</div>
									</div>
								</li>
							</c:otherwise>
						</c:choose>	
					</ul>
				</form>
				<!-- /메뉴바 게시판 클릭 구현부 -->
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
									<div class="card-header d-flex justify-content-between align-items-center">
										<h3 class="mb-0"><strong>게시글 쓰기</strong></h3>
									</div>
									<!-- 구분선 -->
									<hr class="m-0">
      						    	<div class="card-body">
					                    <form action="${pageContext.request.contextPath}/board/addBoard" method="post" enctype="multipart/form-data">
				                        	<!-- 게시판 선택 -->
					                        <div class="mb-3">
				                           		<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
					                            	<input
						                                type="radio"
						                                class="btn-check"
						                                name="boardCatCd"
						                                value="99"
						                                id="btnradio1"
						                                checked
						                                autocomplete="off"
													/>
					                                <label class="btn btn-outline-primary" for="btnradio1">전체 게시판</label>
					                                <input type="radio" class="btn-check" name="boardCatCd" value="${boardCatCd}" id="btnradio2" autocomplete="off" />
					                                <label class="btn btn-outline-primary" for="btnradio2">부서 게시판</label>
												</div>
					                        </div>
					                        <!-- 제목 입력 -->
							                <div class="mb-5">
								                <input type="hidden" name="userId" value="${userId}">
								                <input type="text" name="boardTitle" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" />
							                </div>
							                <!-- 첨부 파일 -->
							                <div class="mb-1">
							                	<input class="form-control" type="file" name="boardFile" id="formFileMultiple" multiple />
							                </div>
							                <!-- 내용 입력 -->
                     						<div class="mb-3">
						                        <textarea
							                         id="basic-default-message"
							                         class="form-control"
							                         placeholder="내용을 입력하세요"
							                         name="boardContents"
							                         style="height: 500px;"></textarea>
               							  	</div>
											<button type="submit" class="btn btn-primary" style="float: right;">등록</button>
										</form>
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