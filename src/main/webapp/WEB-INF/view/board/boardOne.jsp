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
    <script>
		$(document).ready(function() {
		// url파라미터값 삭제
		/* history.replaceState({}, null, location.pathname);  */
		
			// 댓글 수정
		    $(".modifyCommentBtn").click(function() {
		        // 해당 댓글 행에서 수정 버튼이 클릭된 댓글 찾기
		        var commentRow = $(this).closest(".commentRow");

		        // 기존 댓글과 드롭다운 숨기기
		        commentRow.find(".oriComment").hide();
		        commentRow.find(".comDropdown").hide();
		        
		        // 댓글 수정 폼 표시
	        	commentRow.find(".modifyBox").show();
		    });

		    // 댓글 수정 취소 버튼 클릭 시
		    $(".modifyCancel").click(function() {
		        var commentRow = $(this).closest(".commentRow");
		        var textarea = commentRow.find(".modifyBox textarea");
		        
		        // 취소시 입력했던 내용 삭제
		        textarea.val("");
		        
		        // 댓글 수정 폼 숨기기
		        commentRow.find(".modifyBox").hide();

		        // 기존 댓글과 드롭다운 메뉴 표시
		        commentRow.find(".oriComment").show();
		        commentRow.find(".comDropdown").show();
		    });
		    
		    // 댓글 수정 비동기처리
			$(".modifyBox form").submit(function(e) {
				// 기존 redirect 막기
				e.preventDefault();
			
				var form = $(this);
				var formData = form.serialize(); // serialize 값 인코딩
			
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/board/modifyComment",
					data: formData,
					success: function(response) {
						// 수정된값
						var modifiedComment = form.find("textarea").val();
						var cmntNo = form.attr("id").split("-")[1]; // modifyForm-${cmntNo}
						// 기존값 > 수정값 변경, 수정폼 숨기기, 드롭다운 표시
						var commentRow = $("#modifyForm-" + cmntNo);
						
						commentRow.find(".oriComment").text(modifiedComment);
						commentRow.find(".modifyBox").hide();
						commentRow.find(".oriComment").show();
						commentRow.find(".comDropdown").show();
						alert("댓글 수정 성공");
					},
					error: function() {
					    alert("댓글 수정 실패");
					}
				});
			});
		    
		    // 댓글 삭제 비동기처리
			$(".deleteCommentBtn").click(function() {
				// 삭제 alert
				var deleteCk = confirm("댓글을 삭제하시겠습니까?");
				if (deleteCk) {
					var deleteRow = $(this).closest(".commentRow");
					var boardNo = deleteRow.find("[name='boardNo']").val();
					var userId = deleteRow.find("[name='userId']").val();
					var cmntNo = deleteRow.find("[name='cmntNo']").val();
					
					$.ajax({
						type: "POST",
						url: "${pageContext.request.contextPath}/board/deleteComment",
						data: {
							boardNo: boardNo,
							userId: userId,
							cmntNo: cmntNo
						},
						success: function(response) {
							deleteRow.remove();
							alert("댓글 삭제 성공");
						},
						error: function() {
							alert("댓글 삭제 실패");
						}
					});
				}
			});
		    
		    // 댓글 등록 비동기처리
		    $(".insertComBtn").click(function(){
		    	
		    	var form = $("#addCommentForm");
		        var formData = form.serialize();
		        
		        $.ajax({
		        	type: "POST",
		        	url: form.atter("action"),
		        	data: formData,
		        	success: function(response){
		        		form.find("textarea").val("");
		        	},
		        	error: function(){
		        		alert("등록실패");
		        	}
		        });
		    });
		    
		});
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
						<!-- 각 게시판을 클릭한 각각의 경우별로 active 부여 -->
						<c:choose>
							<c:when test="${boardCatCd=='00'}">
								<!-- Dashboard -->
								<li class="menu-item active">
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
							</c:when>
							
							<c:when test="${boardCatCd=='99'}">
								 <!-- Dashboard -->
								<li class="menu-item">
									<button type="submit" name="boardCatCd" value="00" class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">공지사항</div>
									</button>
								</li>
								<li class="menu-item active">
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
							</c:when>
							
							<c:otherwise>
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
										<li class="menu-item active">
											<button type="submit" name="boardCatCd" value="dept" class="menu-link">
												<i class='bx bx-clipboard'></i>
												<div data-i18n="Analytics">부서 게시판</div>
											</button>
										</li>
									</c:when>
									<c:otherwise>
										<li class="menu-item active">
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
							</c:otherwise>		
						</c:choose>
						<!-- /각 게시판을 클릭한 각각의 경우별로 active 부여 -->
					</ul>
				</form>
				<!-- /메뉴바 게시판 클릭 구현부 -->
			</aside>
			<!-- / Menu -->

	        <!-- Layout container -->
	        <c:set value="${board}" var="b"></c:set>
			<c:set value="${boardFile}" var="f"></c:set>
			<c:set value="${user}" var="u"></c:set>
	        <div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
	            		<div class="card">
		            		<div class="row">
		            			<div class="col-md-11">
					            	<!-- 게시물 상세 헤더 -->
					            	<div class="card-header">
										<h2 class="fw-bold py-0 mb-2">${b.boardTitle}</h2>
										<h6 class="fw-bold py-0 mb-1">
											<c:choose>
												<c:when test="${u.userNm == null}">
													<td>관리자</td>
												</c:when>
												<c:otherwise>
													<td>${u.userNm} ${u.codeNm}</td>
												</c:otherwise>
											</c:choose>
										</h6>
										<h6 class="fw-bold py-0 mb-2">${fn:substring(b.CDate,0,16)}&nbsp;&nbsp;&nbsp;조회 ${b.boardView}</h6>
			            			</div>
				            	</div>
				            	<div class="col-md-1" 
				            		 style="display: flex;
       										justify-content: center;
       										align-items: center; ">
					            	<c:choose>
										<c:when test="${loginId == b.userId}">
											<!-- 게시글 수정삭제 버튼 -->
											<div class="dropdown">
												<button
													class="btn p-0"
													type="button"
													id="cardOpt3"
													data-bs-toggle="dropdown"
													aria-haspopup="true"
													aria-expanded="false"
												>
													<i style="font-size: 28px;" class="bx bx-dots-vertical-rounded"></i>
												</button>
												<div class="dropdown-menu dropdown-menu-end" aria-labelledby="cardOpt3">
													<a class="dropdown-item modifyBoardBtn" href="javascript:void(0);">수정</a>
													<a class="dropdown-item deleteBoardBtn" href="javascript:void(0);">삭제</a>
												</div>
											</div>
											<%-- <a href="${pageContext.request.contextPath}/board/modifyBoard">수정</a>
											<a href="${pageContext.request.contextPath}/board/removeBoard">삭제</a> --%>
										</c:when>
										<c:when test="${loginId == 'admin'}">
											<div class="dropdown">
												<button
													class="btn p-0"
													type="button"
													id="cardOpt3"
													data-bs-toggle="dropdown"
													aria-haspopup="true"
													aria-expanded="false"
												>
													<i style="font-size: 28px;" class="bx bx-dots-vertical-rounded"></i>
												</button>
												<div class="dropdown-menu dropdown-menu-end" aria-labelledby="cardOpt3">
													<a class="dropdown-item deleteBoardBtn" href="javascript:void(0);">삭제</a>
												</div>
											</div>
										</c:when>
									</c:choose>
				            	</div>
		            		</div>
		            		<!-- 구분선 -->
							<hr class="m-0">
							<!-- 게시물 상세 내용 -->
							<div class="card-body">
								<c:if test="${f.originFilename != null}">
									<!-- 첨부파일 -->
									<div>
										<a 
											href="${pageContext.request.contextPath}/${f.path}/${f.saveFilename}" 
											download="${f.saveFilename}">${f.originFilename}
										</a>
									</div>
								</c:if>
								<br>
								<div>
									${b.boardContents}
								</div>
							</div>
	             			<!--/ 게시물 상세 내용 -->
	             			<!-- 구분선 -->
							<hr class="m-0">
							<!-- 공지사항은 댓글이 없음. 제외 -->
							<c:if test="${b.boardCatCd != '00'}">
								<div class="card-body">
									<h5><strong>댓글</strong></h5>
									<hr class="m-0">
									<c:forEach var="c" items="${commentList}">
										<div class="row commentRow" style="margin-top: 5px; margin-bottom: 5px;">
											<div class="col-md-2">
												${c.userNm}<br>
												${fn:substring(c.cDate,0,11)}
											</div>
											<div class="col-md-9">
												<!-- 기존 댓글 -->
												<span class="oriComment">${c.cmntContents}</span>
												
												<!-- 댓글 수정 입력 폼 -->
												<form id="modifyForm-${c.cmntNo}"action="${pageContext.request.contextPath}/board/modifyComment" method="post">
													<div class="modifyBox" style="display: none;">
														<div class="input-group">
															<input type="hidden" name="userId" value="${u.userId}" readonly="readonly">
															<input type="hidden" name="boardNo" value="${c.boardNo}" readonly="readonly">
															<input type="hidden" name="cmntNo" value="${c.cmntNo}" readonly="readonly">
									                        <textarea class="form-control" aria-label="With textarea" name="modifyComment" placeholder="댓글을 남겨보세요" required="required"></textarea>
								                        </div>
								                        <div style="margin-top: 5px; margin-bottom: 5px; float: right;">
															<button type="button" class="modifyCancel btn btn-outline-secondary">취소</button>
															<button type="submit" class="btn btn-secondary">수정</button>
								                        </div>
													</div>
												</form>
											</div>
											<div class="col-md-1"
												 style="display: flex;
	       										 		justify-content: center;
	       										 		align-items: center; ">
												<c:choose>
													<c:when test="${c.userId == loginId}">
														<!-- 댓글 수정삭제 버튼 -->
														<div class="dropdown comDropdown">
															<button
																class="btn p-0"
																type="button"
																id="cardOpt3"
																data-bs-toggle="dropdown"
																aria-haspopup="true"
																aria-expanded="false"
															>
																<i style="font-size: 20px;" class="bx bx-dots-vertical-rounded"></i>
															</button>
															<div class="dropdown-menu dropdown-menu-end" aria-labelledby="cardOpt3">
																<a class="dropdown-item modifyCommentBtn" href="javascript:void(0);">수정</a>
																<a class="dropdown-item deleteCommentBtn" href="javascript:void(0);">삭제</a>
															</div>
														</div>
													</c:when>
													<c:otherwise>
														&nbsp;
													</c:otherwise>
												</c:choose>
											</div>
											<!-- 구분선 -->
											<hr class="m-0">
										</div>
									</c:forEach>
									<form id="addComForm" action="${pageContext.request.contextPath}/board/addComment" method="post">
										<div class="input-group">
					                        <span class="input-group-text">
					                        	<a>${u.userNm}</a><br>
												<input type="hidden" name="boardNo" value="${b.boardNo}">
												<input type="hidden" name="loginId" value="${loginId}">
												<input type="hidden" name="userId" value="${u.userId}">
					                        </span>
					                        <textarea class="form-control" aria-label="With textarea" name="comment" placeholder="댓글을 남겨보세요" required="required"></textarea>
					                        <br>
				                        </div>
				                        <button type="submit" class="insertComBtn btn btn-secondary m-3" style="float: right;">등록</button>
			                        </form>
								</div>
							</c:if>
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
	</div>
    <jsp:include page="../inc/coreJs.jsp"></jsp:include>
  </body>
</html>