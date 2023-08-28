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
	
	<title>Home</title>
	
	<jsp:include page="./inc/head.jsp"></jsp:include>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<style>
		.card-header, .card-header a{
  			color: #666;
			font-weight: bold;
			transition: all 0.2s linear;
  		}
	</style>
</head>
<body>
	<!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar layout-without-menu">
      <div class="layout-container">

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
							<div class="col-lg">
								<div class="card mb-4">
									<h5 class="card-header">
										최근 6개월간 입/퇴사자 수
									</h5>
									<div class="card-body">
										<canvas id="joinLeaveChart"></canvas>
									</div>
								</div>
								<div class="card mb-4">
									<h5 class="card-header">
										최근 6개월간 사원 수
									</h5>
									<div class="card-body">
										<canvas id="joinLeaveChart"></canvas>
									</div>
								</div>
							</div>
							<div class="col-lg">
								<div class="card mb-4">
									<h5 class="card-header">
										직원 남/여 성비
									</h5>
									<div class="card-body">
										<canvas id="fmChart"></canvas>
									</div>
								</div>
								
							</div>
						</div>
					</div>
				</div>
				<!-- Overlay -->
		    	<div class="layout-overlay layout-menu-toggle"></div>
			</div>
		</div>
	</div>
	<script>
		const monthNames = [<c:forEach var="month" items="${monthNames}">'${month}',</c:forEach>]
	 	
		
		const joinLeaveData = {
				  labels: monthNames,
				  datasets: [{
				    type: 'bar',
				    label: '입사자수',
				    data: ${joinCnt},
				    borderColor: 'rgb(255, 99, 132)',
				    backgroundColor: 'rgba(255, 99, 132, 0.2)'
				  }, {
				    type: 'bar',
				    label: '퇴사자수',
				    data: ${leaveCnt},
				    fill: false,
				    borderColor: 'rgb(54, 162, 235)'
				  }]
			};
		const fmData = {
				labels: ['남자', '여자'],
				datasets: [{
				    label: '직원 남/여 성비',
				    data: [${mCnt}, ${fCnt}],
				    backgroundColor: [
				    	'rgb(54, 162, 235)',
				      	'rgb(255, 99, 132)'
				    ]
				  }]
		}
		const joinLeaveCtx = document.getElementById('joinLeaveChart').getContext('2d');
		const joinLeaveChart = new Chart(joinLeaveCtx, {
			type: 'bar',
			  data: joinLeaveData,
			  options: {
			    scales: {
			    	y : {
			    		max: 10	
			    	},
			    }
			}
		})
		const fmCtx = document.getElementById('fmChart').getContext('2d');
		const fmChart = new Chart(fmCtx, {
			type: 'doughnut',
			data: fmData,
		})
	</script>
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