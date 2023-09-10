<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addApproval</title>
<jsp:include page="../inc/head.jsp"></jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- SweetAlert2 추가 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/smartEditor/js/HuskyEZCreator.js"></script>
<script>
    $(document).ready(function(){
        // 파일 개수 3개제한
        $('#addFile').click(function(){
            if ($('.approvalFiles').length >= 3) {
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '최대 3개의 파일만 첨부할 수 있습니다.',
                });
            } else if ($('.approvalFiles').last().val() == ''){
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '빈 파일 업로드가 있습니다.',
                });
            } else {
                var newInput = $('<input class="form-control approvalFiles" type="file" name="multipartFile"><br>');
                $('#files').append(newInput);
            }
        });
        
        $('#removeFile').click(function(){
            var visibleFiles = $('.approvalFiles:visible');
            if (visibleFiles.length === 1) {
                if (visibleFiles.val() !== "") {
                    visibleFiles.val("");
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '더 이상 삭제할 파일이 없습니다.',
                    });
                }
            } else {
                visibleFiles.last().prev().remove(); // 직전의 <input>을 제거
                visibleFiles.last().remove(); // 현재 <input>을 제거
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
    });
</script>

<script>
$(document).ready(function() {
    $('#docCatCd').on('change', function() {
        var selectedValue = $(this).val();
        changeForm(selectedValue);
    });

    function changeForm(selectedValue) {
        if (selectedValue === "03") {
            $('#03').show();
            $('#01').hide();
        } else if (selectedValue === "01") {
            $('#03').hide();
            $('#01').show();
        }
    }

    
    // 최초 로딩 시 select의 값을 확인하여 초기 폼 설정
    $('#docCatCd').trigger('change');
});
//폼 데이터 전송 함수
function submitForm() {
    var selectedValue = $('#docCatCd').val();
    var formData = new FormData($('#approvalForm')[0]); // 폼 데이터를 가져오는 방식 변경

    // 폼 데이터 전송 (AJAX 예제)
    $.ajax({
        url: '/yeyebooks/approval/addApproval',
        type: 'POST',
        data: formData,
        processData: false, // 중요: 폼 데이터를 jQuery가 자동으로 처리하지 않도록 설정
        contentType: false, // 중요: 데이터 유형을 설정하지 않도록 설정
        success: function(response) {
            // 성공 시 처리
        },
        error: function(error) {
            // 오류 시 처리
        }
    });
}
</script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // acntCreditCd 선택 변경 이벤트 핸들러
    document.getElementById("acntCreditCd").addEventListener("change", function() {
        var selectedValue = this.value;
        var acntAmountInput = document.getElementById("acntAmount");

        // 선택한 구분에 따라 acntAmount 값을 변경
        if (selectedValue === "01") {
            acntAmountInput.value = "";
        } else if (selectedValue === "02") {
            // 법인일 때는 원하는 값으로 설정합니다.
            acntAmountInput.value = ""; 
        }
    });
});
</script>

<script>
    // 문서가 완전히 로드된 후에 스크립트 실행
    $(document).ready(function() {
        let selectedCheckbox = null; // 선택된 체크박스를 추적하는 변수

        // 체크박스 클릭 이벤트
        $('.userCheckbox').click(function() {
            // 다른 체크박스 선택 해제
            $('.userCheckbox').not(this).prop('checked', false);

            // 클릭한 체크박스 선택
            $(this).prop('checked', true);

            selectedCheckbox = this; // 선택된 체크박스 저장
        });

        // 오른쪽 화살표 첫번째 버튼 동작 구현
        $('#rightArrowButtonFirst').click(function() {
            if (selectedCheckbox !== null) {
                const memberIdInputFirst = $('.memberIdInputFirst');
                const memberNameInputFirst = $('.memberNameInputFirst');
                const memberId = $(selectedCheckbox).val();
                const memberName = $(selectedCheckbox).data('username');

                memberIdInputFirst.val(memberId);
                memberNameInputFirst.val(memberName);
            }
        });

        // 오른쪽 화살표 두번째 버튼 동작 구현
        $('#rightArrowButtonSecond').click(function() {
            if (selectedCheckbox !== null) {
                const memberIdInputSecond = $('.memberIdInputSecond');
                const memberNameInputSecond = $('.memberNameInputSecond');
                const memberId = $(selectedCheckbox).val();
                const memberName = $(selectedCheckbox).data('username');

                memberIdInputSecond.val(memberId);
                memberNameInputSecond.val(memberName);
            }
        });

        // 오른쪽 화살표 세번째 버튼 동작 구현
        $('#rightArrowButtonThird').click(function() {
            if (selectedCheckbox !== null) {
                const memberIdInputThird = $('.memberIdInputThird');
                const memberNameInputThird = $('.memberNameInputThird');
                const memberId = $(selectedCheckbox).val();
                const memberName = $(selectedCheckbox).data('username');

                memberIdInputThird.val(memberId);
                memberNameInputThird.val(memberName);
            }
        });
    });
    

</script>

<script>
	let approvalLine = [];
    $(document).ready(function() {
        let selectedUsers = []; // 선택된 사용자 정보를 저장하는 배열

        // 체크박스 클릭 이벤트
        $('.userCheckbox').click(function() {
            // 다른 체크박스 선택 해제
            $('.userCheckbox').not(this).prop('checked', false);

            if ($(this).prop('checked')) {
                const memberId = $(this).val();
                const memberName = $(this).data('username');

                // 선택된 사용자 정보를 배열에 추가
                selectedUsers.push({ memberId, memberName });
            } else {
                // 선택 해제된 경우 배열에서 제거
                const memberId = $(this).val();
                const indexToRemove = selectedUsers.findIndex(user => user.memberId === memberId);
                if (indexToRemove !== -1) {
                    selectedUsers.splice(indexToRemove, 1);
                }
            }
        });


        // 모달 추가 버튼 클릭 시
        $('.modalAddUserToDeptBtn').click(function() {
            // 선택된 사용자 정보를 확인하기 위해 콘솔에 출력
            console.log(selectedUsers);

            // 선택된 사용자 정보를 HTML 요소에 표시
            displaySelectedApprovers(selectedUsers);

            // 선택된 사용자 정보 배열 초기화
            selectedUsers = [];

            // 모달을 닫습니다.
            $('#modal2').modal('hide');
        });

        // 선택된 결재자 정보를 HTML 요소에 표시하는 함수
        function displaySelectedApprovers(users) {
            const firstApproverName = $('#firstApproverName');
            const secondApproverName = $('#secondApproverName');
            const thirdApproverName = $('#thirdApproverName');
            
            const firstApproveId = $('input[name="approvalLine"]').eq(0);
            const secondApproveId = $('input[name="approvalLine"]').eq(1);
            const thirdApproveId = $('input[name="approvalLine"]').eq(2);
            
            if (users.length >= 1) {
                firstApproverName.text(users[0].memberName);
                firstApproveId.val(users[0].memberId);
                approvalLine.push(users[0].memberId);
            } else {
                firstApproverName.text("");
            }

            if (users.length >= 2) {
                secondApproverName.text(users[1].memberName);
                secondApproveId.val(users[1].memberId);
                approvalLine.push(users[1].memberId);
            } else {
                secondApproverName.text("");
            }

            if (users.length >= 3) {
                thirdApproverName.text(users[2].memberName);
                thirdApproveId.val(users[2].memberId);
                approvalLine.push(users[2].memberId);
            } else {
                thirdApproverName.text("");
            }
            console.log(approvalLine);
            console.log(firstApproveId.val());
            console.log(secondApproveId.val());
            console.log(thirdApproveId.val());
        }
    });
 // 모달 닫힘 이벤트를 감지하여 선택된 값 초기화
    $('#modal2').on('hidden.bs.modal', function () {
        // 선택된 체크박스 초기화
        $('.userCheckbox').prop('checked', false);

        // 선택된 결재자 정보를 HTML 요소에 초기화
        $('#firstApproverName').text("");
        $('#secondApproverName').text("");
        $('#thirdApproverName').text("");

        // 선택된 결재자 정보를 입력한 input 요소 초기화
        $('.memberIdInputFirst').val("");
        $('.memberNameInputFirst').val("");
        $('.memberIdInputSecond').val("");
        $('.memberNameInputSecond').val("");
        $('.memberIdInputThird').val("");
        $('.memberNameInputThird').val("");

        // 선택된 사용자 정보 배열 초기화
        selectedUsers = [];
    });

</script>

<script>
//FormData 객체 생성
var formData = new FormData(document.getElementById('selectedUsers')); // #myForm은 폼의 ID입니다.

// 추가 데이터를 JavaScript 객체로 생성
var additionalData = {
    key1: 'approvalLine'
};

// 추가 데이터를 formData에 추가
$.each(additionalData, function(key, value) {
    formData.append(key, value);
});

// Ajax 요청 보내기
$.ajax({
    type: 'POST',
    url: 'addApproval',
    data: formData,
    processData: false,
    contentType: false,
    success: function(response) {
        // 성공 처리
    },
    error: function(error) {
        // 오류 처리
    }
});
</script>

<script>
document.addEventListener("DOMContentLoaded", function() {
  const toggleButtons = document.querySelectorAll(".toggle-users");

  toggleButtons.forEach(button => {
    button.addEventListener("click", () => {
      const userList = button.nextElementSibling;
      userList.style.display = userList.style.display === "none" ? "block" : "none";
    });
  });
});
</script>

<script>
    // 문서 종류 선택 변경 이벤트 핸들러
    $("#documentType").on("change", function() {
        // 선택한 문서 종류 값 가져오기
        var selectedValue = this.value;

        // doc_cat_cd 설정
        var docCatCd = (selectedValue === "expense") ? "01" : "03";

        // 폼 요소에 숨겨진 필드로 doc_cat_cd 설정
        document.getElementById("doc_cat_cd").value = docCatCd;
    });
</script>

<script>
$(document).ready(function() {
    let selectedRefUsers = []; // 선택된 참조 사용자 정보를 저장하는 배열

    // 체크박스 클릭 이벤트
    $('.selectedRefUsers').click(function() {
        const userId = $(this).data('userid');
        const userName = $(this).data('username');

        if ($(this).hasClass('selected')) {
            // 이미 선택된 경우, 배열에서 제거
            const indexToRemove = selectedRefUsers.findIndex(user => user.userId === userId);
            if (indexToRemove !== -1) {
                selectedRefUsers.splice(indexToRemove, 1);
            }
            $(this).removeClass('selected');
        } else {
            // 선택되지 않은 경우, 배열에 추가
            selectedRefUsers.push({ userId, userName });
            $(this).addClass('selected');
        }

        // 선택된 참조 사용자 정보를 표시
        displaySelectedRefUsers(selectedRefUsers);
    });

    // 선택된 참조 사용자 정보를 HTML 요소에 표시하는 함수
    function displaySelectedRefUsers(users) {
        const refList = $('#refList ul');
        refList.empty();

        users.forEach(user => {
            refList.append(`<li>${user.userName}</li>`);
        });
    });
});
</script>

</head>
<body>

    <h1>문서작성</h1>
    
            <button class='btn btn-primary modalAddUserToDeptBtn' data-bs-toggle="modal" data-bs-target="#modal2">결재선</button>
            <button class='btn btn-primary selectedRefUsers' data-bs-toggle="modal" data-bs-target="#modal2">참조</button>
		<!-- Modal -->
		<div class="modal fade" id="modal2" tabindex="-1" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="modalTitle2"></h5>
		        <button
		          type="button"
		          class="btn-close"
		          data-bs-dismiss="modal"
		          aria-label="Close"
		        ></button>
		      </div>
		      <form action="${pageContext.request.contextPath}/modifyUserDept" method="post">
		        <div class="modal-body pb-0 card" style="box-shadow: none;">
		          <div class="row card-body vertical-scroll">
		            <div class="col-lg-6" style="overflow-y: auto; height: 400px;">
		              <!-- 왼쪽 컨텐츠 내용 -->
		              <h3>부서 목록</h3>
		              <ul>
		                <!-- 부서와 사용자 목록을 나열 -->
		                <c:forEach var="uc" items="${userCnt}">
		                  <li>
		                    <label class="deptNm2 toggle-users">${uc.deptNm == null ? 'YeYeBooks' : uc.deptNm} (${uc.cnt})</label>
		                    <div class="user-list" style="display: none;">
		                      <ul>
		                        <!-- 해당 부서의 사용자 목록 -->
		                        <c:forEach var="u" items="${userList}">
		                          <c:if test="${uc.deptCd == u.deptCd}">
		                            <li>
		                              <input type="checkbox" class="userCheckbox" id="user_${u.userId}" value="${u.userId}" data-username="${u.userNm}">
		                              <label for="user_${u.userId}">
		                                <div class="col-md-3">
		                                  <c:set var="photoUrl" value="${pageContext.request.contextPath}/assets/img/avatars/default.png"></c:set>
		                                  <c:if test="${u.userImg != null}">
		                                    <c:set var="photoUrl" value="/yeyebooks/${u.userImg}"></c:set>
		                                  </c:if>
		                                  <img src="${photoUrl}" alt="Avatar" class="rounded-circle" width="100%" />
		                                </div>
		                                <div class="col-md-9">
		                                  <h5 class="mb-0">${u.userNm}</h5>
		                                  <h6><small class="text-muted">${u.rankNm}</small></h6>
		                                </div>
		                              </label>
		                            </li>
		                          </c:if>
		                        </c:forEach>
		                      </ul> 
		                    </div>
		                  </li>
		                </c:forEach>
		              </ul>
		            </div>
		            <div class="col-lg-6">
		              <!-- 오른쪽 컨텐츠 내용 -->
		              <h3>선택된 결재자</h3>
		              <form>
		                <table>
		                  <!-- 선택된 결재자 목록 -->
		                  <tr>
		                    <td rowspan="2"><button type="button" id="rightArrowButtonFirst">&rarr;</button></td>
		                    <td>첫 번째 결재자</td>
		                  </tr>
		                  <tr>
		                    <td>
		                      <input type="hidden" value="" name="memberId" class="memberIdInputFirst">
		                      <input type="text" value="" name="memberName" class="memberNameInputFirst" readonly>
		                    </td>
		                  </tr>
		                  <tr>
		                    <td rowspan="2"><button type="button" id="rightArrowButtonSecond">&rarr;</button></td>
		                    <td>두 번째 결재자</td>
		                  </tr>
		                  <tr>
		                    <td>
		                      <input type="hidden" value="" name="memberId" class="memberIdInputSecond">
		                      <input type="text" value="" name="memberName" class="memberNameInputSecond" readonly>
		                    </td>
		                  </tr>
		                  <tr>
		                    <td rowspan="2"><button type="button" id="rightArrowButtonThird">&rarr;</button></td>
		                    <td>세 번째 결재자</td>
		                  </tr>
		                  <tr>
		                    <td>
		                      <input type="hidden" value="" name="memberId" class="memberIdInputThird">
		                      <input type="text" value="" name="memberName" class="memberNameInputThird" readonly>
		                    </td>
		                  </tr>
		                </table>
		                <button type="reset">초기화</button>
		              </form>
		            </div>
		          </div>
		        </div>
		        <div class="modal-footer">
		          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
		            취소
		          </button>
		          <button type="submit" class="btn btn-secondary modalAddUserToDeptBtn">추가</button>
		        </div>
		      </form>
		    </div>
		  </div>
		</div>
		
        <form id="approvalForm" action="addApproval" method="post" enctype="multipart/form-data">

	    <!-- 선택된 결재자 정보를 저장할 hidden 필드 -->
	    <input type="hidden" name="approvalLine" value="">
		<input type="hidden" name="approvalLine" value="">
		<input type="hidden" name="approvalLine" value="">
		<!-- 선택된 결재자 정보를 표시할 HTML 요소 -->
		<div id="selectedApprovers">
		    <p>첫 번째 결재자: <span id="firstApproverName"></span></p>
		    <p>두 번째 결재자: <span id="secondApproverName"></span></p>
		    <p>세 번째 결재자: <span id="thirdApproverName"></span></p>
		</div>
		<div>
			
			
		</div>	
            <label for="docCatCd">문서 종류 선택:</label>
	        <select id="docCatCd" name="docCatCd">
	            <option value="03">일반 문서</option>
	            <option value="01">지출 결의서</option>
	        </select>
    
    		<div id="03" style="margin-top: 20px;">
    			<!-- 제목 입력 -->
                <div class="mb-3">
	                <input type="hidden" name="userId" value="${userId}">
	                <input type="text" name="aprvTitle" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>
                </div>
                <!-- 내용 입력 -->
				<div class="mb-1">
					<!-- 네이버 에디터 -->
					<textarea name="aprvContents"
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
				        
				        function addApproval(){
				        	const docCat = $('#docCatCd').val();
				        	if(docCat == '01'){
				        		submitForm();
				        	}else{
				        		submitContents();
				        	}
				        }
				    
				    </script>
			  	</div>
			</div>
			
			<div id="01" style="display: none; margin-top: 20px;">
				
			    <label>제목:</label>
				<input type="text" name="aprvTitle" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>

			    <label>지출사유:</label>
				<input type="text" name="aprvContents" maxlength="50" class="form-control" id="basic-default-company" placeholder="제목을 입력하세요" required="required"/>

			    <label for="expenseDate">지출 날짜:</label>
			    <input type="date" id="acntYmd" name="acntYmd"><br>
			    
			    <label for="expenseDescription">사용내역:</label>
			    <textarea id="acntContents" name="acntContents" rows="4" cols="50"></textarea><br>

			    <label for="expenseDate">사용처 :</label>
			    <input type="text" id="acntNm" name="acntNm"><br>
			    
			    <label for="expenseAmount">지출 금액:</label>
			    <input type="number" id="acntAmount" name="acntAmount"><br>
			    
			    <label>구분:</label>
			        <select id="acntCreditCd" name="acntCreditCd">
			            <option value="01">법인</option>
			            <option value="02">개인</option>
			        </select>
			</div>
    
        	<label for="files">첨부 파일:</label>
                <button type="button" id="addFile">추가</button>
                <button type="button" id="removeFile">삭제</button>
            <div id="files">
                <input class="form-control approvalFiles" type="file" name="multipartFile" multiple><br>
            </div>
            
            <button type="button" class='btn btn-primary' onclick="addApproval()">문서등록</button>
        </form>


	<!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="../assets/vendor/libs/jquery/jquery.js"></script>
    <script src="../assets/vendor/libs/popper/popper.js"></script>
    <script src="../assets/vendor/js/bootstrap.js"></script>
    <script src="../assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="../assets/vendor/js/menu.js"></script>
    <!-- endbuild -->

    <!-- Vendors JS -->

    <!-- Main JS -->
    <script src="../assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="../assets/js/ui-modals.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
</body>
</html>