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
	<script type="text/javascript" src="${pageContext.request.contextPath}/smartEditor/js/HuskyEZCreator.js"></script>
	<script>
		$(document).ready(function(){
			// 파일 개수 3개제한
			$('#addFile').click(function(){
				if ($('.boardFiles').length >= 3) {
					Swal.fire({
		                icon: 'warning',
		                title: '경고',
		                text: '최대 3개의 파일만 첨부할 수 있습니다.',
					});
				} else if ($('.boardFiles').last().val() == ''){
					Swal.fire({
		                icon: 'warning',
		                title: '경고',
		                text: '빈 파일 업로드가 있습니다.',
					});
				} else {
					$('#files').append('<input class="form-control boardFiles" type="file" name="multipartFile"><br>')
				}
			});
			
			$('#removeFile').click(function(){
		        if ($('.boardFiles').length === 1) {
		        	if ($('.boardFiles').val() !== "") {
		        		$('.boardFiles').val("");
		            } else {
		                Swal.fire({
			                icon: 'warning',
			                title: '경고',
			                text: '더 이상 삭제할 파일이 없습니다.',
						});
		            }
		        } else {
		            $('.boardFiles').last().remove();
		        }
		    });
			
			// 파일 용량 3MB 제한 / 확장자 제한
			$(document).on("change", "input[name='multipartFile']", function() {
				var maxSize = 3 * 1024 * 1024;
			    var allowedExtensions = ["xlsx", "docs", "hwp", "pdf", "pptx", "ppt", "jpg", "jpeg", "png"];
			    
			    var file = this.files[0];
			    var fileSize = file.size;
			    var fileExtension = file.name.split('.').pop().toLowerCase();
			    
			    if (fileSize > maxSize) {
			        Swal.fire({
			            icon: 'warning',
			            title: '용량을 확인하세요',
			            text: '3MB 이내로 등록 가능합니다.',
			        });
			        $(this).val('');
			        return false;
			    }

			    if (allowedExtensions.indexOf(fileExtension) === -1) {
			        Swal.fire({
			            icon: 'warning',
			            title: '확장자를 확인하세요',
			            text: '업로드 가능 확장자 : xlsx, docs, hwp, pdf, pptx, ppt, jpg, jpeg, png',
			        });
			        $(this).val('');
			        return false;
			    }
			});
			
			// 기존 첨부파일 중 삭제 대상만 배열에 담아 삭제
			var boardNo = $('[name="boardNo"]').val();
			var filesToDelete = [];
			var requestData = {
			        boardNo: boardNo,
			        filesToDelete: filesToDelete
			    };
			
			$('.deleteAttached').click(function(){
				Swal.fire({
                    title: '경고',
                    text: "파일을 삭제하시겠습니까?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
						var attachedFile = $(this).closest('.attachedFile');
						var fileNo = attachedFile.find('.fileToDelete').val();
			            attachedFile.remove();
			            filesToDelete.push(fileNo); // 삭제할 파일만 배열에 넣기
			            //debugger;
					}
				})
			});
			
			// 수정버튼 누르면 삭제 파일이 있는경우 먼저처리
			$('#submitBtn').click(function(){
				if (filesToDelete.length > 0) {
					$.ajax({
						type: 'POST',
						url: '${pageContext.request.contextPath}/board/deleteFilesAndModify', // 서버 URL
						data: JSON.stringify(requestData),
						contentType: 'application/json',
						success: function(response) {
							$('#modifyForm').submit();
						},
						error: function(error) {
							console.log('삭제실패');
						}
					});
				} else {
			        $('#modifyForm').submit();
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
    	.btn-outline-primary {
		  color: gray;
		  border-color: gray;
		  background: transparent;
		}
    	.btn-outline-primary:hover {
		  color: white;
		  background-color: gray;
		  border-color: darkgray;
		  box-shadow: 0 0.125rem 0.25rem 0 rgba(105, 108, 255, 0.4);
		  transform: translateY(-1px);
		}
    </style>
</head>
<body>
	<c:set value="${board}" var="b"></c:set>
	<c:set value="${boardFile}" var="bf"></c:set>
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
						<!-- Dashboard -->
						<c:choose>
							<c:when test="${board.boardCatCd=='00'}">
								<li class="menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="boardCatCd" value="00" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">공지사항</div>
							</button>
						</li>
						<c:choose>
							<c:when test="${board.boardCatCd=='99'}">
								<li class="menu-item active">
							</c:when>
							<c:otherwise>
								<li class="menu-item">
							</c:otherwise>
						</c:choose>
							<button type="submit" name="boardCatCd" value="99" class="menu-link">
								<i class='bx bx-clipboard'></i>
								<div data-i18n="Analytics">전체 게시판</div>
							</button>
						</li>
						<!-- 사용자 관리자 메뉴 구분 -->
						<c:choose>
							<c:when test="${userId != 'admin'}">
								<c:choose>
									<c:when test="${board.boardCatCd != '00' && board.boardCatCd != '99'}">
										<li class="menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-item">
									</c:otherwise>
								</c:choose>
									<button type="submit" name="boardCatCd" value="${userDept.deptCd}" class="menu-link">
										<i class='bx bx-clipboard'></i>
										<div data-i18n="Analytics">${userDept.deptNm} 게시판</div>
									</button>
								</li>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${board.boardCatCd != '00' && board.boardCatCd != '99'}">
										<li class="menu-item active">
									</c:when>
									<c:otherwise>
										<li class="menu-item">
									</c:otherwise>
								</c:choose>
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
										<h3 class="mb-0"><strong>게시글 수정</strong></h3>
									</div>
									<!-- 구분선 -->
									<hr class="m-0">
      						    	<div class="card-body">
					                    <form action="${pageContext.request.contextPath}/board/modifyBoard" method="post" enctype="multipart/form-data" id="modifyForm">
				                        	<!-- 게시판 선택 -->
					                        <div class="mb-3">
				                           		<c:choose>
				                           			<c:when test="${userId == 'admin'}">
				                           				<select name="boardCatCd" class="form-select">
								                        	<option value="00" selected="selected">공지 게시판</option>
								                        </select>
				                           			</c:when>
				                           			<c:otherwise>
				                           				<c:choose>
				                           					<c:when test="${b.boardCatCd == '99'}">
								                                <select name="boardCatCd" class="form-select">
										                        	<option value="99" selected="selected">전체 게시판</option>
										                        	<option value="${userDept.deptCd}">${userDept.deptNm} 게시판</option>
										                        </select>
				                           					</c:when>
				                           					<c:otherwise>
								                                <select name="boardCatCd" class="form-select">
										                        	<option value="99">전체게시판</option>
										                        	<option value="${userDept.deptCd}" selected="selected">${userDept.deptNm} 게시판</option>
										                        </select>
				                           					</c:otherwise>
				                           				</c:choose>
				                           			</c:otherwise>
				                           		</c:choose>
					                        </div>
					                        <!-- 제목 입력 -->
							                <div class="mb-3">
								                <input type="hidden" name="boardNo" value="${b.boardNo}">
								                <input type="text" name="boardTitle" value="${b.boardTitle}" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>
							                </div>
							                <!-- 내용 입력 -->
                     						<div class="mb-1">
                     							<!-- 네이버 에디터 -->
												<textarea name="boardContents"
														  class="form-control"
														  id="editor"
														  placeholder="내용을 입력하세요"
														  maxlength="2500" 
														  style="
														  	height: 380px;
														  	width: 100%"
							                         	  >${b.boardContents}</textarea>
												<script type="text/javascript">
											        var oEditors = [];
											        nhn.husky.EZCreator.createInIFrame({
											            oAppRef: oEditors,
											            elPlaceHolder: "editor",
											            sSkinURI: "${pageContext.request.contextPath}/smartEditor/SmartEditor2Skin.html",
											            fCreator: "createSEditor2",
											            htParams: {
											            	bUseToolbar : true,
											            	bUseVerticalResizer: false,
											            	bUseModeChanger: false
											            }
											        });
											        
											        function submitContents(){
											        	oEditors.getById["editor"].exec("UPDATE_CONTENTS_FIELD",[]);
											        }
											    </script>
               							  	</div>
               							  	<!-- 첨부 파일 -->
							                <div class="mb-1">
							                	<c:forEach items="${boardFile}" var="bf">
						                			<div class="attachedFile boardFiles">
														<input type="hidden" class="fileToDelete" name="boardFileNo" value="${bf.boardFileNo}">
						                				${bf.originFilename}
						                				<button type="button" class="btn btn-icon btn-primary deleteAttached" style="height: 20px; width: 20px;">
						                					<i class='bx bx-checkbox-minus'></i>
						                				</button>
						                			</div>
						             		   	</c:forEach>
					                			<br>
							     	           	<div id="files">
							                		<input class="form-control boardFiles" type="file" name="multipartFile"><br>
							                	</div>
							                </div>
							                <div class="mb-3">
							                	<div style="float: left;">
								                	<button type="button" class="btn btn-icon btn-primary" id="addFile"><i class='bx bxs-file-plus'></i></button>
													<button type="button" class="btn btn-icon btn-primary" id="removeFile"><i class='bx bxs-x-square'></i></button>
							                	</div>
							                	<div style="float: right;">
													<a class="btn btn-outline-primary" style="margin-right: 5px;" href="${pageContext.request.contextPath}/board/boardOne?boardNo=${b.boardNo}">취소</a>
													<button type="button" class="btn btn-primary" style="float: right;" onclick="submitContents()" id="submitBtn">수정</button>
							                	</div>
							                </div>
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