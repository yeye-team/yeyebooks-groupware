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
        $('#documentType').on('change', function() {
            var selectedValue = $(this).val();
            changeForm(selectedValue);
        });

        function changeForm(selectedValue) {
            if (selectedValue === "normal") {
                $('#normalForm').show();
                $('#expenseForm').hide();
            } else if (selectedValue === "expense") {
                $('#normalForm').hide();
                $('#expenseForm').show();
            }
        }

        // 최초 로딩 시 select의 값을 확인하여 초기 폼 설정
        $('#documentType').trigger('change');
    });
    
    
    
    /* $('#open').click(function() {
    	console.log("버튼이 클릭되었습니다");
    	$('.modal').fadeIn();
    });
    $('#close').click(function() {
    	$('.modal').fadeOut();
    });
    $('.modal').click(function() {
    	$('.modal').fadeOut();
    });
    $('.modal_content').click(function(event) {
    	event.stopPropagation(); // 이벤트 전파 중단
    });
 */
    // ul li 숨기고 보이는 기능  ------------------------------------
    $('.toggle-link').click(function(e) {
    	e.preventDefault();

    	// 클릭한 요소의 하위 ul 요소를 활성화/비활성화합니다.
    	$(this).next('ul').toggleClass('active');

    	// 아이콘 방향을 변경합니다.
    	$(this).toggleClass('active');
    });

    // 체크박스 관련 기능
    let selectedCheckbox = null; // 선택된 체크박스를 추적하는 변수

    // 체크박스 클릭 이벤트
    $('.member-checkbox').click(function() {
    	// 다른 체크박스 선택 해제
    	$('.member-checkbox').not(this).prop('checked', false);

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
            const memberName = $(selectedCheckbox).parent().text().trim();
            
            // user 객체 찾기
            const selectedUser = userList.find(user => user.userId === memberId);
            
            memberIdInputFirst.val(selectedUser.userId);
            memberNameInputFirst.val(selectedUser.userNm);
        }
    });

    // 오른쪽 화살표 두번째 버튼 동작 구현
    $('#rightArrowButtonSecond').click(function() {
        if (selectedCheckbox !== null) {
            const memberIdInputSecond = $('.memberIdInputSecond');
            const memberNameInputSecond = $('.memberNameInputSecond');
            const memberId = $(selectedCheckbox).val();
            const memberName = $(selectedCheckbox).parent().text().trim();
            
            // user 객체 찾기
            const selectedUser = userList.find(user => user.userId === memberId);
            
            memberIdInputSecond.val(selectedUser.userId);
            memberNameInputSecond.val(selectedUser.userNm);
        }
    });

    // 오른쪽 화살표 세번째 버튼 동작 구현
    $('#rightArrowButtonThird').click(function() {
        if (selectedCheckbox !== null) {
            const memberIdInputThird = $('.memberIdInputThird');
            const memberNameInputThird = $('.memberNameInputThird');
            const memberId = $(selectedCheckbox).val();
            const memberName = $(selectedCheckbox).parent().text().trim();
            
            // user 객체 찾기
            const selectedUser = userList.find(user => user.userId === memberId);
            
            memberIdInputThird.val(selectedUser.userId);
            memberNameInputThird.val(selectedUser.userNm);
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

</head>
<body>

    <h1>문서작성</h1>
        <form action="${pageContext.request.contextPath}/approval/addApproval" method="post" enctype="multipart/form-data">
            <label for="aprvTitle">문서 제목:</label>
            <input type="text" id="aprvTitle" name="aprc_title" required><br>
    
            <label for="aprvContents">문서 내용:</label><br>
            <textarea id="aprvContents" name="aprv_contents" rows="4" cols="50" required></textarea><br>
    
            <label for="files">첨부 파일:</label>
                <button type="button" id="addFile">추가</button>
                <button type="button" id="removeFile">삭제</button>
            <div id="files">
                <input class="form-control approvalFiles" type="file" name="multipartFile" multiple><br>
            </div>
              
			
            <label for="documentType">문서 종류 선택:</label>
	        <select id="documentType" name="documentType">
	            <option value="normal">일반 문서</option>
	            <option value="expense">지출 결의서</option>
	        </select>
    
    		<div id="normalForm" style="margin-top: 20px;">
			    <label for="normalField1">일반 문서 필드 1:</label>
			    <input type="text" id="normalField1" name="normalField1"><br>
			    
			    <label for="normalField2">일반 문서 필드 2:</label>
			    <textarea id="normalField2" name="normalField2" rows="4" cols="50"></textarea><br>
			</div>
			
			<div id="expenseForm" style="display: none; margin-top: 20px;">
			    <label for="expenseDate">지출 날짜:</label>
			    <input type="date" id="expenseDate" name="expenseDate"><br>
			    
			    <label for="expenseAmount">지출 금액:</label>
			    <input type="number" id="expenseAmount" name="expenseAmount"><br>
			    
			    <label for="expenseDescription">지출 내용:</label>
			    <textarea id="expenseDescription" name="expenseDescription" rows="4" cols="50"></textarea><br>
			</div>
    
            <input type="submit" value="문서 작성">
        </form>
        <button class='btn btn-primary modalAddUserToDeptBtn' data-bs-toggle="modal" data-bs-target="#modal2">결재선</button>
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
                              <input type="checkbox" class="userCheckbox" id="user_${u.userId}" value="${u.userId}">
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
                <button id="close" type="button">선택완료</button>
                <button type="reset">초기화</button>
              </form>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
            취소
          </button>
          <button type="submit" class="btn btn-secondary">추가</button>
        </div>
      </form>
    </div>
  </div>
</div>

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