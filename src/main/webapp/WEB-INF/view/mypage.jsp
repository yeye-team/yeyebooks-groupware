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
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>마이페이지</title>

    <meta name="description" content="" />

   	<!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_mini.png" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    />

    <!-- Icons. Uncomment required icon fonts -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/fonts/boxicons.css" />

    <!-- Core CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

    <!-- Page CSS -->

    <!-- Helpers -->
    <script src="${pageContext.request.contextPath}/assets/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="${pageContext.request.contextPath}/assets/js/config.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  	<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
  	<style>
  		.app-brand img{
  			width: 100%;
  		}
  		#goal{
  			border-radius: 4px;
  			border: 1px solid lightgray;
  		}
  		#uploadedAvatar{
  			object-fit: cover;
  		}
  		#target{
  			border-radius: 4px;
  			border: 1px solid lightgray;
  			margin-bottom: 10px;
  		}
  		.changePwBtn{
  			margin: auto 0;
  		}
  	</style>
  	<script>
  		$(document).ready(function(){
  			
  			if(${signFile == null}){
  				$('#modalCenter').modal('show');
  			}
  			let goal = $('#goal')[0];
  			let sign = new SignaturePad(goal, {minWidth:2, maxWidth:2});
  			
  			$("#clear").click(function(){
  				sign.clear();
  			});
  			$('#send').click(function(){
  				$.ajax({
  					url: '/yeyebooks/addSign',
  					data: {
  						sign: sign.toDataURL("image/png"),
  						userId: "${user.userId}",
  						userFileNo: ${signFile != null ? signFile.userFileNo : 0}
  					},
  					type: 'post',
  					success: function(jsonData){
						// 사인 등록 성공
						$('#modalCenter').modal('hide');
						Swal.fire({
			                icon: 'success',
			                title: '사인등록 성공',
			            })
  						$("#target").attr('src', jsonData);
  					}
  				});
  			});
  			
  			let photoDataURL = null;
  			
  			$('#upload').change(function(){
  				const selectedFile = this.files[0];
  				
  				if(selectedFile){
  					const reader = new FileReader();
  					reader.onload = function(event){
  						photoDataURL = event.target.result;
  					}
  					reader.readAsDataURL(selectedFile);
  				}
  			});
  			
  			$('#saveUserInfo').click(function(){
  				const userNm = $('input[name=userNm]').val();
  				const phoneNo = $('input[name=phoneNo]').val();
  				const phonePattern = /^\d{2,3}-\d{4}-\d{4}$/;
  				const namePattern = /^(?:[a-zA-Z]|[가-힣]| ){1,30}$/;
  				
  				if(!namePattern.test(userNm)){
  					Swal.fire({
						icon: 'error',
						title: '저장실패',
						text: '올바른 형식의 이름을 입력하세요.'
					})
					return;
  				}
  				if(!phonePattern.test(phoneNo)){
  					Swal.fire({
						icon: 'error',
						title: '저장실패',
						text: '올바른 형식의 전화번호를 입력하세요.'
					})
					return;
  				}
  				$.ajax({
  					type: "POST",
  					url: "/yeyebooks/mypage",
  					data: {
  						photo: photoDataURL != null ? photoDataURL : "",
  						userId: "${user.userId}",
  						userFileNo: ${photoFile != null ? photoFile.userFileNo : 0},
  						userNm: userNm,
  						phoneNo: phoneNo
  					},
  					success: function(response){
						Swal.fire({
							icon: 'success',
							title: '수정 성공'
						})
  					}
  				})
  			})
  		})
	</script>
  </head>

  <body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <!-- Menu -->

        <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
          <div class="app-brand demo">
            <img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png">
          </div>

          <div class="menu-inner-shadow"></div>

          <ul class="menu-inner py-1">
            <!-- Dashboard -->
            <li class="menu-item active">
              <a class="menu-link">
                <i class="bx bx-user me-1"></i>
                <div data-i18n="Analytics">마이페이지</div>
              </a>
            </li>
            </ul>

           
        </aside>
        <!-- / Menu -->

        <!-- Layout container -->
        <div class="layout-page">
          <!-- Navbar -->
          <jsp:include page="./inc/navbar.jsp"></jsp:include>
          <!-- / Navbar -->

          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->

            <div class="container-xxl flex-grow-1 container-p-y">

              <div class="row">
                <div class="col-md-12">
                  <div class="card mb-4">
                    <h5 class="card-header">사원정보</h5>
                    <!-- Account -->
                    <div class="card-body">
                      <div class="d-flex align-items-start align-items-sm-center gap-4">
                      	<c:set var="photoUrl" value="${pageContext.request.contextPath}/assets/img/avatars/default.png"></c:set>
                      	<c:if test="${photoFile != null }">
                      		<c:set var="photoUrl" value="${pageContext.request.contextPath }/${photoFile.path }/${photoFile.saveFilename }"></c:set>
                      	</c:if>
                        <img
                          src="${photoUrl}"
                          alt="user-avatar"
                          class="d-block rounded"
                          height="100"
                          width="100"
                          id="uploadedAvatar"
                        />
                        <div class="button-wrapper">
                          <label for="upload" class="btn btn-primary me-2 mb-4" tabindex="0">
                            <span class="d-none d-sm-block">사진변경</span>
                            <i class="bx bx-upload d-block d-sm-none"></i>
                            <input
                              type="file"
                              id="upload"
                              class="account-file-input"
                              hidden
                              accept="image/png, image/jpeg"
                            />
                          </label>
                          <button type="button" class="btn btn-outline-secondary account-image-reset mb-4">
                            <i class="bx bx-reset d-block d-sm-none"></i>
                            <span class="d-none d-sm-block">되돌리기</span>
                          </button>

                          <p class="text-muted mb-0">JPG, PNG형식을 지원합니다.</p>
                        </div>
                      </div>
                    </div>
                    <hr class="my-0" />
                    <div class="card-body">
                      
                        <div class="row">
                        <div class="mb-3 col-md-6">
                            <label for="userId" class="form-label">사원번호</label>
                            <input
                              class="form-control"
                              type="text"
                              id="userId"
                              name="userId"
                              value="${user.userId }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6 changePwBtn">
                          	<form action="/yeyebooks/changePw" method="post">
                          		<input type="hidden" name="userId" value="${user.userId }"> 
                          		<button type="submit" class="btn btn-primary" id="changePw">비밀번호변경</button>
                          	</form>
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="userNm" class="form-label">이름 (영문/한글 최대30자)</label>
                            <input
                              class="form-control"
                              type="text"
                              id="userNm"
                              name="userNm"
                              value="${user.userNm }"
                              autofocus
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="mail" class="form-label">E-mail</label>
                            <input
                              class="form-control"
                              type="text"
                              id="mail"
                              name="mail"
                              value="${user.mail }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="dept" class="form-label">부서</label>
                            <input
                              type="text"
                              class="form-control"
                              id="dept"
                              name="dept"
                              value="${user.dept }"
                              readonly
                            />
                          </div>
                           <div class="mb-3 col-md-6">
                            <label for="rank" class="form-label">직책</label>
                            <input type="text" class="form-control" id="rank" name="rank" value="${user.rank }" readonly/>
                          </div>
                          <div class="mb-3 col-md-6">
                            <label class="form-label" for="phoneNo">전화번호 (010-????-???? 형식)</label>
                            <div class="input-group input-group-merge">
                              <input
                                type="text"
                                id="phoneNo"
                                name="phoneNo"
                                class="form-control"
                                value="${user.phoneNo }"
                              />
                            </div>
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="userStatus" class="form-label">재직상태</label>
                            <input
                              type="text"
                              class="form-control"
                              id="userStatus"
                              name="userStatus"
                              value="${user.userStatus }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label class="form-label" for="gender">성별</label>
                            <input
                              type="text"
                              class="form-control"
                              id="gender"
                              name="gender"
                              value="${user.gender }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="dayoffCnt" class="form-label">잔여연차</label>
                             <input
                              type="text"
                              class="form-control"
                              id="dayoffCnt"
                              name="dayoffCnt"
                              value="${user.dayoffCnt }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="joinYmd" class="form-label">입사일</label>
                            <input
                              type="date"
                              class="form-control"
                              id="joinYmd"
                              name="joinYmd"
                              value="${user.joinYmd }"
                              readonly
                            />
                          </div>
                          <div class="mb-3 col-md-6">
                            <label for="leaveYmd" class="form-label">퇴사일</label>
                            <c:set var="leaveYmd" value="-"></c:set>
                            <c:if test="${user.userStatus != '재직' }">
                            	<c:set var="leaveYmd" value="${user.leaveYmd }"></c:set>
                            </c:if>
                            <input
                              type="text"
                              class="form-control"
                              id="leaveYmd"
                              name="leaveYmd"
                              value="${leaveYmd }"
                              readonly
                            />
                          </div>
                        </div>
                         <!-- Vertically Centered Modal -->
                    <div class="col-lg-4 col-md-6">
                      <label for="target" class="form-label">사인</label>
                      <div>
                      	<c:set var="signUrl" value=""></c:set>
                      	<c:if test="${signFile != null }">
                      		<c:set var="signUrl" value="${pageContext.request.contextPath }/${signFile.path }/${signFile.saveFilename }"></c:set>
                      	</c:if>
						<img id="target" src="${signUrl }">
                        <!-- Button trigger modal -->
                        <button
                          type="button"
                          class="btn btn-primary"
                          id="signModalOpen"
                          data-bs-toggle="modal"
                          data-bs-target="#modalCenter"
                        >새사인등록
                        </button>

                        <!-- Modal -->
                        <div class="modal fade" id="modalCenter" tabindex="-1" aria-hidden="true">
                          <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="modalCenterTitle">사인등록</h5>
                                <button
                                  type="button"
                                  class="btn-close"
                                  data-bs-dismiss="modal"
                                  aria-label="Close"
                                ></button>
                              </div>
                              <div class="modal-body">
                                <div class="row">
                                  <div class="col mb-3">
                                    <canvas	id="goal" width="512" height="200">
                                    </canvas>
                                  </div>
                                </div>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" id="clear">
                                 지우기
                                </button>
                                <button type="button" class="btn btn-primary" id="send">저장</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                        <div class="mt-2">
                          <button type="button" class="btn btn-primary me-2" id="saveUserInfo">저장</button>
                          <button type="reset" class="btn btn-outline-secondary" id="resetBtn">취소</button>
                        </div>
                      
                    </div>
                    <!-- /Account -->
                    
                  </div>
                  

            <div class="content-backdrop fade"></div>
          </div>
          <!-- Content wrapper -->
        </div>
        <!-- / Layout page -->
      </div>

      <!-- Overlay -->
      <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <!-- / Layout wrapper -->


    <!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/popper/popper.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="${pageContext.request.contextPath}/assets/vendor/js/menu.js"></script>
    <!-- endbuild -->

    <!-- Vendors JS -->

    <!-- Main JS -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="${pageContext.request.contextPath}/assets/js/pages-account-settings-account.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
  </body>
</html>