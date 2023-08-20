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
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/signature_pad/1.5.3/signature_pad.min.js"></script>
  	<style>
  		.app-brand img{
  			width: 100%;
  		}
  		#goal{
  			position: relative;
  			width: 100%;
  			height: 100%;
  			border-radius: 4px;
  			border: 1px solid lightgray;
  		}
  	</style>
  	<script>
  		$(document).ready(function(){
  			let goal = $('#goal')[0];
  			let sign = new SignaturePad(goal, {minWidth: 2, maxWidth: 2, penColor:'#333333', velocityFilterWeight: 0.7});
  		    
  			goal.addEventListener('mousedown', function(event) {
  			    var canvasRect = goal.getBoundingClientRect();
  			    var mouseX = event.clientX - canvasRect.left;
  			    var mouseY = event.clientY - canvasRect.top;
  			    
  			    // 변환된 마우스 좌표를 사용하여 캔버스에 서명 그리기
  			    sign.penDown(mouseX, mouseY);
  			});

  			goal.addEventListener('mousemove', function(event) {
  			    var canvasRect = goal.getBoundingClientRect();
  			    var mouseX = event.clientX - canvasRect.left;
  			    var mouseY = event.clientY - canvasRect.top;
  			    
  			    // 변환된 마우스 좌표를 사용하여 캔버스에 서명 그리기
  			    sign.penMoveTo(mouseX, mouseY);
  			});

  			goal.addEventListener('mouseup', function(event) {
  			    // 마우스 버튼이 떼어질 때 서명 그리기 종료
  			    sign.penUp();
  			});
  			
  			$("#clear").click(function(){
  				sign.clear();
  			});
  			$("#save").click(function(){
  				if(sign.isEmpty()){
  					alert("내용이 없습니다");
  				}else{
  					let data = sign.toDataURL("image/png");
  					$("#target").attr('src', data);
  				}
  			});
  			$('#send').click(function(){
  				$.ajax({
  					url: '/addSign',
  					data: {
  						sign: sign.toDataURL("image/png"),
  						id: 2
  					},
  					type: 'post',
  					success: function(jsonData){
  						alert("이미지 전송 성공");
  						$("#target").attr('src', jsonData);
  					}
  				});
  			});
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

          <nav
            class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
            id="layout-navbar"
          >
            <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
              <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
                <i class="bx bx-menu bx-sm"></i>
              </a>
            </div>

            <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
              <!-- Search -->
              <div class="navbar-nav align-items-center">
                <div class="nav-item d-flex align-items-center">
                  <i class="bx bx-search fs-4 lh-0"></i>
                  <input
                    type="text"
                    class="form-control border-0 shadow-none"
                    placeholder="Search..."
                    aria-label="Search..."
                  />
                </div>
              </div>
              <!-- /Search -->

              <ul class="navbar-nav flex-row align-items-center ms-auto">
                <!-- Place this tag where you want the button to render. -->
                <li class="nav-item lh-1 me-3">
                  <a
                    class="github-button"
                    href="https://github.com/themeselection/sneat-html-admin-template-free"
                    data-icon="octicon-star"
                    data-size="large"
                    data-show-count="true"
                    aria-label="Star themeselection/sneat-html-admin-template-free on GitHub"
                    >Star</a
                  >
                </li>

                <!-- User -->
                <li class="nav-item navbar-dropdown dropdown-user dropdown">
                  <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
                    <div class="avatar avatar-online">
                      <img src="${pageContext.request.contextPath}/assets/img/avatars/1.png" alt class="w-px-40 h-auto rounded-circle" />
                    </div>
                  </a>
                  <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                      <a class="dropdown-item" href="#">
                        <div class="d-flex">
                          <div class="flex-shrink-0 me-3">
                            <div class="avatar avatar-online">
                              <img src="${pageContext.request.contextPath}/assets/img/avatars/1.png" alt class="w-px-40 h-auto rounded-circle" />
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
          </nav>

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
                    <form id="formAccountSettings" method="POST" onsubmit="return false">
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
                            <label for="userNm" class="form-label">이름</label>
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
                            <label class="form-label" for="phoneNo">전화번호</label>
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
                      <div class="mt-3">
                      	
						<img id="target" src="">
                        <!-- Button trigger modal -->
                        <button
                          type="button"
                          class="btn btn-primary"
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
                                    <canvas	id="goal">
                                    </canvas>
                                  </div>
                                </div>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" id="clear">
                                 지우기
                                </button>
                                <button type="button" class="btn btn-primary">Save changes</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                        <div class="mt-2">
                          <button type="submit" class="btn btn-primary me-2">저장</button>
                          <button type="reset" class="btn btn-outline-secondary">취소</button>
                        </div>
                      
                    </div>
                    </form>
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