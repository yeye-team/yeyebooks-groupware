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
<html
  lang="en"
  class="light-style layout-menu-fixed"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="${pageContext.request.contextPath}/assets/"
  data-template="vertical-menu-template-free"
>
<head>
	<title>휴가 신청</title>
	
    <jsp:include page="inc/head.jsp"></jsp:include>
    
    <script>
		$(document).ready(function() {
			
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
						<img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png" style="width:100%">
					</a>
				</div>
	
				<div class="menu-inner-shadow"></div>
				
				<ul class="menu-inner py-1">
					<li class="menu-item" onclick="location.href='${pageContext.request.contextPath}/vacationList'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청 내역
						</button>
					</li>
					<li class="menu-item active" onclick="location.href='${pageContext.request.contextPath}/addVacation'">
						<button class="menu-link">
							<i class='menu-icon tf-icons bx bxl-telegram'></i>
							휴가 신청
						</button>
					</li>
				</ul>
	        </aside>
	        <!-- / Menu -->
			
			<!-- 입력 레이아웃 -->
			<div class="layout-page">
	        	<jsp:include page="inc/navbar.jsp"></jsp:include>
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
				                           		<c:choose>
				                           			<c:when test="${userId == 'admin'}">
				                           				<select name="boardCatCd" class="form-select">
								                        	<option value="00" selected="selected">공지 게시판</option>
								                        </select>
				                           			</c:when>
				                           			<c:otherwise>
				                           				<c:choose>
				                           					<c:when test="${boardCatCd == '99'}">
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
								                <input type="hidden" name="userId" value="${userId}">
								                <input type="text" name="boardTitle" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>
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
							                         	  ></textarea>
												<script type="text/javascript">
											        var oEditors = [];
											        nhn.husky.EZCreator.createInIFrame({
											            oAppRef: oEditors,
											            elPlaceHolder: "editor",
											            sSkinURI: "${pageContext.request.contextPath}/smartEditor/SmartEditor2Skin.html",  // 스킨 경로
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
							                	<div id="files">
							                		<input class="form-control boardFiles" type="file" name="multipartFile"><br>
							                	</div>
							                </div>
							                <div>
							                	<button type="button" class="btn btn-icon btn-primary" id="addFile"><i class='bx bxs-file-plus'></i></button>
												<button type="button" class="btn btn-icon btn-primary" id="removeFile"><i class='bx bxs-x-square'></i></button>
												<button type="submit" class="btn btn-primary" style="float: right;" onclick="submitContents()" id="submitBtn">등록</button>
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