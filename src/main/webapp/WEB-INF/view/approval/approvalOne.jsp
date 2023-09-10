<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approvalOne</title>
<jsp:include page="../inc/head.jsp"></jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>


<script>

	function approve(){
		const signUrl = $('#approvalUserSign').val();
		console.log(signUrl);
		if(signUrl == ''){
			Swal.fire({
				icon: 'error',
				text: '사인을 먼저 등록하세요'
			}).then(function(){
				location.href="/yeyebooks/mypage";
			})
			return;
		}
		
		$.ajax({
			url: '/yeyebooks/approval/approveApproval',
			type: 'post',
			data: {
				aprvNo: "${approval.aprvNo}",
				userId: "${sessionScope.userId}",
			},
			success: function(){
				Swal.fire({
					icon: 'success',
					title: '성공',
					text: '승인처리 되었습니다.'
				}).then(function(){
					location.href="approvalList";
				})
			}
		})
	}
	// 확인 버튼 클릭 시
	function openRejectionModal() {
	  $('#modalCenter').modal('show');
	}
	function rejectConfirm(){
		var rejectReason = document.getElementById("rejectReason").value;
		var aprvNo = "${approval.aprvNo}";
		
		if(rejectReason == ''){
			Swal.fire({
				icon: 'warning',
				text: '반려사유를 입력하세요.'
			})
			return;
		}
		// AJAX 요청을 사용하여 서버로 사유를 전송
		$.ajax({
		    type: "POST",
		    url: "/yeyebooks/approval/rejectApproval",
		    data: {
		      aprvNo: aprvNo,
		      rejectReason: rejectReason
		    },
		    success: function() {
		      $('#modalCenter').modal('hide');
		      Swal.fire({
					icon: 'success',
					title: '성공',
					text: '반려처리 되었습니다.'
				}).then(function(){
					location.href="approvalList";
				})
		    },
		    error: function(error) {
		    	Swal.fire({
					icon: 'error',
					title: '실패',
					text: '오류가 발생하였습니다.'
				})
		    }
		  });
	}
</script>

<body>
	<h1>hello</h1>
	
	<table border="1">
		<tr>
			<th>문서번호</th>
			<th>문서종류</th>
			<th>제목</th>
			<th>상세내용</th>
			<th>기안자</th>
			<th>기안날짜</th>
		</tr>
		
			<tr>
				<td>${approval.aprvNo}</td>
				<td>${approval.codeName}</td>
				<td>${approval.aprvTitle}</td>
				<td>${approval.aprvContents}</td>
				<td>${approval.userName}</td>
				<td>${approval.CDate}</td>
			
			</tr>	
	</table>
	<c:forEach var="af" items="${aprvFile}">
			<a
				href="../approvalFile/${af.saveFilename}"
				download="${af.orginFilename}">
				${af.orginFilename}
			</a>
	</c:forEach>
	<table border="1">
		<tr>
			<th>결재자</th>
			<th>상태</th>
			<th>사인</th>
		</tr>
		<c:forEach var="al" items="${aprvLine}">
			<tr>
				<td>${al.userInfo}</td>
				<td>${al.aprvStat}</td>
				<c:set var="signUrl" value=""></c:set>
				<c:if test="${al.userSign != null }">
					<c:set var="signUrl" value="/yeyebooks/${al.userSign }"></c:set>
				</c:if>
				<td>
					<c:if test="${al.aprvStat == '결재완료' }">
						<img src="${signUrl}">
					</c:if>
				</td>
				<c:if test="${al.userId == approvalUser }">
					<input type="hidden" id="approvalUserSign" value="${signUrl}">
				</c:if>
			<tr>
		</c:forEach>
	</table>	
	<c:if test="${approval.docCatCd == '01'}">
		<table>
			<tr>
				<th>지출일자</th>
				<th>내용</th>
				<th>거래처명</th>
				<th>금액</th>
				<th>구분</th>	
			</tr>
			<tr>
				<td>${account.acntYmd}</td>
				<td>${account.acntContents}</td>
				<td>${account.acntNm}</td>
				<td>${account.acntAmount}</td>
				<td>${account.acntCreditCd}</td>
			</tr>
		</table>
	</c:if>
	
	<c:if test="${approval.docCatCd == '02'}">
		<table>
			<tr>
				<th>휴가대상일</th>
				<th>휴가종류</th>
			</tr>
			<tr>
				<td>${dayoff.dayoffYmd}</td>
				<td>${dayoff.dayoffTypeCd }</td>
			</tr>
		</table> 
	</c:if>
	
	<c:if test="${sessionScope.userId == approvalUser && approval.aprvStatCd == '01'}">
        <button type="button" onclick="approve()">승인</button>
        <button type="button" onclick="openRejectionModal()">반려</button>
   	</c:if>
	<!-- 반려 모달 창 -->
	
	<c:if test="${sessionScope.userId == approval.userId && approval.aprvStatCd != '04'}">
	    <button type="button" onclick="location.href='cancelApproval?aprvNo=${approval.aprvNo}'">회수</button>
	</c:if>
	<div>
		<c:if test="${approval.aprvStatCd == '03' }">
			반려사유 : ${approval.rjctReason}
		</c:if>
	</div>
	
	<div class="mt-3">
        <!-- Modal -->
        <div class="modal fade" id="modalCenter" tabindex="-1" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="modalCenterTitle">반려</h5>
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
                    <label for="rejectReason" class="form-label">반려사유</label>
                    <input
                      type="text"
                      id="rejectReason"
                      class="form-control"
                    />
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                  닫기
                </button>
                <button type="button" class="btn btn-primary" onclick="rejectConfirm()">반려</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <jsp:include page="../inc/coreJs.jsp"></jsp:include>
</body>
</html>