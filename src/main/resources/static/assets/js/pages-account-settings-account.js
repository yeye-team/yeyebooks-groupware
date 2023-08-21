/**
 * Account Settings - Account
 */

'use strict';

document.addEventListener('DOMContentLoaded', function (e) {
  (function () {
    const deactivateAcc = document.querySelector('#formAccountDeactivation');

    // Update/reset user image of account page
    let accountUserImage = document.getElementById('uploadedAvatar');
    
    const fileInput = document.querySelector('.account-file-input'),
      resetFileInput = document.querySelector('.account-image-reset'),
      resetBtn = document.querySelector('#resetBtn');

    if (accountUserImage) {
      const resetImage = accountUserImage.src;
      fileInput.onchange = () => {
        if (fileInput.files[0]) {
			if(fileInput.files[0].type != "image/png" && fileInput.files[0].type != "image/jpg"){
				Swal.fire({
	                icon: 'error',
	                title: '등록실패',
	                text: '올바른 형식의 파일을 등록해주세요.',
	            })
				return;
			}
          accountUserImage.src = window.URL.createObjectURL(fileInput.files[0]);
        }
      };
      resetFileInput.onclick = () => {
        fileInput.value = '';
        accountUserImage.src = resetImage;
      };
      resetBtn.onclick = () => {
		fileInput.value = '';
        accountUserImage.src = resetImage;
	  }
    }
  })();
});
