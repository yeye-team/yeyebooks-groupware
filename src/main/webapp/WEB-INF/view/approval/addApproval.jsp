<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addApproval</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11">
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
</script>

<script>
    $(document).ready(function() {
        var selectedApprovers = []; // 선택한 결재자 목록을 저장할 배열

        $('#addApprover').click(function() {
            var selectedUserId = $('#approverSelect').val();
            var selectedUserName = $('#approverSelect option:selected').text();

            if (selectedUserId && !selectedApprovers.some(approver => approver.user_id === selectedUserId)) {
                selectedApprovers.push({ user_id: selectedUserId, user_nm: selectedUserName });
                updateApproverList();
            }
        });

        function updateApproverList() {
            $('#approverList ul').empty();
            $.each(selectedApprovers, function(index, approver) {
                var listItem = '<li>' + approver.user_nm +
                               '<input type="hidden" name="approvalLine" value="' + approver.user_id + '">' +
                               '<button type="button" class="removeApprover">제거</button></li>';
                $('#approverList ul').append(listItem);
            });
        }

        // 동적으로 추가된 결재자 목록에서 결재자 제거 기능
        $(document).on('click', '.removeApprover', function() {
            var userIdToRemove = $(this).siblings('input[name="approvalLine"]').val();
            selectedApprovers = selectedApprovers.filter(approver => approver.user_id !== userIdToRemove);
            updateApproverList();
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
            
            <button type="button" id="addApprovalList">결재자 선택</button>
			            
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
</body>
</html>