<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<!-- =========================================================
* Sneat - Bootstrap 5 HTML Admin Template - Pro | v1.0.0
==============================================================

* Product Page: https://themeselection.com/products/sneat-bootstrap-html-admin-template/
* Created by: ThemeSelection
* License: You must have a valid license purchased in order to legally use the theme for your project.
* Copyright ThemeSelection (https://themeselection.com)

=========================================================
 -->
<!-- beautify ignore:start -->
<html
  lang="en"
  class="light-style customizer-hide"
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

    <title>비밀번호 변경</title>

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
    <!-- Page -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/css/pages/page-auth.css" />
    <!-- Helpers -->
    <script src="${pageContext.request.contextPath}/assets/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="${pageContext.request.contextPath}/assets/js/config.js"></script>
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  	<script>
  		$(document).ready(function(){
  			$('#formChangePassword').submit(function(event){
  				event.preventDefault();
  				
  				const originPw = $('input[name=originPw]').val();
  				const userPw = $('input[name=userPw]').val();
  				const confirmPw = $('input[name=confirmPw]').val();
  				const pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{5,12}$/;
  				
  				if(!pwPattern.test(userPw)){
  					Swal.fire({
		                icon: 'error',
		                title: '비밀번호 변경 실패',
		                text: '올바른 형식의 비밀번호를 입력하세요.',
		            })
		            return;
  				}
  				
  				if(userPw != confirmPw){
					Swal.fire({
		                icon: 'error',
		                title: '비밀번호 변경 실패',
		                text: '비밀번호 확인이 일치하지 않습니다.',
		            })
		            return;
  				}
  				
  				$.ajax({
  					type: "POST",
  					url: "/yeyebooks/updatePw",
  					data: {
  						userId: "${userId}",
  						userPw: userPw,
  						originPw: originPw
  					},
  					success: function(response){
  						if(response.success){
  							// 비밀번호 변경 성공
  							Swal.fire({
  				                icon: 'success',
  				                title: '비밀번호 변경 성공',
  				                text: '변경된 비밀번호로 다시 로그인 합니다.',
  				            }).then(function(){
  				            	location.href = "/yeyebooks/logout";
  				            })
  						}else{
  							// 비밀번호 변경 실패
  							Swal.fire({
  				                icon: 'error',
  				                title: '비밀번호 변경 실패',
  				                text: '기존 비밀번호가 일치하지 않습니다.',
  				            })
  						}
  					},
  					dataType: "json"
  				})
  			})
  		});
  	</script>
  </head>

  <body>
    <!-- Content -->

    <div class="container-xxl">
      <div class="authentication-wrapper authentication-basic container-p-y">
        <div class="authentication-inner">
          <!-- Register -->
          <div class="card">
            <div class="card-body">
              <!-- Logo -->
              <div class="app-brand justify-content-center">
                <img src="${pageContext.request.contextPath}/assets/img/logo/yeyebooks_logo.png">
              </div>

              <form id="formChangePassword" class="mb-3" method="post">
                <div class="mb-3 form-password-toggle">
                  <div class="d-flex justify-content-between">
                    <label class="form-label" for="originPw">기존 비밀번호</label>
                  </div>
                  <div class="input-group input-group-merge">
                    <input
                      type="password"
                      id="originPw"
                      class="form-control"
                      name="originPw"
                      placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                      aria-describedby="password"
                      required
                      autofocus
                    />
                    <span class="input-group-text cursor-pointer"><i class="bx bx-hide"></i></span>
                  </div>
                </div>
                <div class="mb-3 form-password-toggle">
                  <div class="d-flex justify-content-between">
                    <label class="form-label" for="userPw">변경할 비밀번호(영문,숫자를 포함한 5-12자리)</label>
                  </div>
                  <div class="input-group input-group-merge">
                    <input
                      type="password"
                      id="userPw"
                      class="form-control"
                      name="userPw"
                      placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                      aria-describedby="password"
                      required
                    />
                    <span class="input-group-text cursor-pointer"><i class="bx bx-hide"></i></span>
                  </div>
                </div>
                <div class="mb-3 form-password-toggle">
                  <div class="d-flex justify-content-between">
                    <label class="form-label" for="confirmPw">비밀번호 확인</label>
                  </div>
                  <div class="input-group input-group-merge">
                    <input
                      type="password"
                      id="confirmPw"
                      class="form-control"
                      name="confirmPw"
                      placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                      aria-describedby="password"
                      required
                    />
                    <span class="input-group-text cursor-pointer"><i class="bx bx-hide"></i></span>
                  </div>
                </div>
                <div class="mb-3">
                  <button class="btn btn-primary d-grid w-100" type="submit">비밀번호 변경</button>
                </div>
              </form>
            </div>
          </div>
          <!-- /Register -->
        </div>
      </div>
    </div>

    <!-- / Content -->
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

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
  </body>
</html>
