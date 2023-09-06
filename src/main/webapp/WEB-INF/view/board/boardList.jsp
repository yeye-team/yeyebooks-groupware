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
	<c:set value="${userDept}" var="ud"></c:set>
    <!-- 게시판 변경 시 타이틀 변경 -->
	<c:choose>
		<c:when test="${boardCatCd=='00'}">
			<title>공지사항 게시판</title>
		</c:when>
		<c:when test="${boardCatCd=='99'}">
			<title>전체 게시판</title>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${userId != 'admin'}">
					<title>${ud.deptNm} 게시판</title>
				</c:when>
				<c:otherwise>
					<title>부서 게시판</title>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
	
    <jsp:include page="../inc/head.jsp"></jsp:include>
    
    <script>
		$(document).ready(function() {
			// 드롭다운 내용 변경
			document.querySelectorAll(".dropdown-item").forEach(function(item) {
			    item.addEventListener("click", function() {
			      var selectedOption = this.getAttribute("data-option");
			      document.getElementById("searchOptionBtn").textContent = selectedOption;
			    });
			});
		});
			
		// 검색 실행
		function search() {
	        // 선택된 검색 옵션 가져오기
	        var searchOption = document.getElementById("searchOptionBtn").textContent.trim();
	        if(searchOption == null){
	        	searchOption = "제목";
	        }
	        // 검색어 가져오기
	        var searchKeyword = document.getElementById("searchKeyword").value;
	        var currentPage = ${currentPage};
	        var boardCatCd = "${boardCatCd}";
	        
	        if(searchKeyword == null || searchKeyword == ''){
	        	Swal.fire({
                    title: '경고',
                    text: "검색어를 입력하세요",
                    icon: 'warning'
	        	});
	        	return false;
	        }
		        
        	console.log(currentPage);
        
			$.ajax({
				type: 'GET',
				url: '${pageContext.request.contextPath}/board/boardList',
				data: {
					boardCatCd: boardCatCd,
					currentPage: currentPage,
					searchOption: searchOption,
					searchKeyword: searchKeyword
				},
				success: function(response){
					const boardListChildren = $(response).find('#boardList').children();
					const pageListChildren = $(response).find('#pageList').children();
					$('#boardList').html(boardListChildren);
					$('#pageList').html(pageListChildren);
				}
			})
		}
			
		// 페이지 변동 시 검색값 유지
		function changePage(pageNumber) {
		    // 선택된 검색 옵션 가져오기
	    	var searchOption = document.getElementById("searchOptionBtn").textContent.trim();
		    if (searchOption == null) {
		        searchOption = "제목";
		    }
		    // 검색어 가져오기
		    var searchKeyword = document.getElementById("searchKeyword").value;
		    var boardCatCd = "${boardCatCd}";

		    if (searchKeyword == null) {
		        alert("검색어를 입력하세요");
		        return false;
		    }

		    $.ajax({
		        type: 'GET',
		        url: '${pageContext.request.contextPath}/board/boardList',
		        data: {
		            boardCatCd: boardCatCd,
		            currentPage: pageNumber,
		            searchOption: searchOption,
		            searchKeyword: searchKeyword
		        },
		        success: function (response) {
		            const boardListChildren = $(response).find('#boardList').children();
		            const pageListChildren = $(response).find('#pageList').children();
		            $('#boardList').html(boardListChildren);
		            $('#pageList').html(pageListChildren);
		        }
		    });
		}
    </script>
    
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
    	h2{
    		text-align: center;
    	}
    	
    	.addBtn{
    		display: flex;
 		   justify-content: flex-end;
    	}
    	
    	.table{
    		text-align: center;
    		table-layout: fixed;
       		width: 100%; /* 테이블의 전체 너비 */
    	}
    	
    	.table th,
   		.table td:nth-child(1) {
	        width: 25%;
    	}
    	tbody tr:hover {
    		background-color: lightgray;
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
						<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png"
						     style="width:100%">
					</a>
				</div>
		
				<div class="menu-inner-shadow"></div>
				
				<!-- 메뉴바 게시판 클릭 구현부 -->
				<form action="/yeyebooks/board/boardList" method="post">
					<ul class="menu-inner py-1">
						<!-- 각 게시판을 클릭한 각각의 경우별로 active 부여 -->
						<!-- Dashboard -->
						<c:choose>
							<c:when test="${boardCatCd=='00'}">
								<li class="menu-icon tf-icons menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-icon tf-icons menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="boardCatCd" value="00" class="menu-link">
								<i class='menu-icon tf-icons bx bx-clipboard'></i>
								<div data-i18n="Analytics">공지사항</div>
							</button>
						</li>
						<c:choose>
							<c:when test="${boardCatCd=='99'}">
								<li class="menu-icon tf-icons menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-icon tf-icons menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="boardCatCd" value="99" class="menu-link">
								<i class='menu-icon tf-icons bx bx-clipboard'></i>
								<div data-i18n="Analytics">전체 게시판</div>
							</button>
						</li>
						<!-- 사용자 관리자 메뉴 구분 -->
						<c:choose>
							<c:when test="${userId != 'admin'}">
								<c:choose>
									<c:when test="${boardCatCd != '00' && boardCatCd != '99'}">
										<li class="menu-icon tf-icons menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-icon tf-icons menu-item">
									</c:otherwise>
								</c:choose>
									<button type="submit" name="boardCatCd" value="${ud.deptCd}" class="menu-link">
										<i class='menu-icon tf-icons bx bx-clipboard'></i>
										<div data-i18n="Analytics">${ud.deptNm} 게시판</div>
									</button>
								</li>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${boardCatCd != '00' && boardCatCd != '99'}">
										<li class="menu-icon tf-icons menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-icon tf-icons menu-item">
									</c:otherwise>
								</c:choose>
									<a class="menu-link">
										<i class='menu-icon tf-icons bx bx-clipboard'></i>
										<div data-i18n="Analytics">부서 게시판</div>
									</a>
									<div class="card overflow-hidden" style="height: 250px;">
						        		<div class="card-body" id="vertical-example">
											<c:forEach var="s" items="${selectAllCatCode}">
												<button type="submit" name="boardCatCd" value="${s.code}" class="menu-link">
													<i class='menu-icon tf-icons bx bx-clipboard'></i>
													<div data-i18n="Analytics">${s.codeNm} 게시판</div>
												</button>
											</c:forEach>
										</div>
									</div>
								</li>
							</c:otherwise>
						</c:choose>
						<!-- /각 게시판을 클릭한 각각의 경우별로 active 부여 -->
					</ul>
				</form>
				<!-- /메뉴바 게시판 클릭 구현부 -->
			</aside>
			<!-- / Menu -->

	        <!-- Layout container -->
	        <div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
		            	<!-- 게시판 변경 시 헤더 변경 -->
						<c:choose>
							<c:when test="${boardCatCd=='00'}">
								<h2 class="fw-bold py-3 mb-4">공지사항 게시판</h2>
							</c:when>
							<c:when test="${boardCatCd=='99'}">
								<h2 class="fw-bold py-3 mb-4">전체 게시판</h2>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${userId != 'admin'}">
										<h2 class="fw-bold py-3 mb-4">${ud.deptNm} 게시판</h2>
									</c:when>
									<c:otherwise>
										<h2 class="fw-bold py-3 mb-4">게시글 관리</h2>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						
						<!-- 검색 창 -->
						<div class="container">
							<div class="row">
								<div class="col-md-7">
								&nbsp;
								</div>
								<div class="col-md-5">
									<div class="input-group" style="width:65%;">
										<button
											type="button"
											class="btn btn-outline-dark dropdown-toggle"
											data-bs-toggle="dropdown"
											aria-expanded="false"
											id="searchOptionBtn"
										>
											제목
										</button>
										<ul class="dropdown-menu">
											<li><a class="dropdown-item" href="javascript:void(0);" data-option="제목">제목</a></li>
											<li><a class="dropdown-item" href="javascript:void(0);" data-option="내용">내용</a></li>
											<li><a class="dropdown-item" href="javascript:void(0);" data-option="제목+내용">제목+내용</a></li>
										</ul>
										<input
											type="text"
											class="form-control"
											placeholder="검색어를 입력하세요."
											id="searchKeyword"
										/>
										<button class="input-group-text" type="button" onclick="search()" style="z-index: 0;"><i class="tf-icons bx bx-search"></i></button>
									</div>
								</div>	
							</div>
						</div>
						<br>
						<!-- 게시물 리스트 -->
				        <div class="card" style="height: 600px;">
				          <div class="table-responsive text-nowrap" style="height: 500px;">
				            <table class="table">
				              <thead>
				                <tr>
									<th>제목</th>
									<th>작성자</th>
									<th>작성날짜</th>
									<th>조회수</th>
				                </tr>
				              </thead>
				              <tbody class="table-border-bottom-0" id="boardList">
								<!-- 게시판 변경 시 내용변경 -->
								<c:forEach var="n" items="${selectBoard}">
									<tr style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/board/boardOne?boardNo=${n.boardNo}'">
										<td>${n.boardTitle}</td>
										<td>${n.userNm}</td>
										<td>${fn:substring(n.cDate,0,11)}</td>
										<td>${n.boardView}</td>
									</tr>
								</c:forEach>
							  </tbody>
							</table>
							<!-- 구분선 -->
							<hr class="m-0">
						  </div>
						
		             		<!-- 페이징 -->
			                <div class="card-body"
			                	 id="pageList" 
			                	style="height: 30px;
			                		   display: flex;
        							   justify-content: space-between;">
								<div class="row">
				                    <div class="col">
										<div class="demo-inline-spacing">
					                        <nav aria-label="Page navigation">
												<ul class="pagination">
						                          	<!-- 페이징 -->
													<c:if test="${currentPage!=1}">
														<li class="page-item first">
															<a class="page-link" onclick="changePage(1)">
																<i class="tf-icon bx bx-chevrons-left"></i>
															</a>
														</li>
													</c:if>
													<!-- 1페이지가 아닐때 출력 -->
													<c:if test="${minPage>1}">
														<li class="page-item prev">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${minPage - pagePerPage})">
																<i class="tf-icon bx bx-chevron-left"></i>
															</a>
														</li>
													</c:if>
													<!-- 페이지 5단위 출력 -->
													<c:forEach var="i" begin="${minPage}" end="${maxPage}">
														<c:choose>
															<c:when test="${i==currentPage}">
																<!-- 현재 페이지일때 출력 -->
																<li class="page-item active">
																	<a class="page-link">${i}</a>
																</li>
															</c:when>
															<c:otherwise>
																<!-- 현재 페이지 아닐때 출력 -->
																<li class="page-item">
																	<a class="page-link" href="javascript:void(0);" onclick="changePage(${i})">${i}</a>
																</li>
															</c:otherwise>
														</c:choose>
													</c:forEach>
													<!-- 마지막 페이지 아닐때 출력 -->
													<c:if test="${maxPage!=lastPage}">
														<li class="page-item next">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${minPage+pagePerPage})">
																<i class="tf-icon bx bx-chevron-right"></i>
															</a>
														</li>
													</c:if>
													<!-- 마지막 페이지일때 출력 -->
													<c:if test="${currentPage!=lastPage}">
														<li class="page-item last">
															<a class="page-link" href="javascript:void(0);" onclick="changePage(${lastPage})">
																<i class="tf-icon bx bx-chevrons-right"></i>
															</a>
														</li>
													</c:if>
												</ul>
					                        </nav>
										</div>
				                    </div>
								</div>
			             		<!-- 작성버튼 구분 -->
								<div class="addBtn">
									<c:choose>
										<c:when test="${userId == 'admin' && boardCatCd == '00'}">
											<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=00'">공지 작성</button>
										</c:when>
										<c:when test="${userId != 'admin' && boardCatCd == '99'}">
											<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=99'">게시물 작성</button>
										</c:when>
										<c:when test="${userId != 'admin' && boardCatCd != '00' && boardCatCd != '99'}">
											<button type="button" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/board/addBoard?boardCatCd=${ud.deptCd}'">게시물 작성</button>
										</c:when>
									</c:choose>
								</div>
								<!-- / 작성버튼 -->
			                </div>
			                <!-- / 페이징 -->
			                
						</div>
	             		<!--/ 게시물 리스트 -->
					</div>
				<!-- / Content -->
				</div>
	     	   <!-- / Layout page -->
			</div>
  		</div>
	<!-- / Layout wrapper -->
	</div>
    <jsp:include page="../inc/coreJs.jsp"></jsp:include>
  </body>
</html>
