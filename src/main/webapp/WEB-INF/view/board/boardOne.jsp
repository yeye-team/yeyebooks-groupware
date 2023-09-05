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
			
			// 게시물 삭제 비동기 처리
			$(".deleteBoardBtn").click(function(){
				//var deleteBoardCk = confirm("게시물을 삭제하시겠습니까?");
				Swal.fire({
                    title: '경고',
                    text: "게시물을 삭제하시겠습니까?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
						var boardNo = $(this).data("boardno");
			            var boardCatCd = $(this).data("boardcatcd");
						
						$.ajax({
							type: "POST",
							url: "${pageContext.request.contextPath}/board/deleteBoard",
							data: {
								boardNo: boardNo,
								boardCatCd: boardCatCd
							},
							success: function(response) {
								Swal.fire({
					                icon: 'success',
					                title: '성공',
					                text: '게시글이 삭제되었습니다.',
					                onClose: function() {
					                    window.location.href = "${pageContext.request.contextPath}/board/boardList?boardCatCd=" + boardCatCd;
					                }
					            });
							},
							error: function() {
								alert("게시글 삭제 실패");
							}
						});
					}
                })
			});
		
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
			$(".modifyCmtBtn").click(function(e) {
				// 기존 redirect 막기
				e.preventDefault();
			
				var modifyRow = $(this).closest(".commentRow");
				var boardNo = modifyRow.find("[name='boardNo']").val();
				var cmntNo = modifyRow.find("[name='cmntNo']").val();
				var modifyComment = modifyRow.find("[name='modifyComment']").val();
			
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/board/modifyComment",
					data: {
						boardNo: boardNo,
						cmntNo: cmntNo,
						modifyComment: modifyComment
					},
					success: function(response) {
						// 수정된값
						// 기존값 > 수정값 변경, 수정폼 숨기기, 드롭다운 표시
						modifyRow.find(".oriComment").text(modifyComment);
						modifyRow.find(".modifyBox").hide();
						modifyRow.find(".oriComment").show();
						modifyRow.find(".comDropdown").show();
					},
					error: function() {
					    alert("댓글 수정 실패");
					}
				});
			});
		    
		    // 댓글 삭제 비동기처리
			$(".deleteCommentBtn").click(function() {
				// 삭제 alert
                Swal.fire({
                    title: '경고',
                    text: "댓글을 삭제하시겠습니까?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                    	var deleteRow = $(this).closest(".commentRow");
    					var boardNo = deleteRow.find("[name='boardNo']").val();
    					var cmntNo = deleteRow.find("[name='cmntNo']").val();
    					
    					$.ajax({
    						type: "POST",
    						url: "${pageContext.request.contextPath}/board/deleteComment",
    						data: {
    							boardNo: boardNo,
    							cmntNo: cmntNo
    						},
    						success: function(response) {
    							deleteRow.remove();
    							Swal.fire({
    				                icon: 'success',
    				                title: '성공',
    				                text: '댓글이 삭제되었습니다.',
    							});
    						},
    						error: function() {
    							alert("댓글 삭제 실패");
    						}
    					});
                    }
                })
			});
		    
		    // 댓글 등록 비동기처리
		    $(".insertComBtn").click(function(e){
		    	// 기존 redirect 막기
				e.preventDefault();
		    	
				if($('#newComment').val()==''){
					Swal.fire({
			                icon: 'warning',
			                title: '경고',
			                text: '댓글은 필수값입니다.',
					});
				} else {
			        var addForm = $(this).closest("#addComForm");
					var boardNo = addForm.find("[name='boardNo']").val();
					var userId = addForm.find("[name='userId']").val();
					var addComment = addForm.find("[name='comment']").val();
					
			        $.ajax({
			        	type: "POST",
			        	url: "${pageContext.request.contextPath}/board/addComment",
			        	data: {
							boardNo: boardNo,
							userId: userId,
							comment: addComment
						},
			        	success: function(response){
			        		addForm.find("textarea").val("");
			        		location.reload();
			        	},
			        	error: function(){
			        		alert("등록실패");
			        	}
			        });
				}
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
							<c:when test="${board.boardCatCd=='00'}">
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
							<c:when test="${board.boardCatCd=='99'}">
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
									<c:when test="${board.boardCatCd != '00' && board.boardCatCd != '99'}">
										<li class="menu-icon tf-icons menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-icon tf-icons menu-item">
									</c:otherwise>
								</c:choose>
									<button type="submit" name="boardCatCd" value="${userDept.deptCd}" class="menu-link">
										<i class='menu-icon tf-icons bx bx-clipboard'></i>
										<div data-i18n="Analytics">${userDept.deptNm} 게시판</div>
									</button>
								</li>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${board.boardCatCd != '00' && board.boardCatCd != '99'}">
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
	        <c:set value="${board}" var="b"></c:set>
	        <div class="layout-page">
	        	<jsp:include page="../inc/navbar.jsp"></jsp:include>
				<!-- Content wrapper -->
				<div class="content-wrapper">
	            <!-- Content -->
	            	<div class="container-xxl flex-grow-1 container-p-y">
	            		<div class="card">
		            		<div class="row">
		            			<div class="col-md-11">
					            	<!-- 게시물 수정 헤더 -->
					            	<div class="card-header">
						            	<c:choose>
						            		<c:when test="${b.boardCatCd=='00'}">
												<h5 class="fw-bold py-0 mb-2">공지 게시판</h5>
						            		</c:when>
						            		<c:when test="${b.boardCatCd=='99'}">
												<h5 class="fw-bold py-0 mb-2">전체 게시판</h5>
						            		</c:when>
						            		<c:otherwise>
												<h5 class="fw-bold py-0 mb-2">${b.userDept} 게시판</h5>
						            		</c:otherwise>
						            	</c:choose>
										<h2 class="fw-bold py-0 mb-2">${b.boardTitle}</h2>
										<h6 class="fw-bold py-0 mb-1">
											<c:choose>
												<c:when test="${b.userRank == null}">
													<td>관리자</td>
												</c:when>
												<c:otherwise>
													<td>${b.userNm} ${b.userRank}</td>
												</c:otherwise>
											</c:choose>
										</h6>
										<h6 class="fw-bold py-0 mb-2">${fn:substring(b.cDate,0,16)}&nbsp;&nbsp;&nbsp;조회 ${b.boardView}</h6>
			            			</div>
				            	</div>
				            	
				            	<!-- 게시글 수정삭제 버튼 -->
				            	<div class="col-md-1" 
				            		 style="display: flex;
       										justify-content: center;
       										align-items: center; ">
       								<c:if test="${userId == b.userId || userId == 'admin'}">
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
												<c:if test="${userId == b.userId}">
													<a class="dropdown-item modifyBoardBtn" href="${pageContext.request.contextPath}/board/modifyBoard?boardNo=${b.boardNo}">수정</a>
												</c:if>
												<a class="dropdown-item deleteBoardBtn" data-boardNo="${b.boardNo}" data-boardCatCd="${b.boardCatCd}" href="javascript:void(0);">삭제</a>
											</div>
										</div>
       								</c:if>
				            	</div>
		            		</div>
		            		<!-- 구분선 -->
							<hr class="m-0">
							<!-- 게시물 상세 내용 -->
							<div class="card-body">
								<div>
									${b.boardContents}
								</div><br>
								<c:if test="${boardFile != null}">
									<!-- 첨부파일 -->
									<div>
										<c:forEach items="${boardFile}" var="f">
											<a 
												href="../boardFile/${f.saveFilename}"
												download="${f.originFilename}">
												${f.originFilename}
											</a><br>
										</c:forEach>
									</div>
								</c:if>
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
												<form id="modifyForm-${c.cmntNo}" action="${pageContext.request.contextPath}/board/modifyComment" method="post">
													<div class="modifyBox" style="display: none;">
														<div class="input-group">
															<input type="hidden" name="boardNo" value="${c.boardNo}" readonly="readonly">
															<input type="hidden" name="cmntNo" value="${c.cmntNo}" readonly="readonly">
									                        <textarea class="form-control" aria-label="With textarea" name="modifyComment" placeholder="댓글을 남겨보세요" required="required"></textarea>
								                        </div>
								                        <div style="margin-top: 5px; margin-bottom: 5px; float: right;">
															<button type="button" class="modifyCancel btn btn-outline-secondary">취소</button>
															<button type="button" class="modifyCmtBtn btn btn-secondary">수정</button>
								                        </div>
													</div>
												</form>
											</div>
											<div class="col-md-1"
												 style="display: flex;
	       										 		justify-content: center;
	       										 		align-items: center; ">
												<c:choose>
													<c:when test="${c.userId == userId}">
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
					                        	<c:choose>
					                        		<c:when test="${userDept.userNm == null}">
					                        			<a>관리자</a><br>
					                        		</c:when>
					                        		<c:otherwise>
							                        	<a>${userDept.userNm}</a><br>
					                        		</c:otherwise>
					                        	</c:choose>
												<input type="hidden" name="boardNo" value="${b.boardNo}">
												<input type="hidden" name="userId" value="${userId}">
					                        </span>
					                        <textarea class="form-control" aria-label="With textarea" name="comment" placeholder="댓글을 남겨보세요" required="required" id="newComment"></textarea>
					                        <br>
				                        </div>
				                        <button type="button" class="insertComBtn btn btn-secondary m-3" style="float: right;">등록</button>
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