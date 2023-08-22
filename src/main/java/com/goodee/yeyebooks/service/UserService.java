package com.goodee.yeyebooks.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.UserFileMapper;
import com.goodee.yeyebooks.mapper.UserMapper;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	@Autowired
	UserFileMapper userFileMapper;
	
	public int login(String userId, String userPw) {
		return userMapper.selectLoginInfo(userId, userPw);
	}
	public Map<String, Object> mypage(String userId) {
		Map<String, Object> userInfo = new HashMap<>();
		User user = userMapper.selectUserInfo(userId);
		List<UserFile> userFile = userFileMapper.selectUserFile(userId);
		userInfo.put("user", user);
		
		for(UserFile uf : userFile) {
			if(uf.getFileCategory().equals("사진")) {
				userInfo.put("photoFile", uf);
			}
			if(uf.getFileCategory().equals("사인")) {
				userInfo.put("signFile", uf);
			}
		}
		
		return userInfo;
	}
	public int updateUserInfoByUser(String userNm, String phoneNo, String userId) {
		User user = new User();
		user.setUserId(userId);
		user.setUserNm(userNm);
		user.setPhoneNo(phoneNo);
		return userMapper.updateUserInfoByUser(user);
	}
	public String updateUserFile(String file, String path, String userId, String fileCategory, int userFileNo) {
		byte[] decodedData = Base64.getDecoder().decode(file.split(",")[1]);
		// 이미지 파일 변환
		String filename = UUID.randomUUID().toString().replace("-", "") + ".png";
		String userFolderPath = path + userId + "/";
		String imagePath = userFolderPath + filename;
		
		try{
			// 사용자 폴더가 없는 경우 생성
			File userFolder = new File(userFolderPath);
			if(!userFolder.exists()) {
				userFolder.mkdirs();
			}
			
			FileOutputStream imageOutputStream = new FileOutputStream(imagePath);
			imageOutputStream.write(decodedData);
			imageOutputStream.close();
			
			UserFile userFile = new UserFile();
			userFile.setUserId(userId);
			userFile.setFileCategory(fileCategory);
			userFile.setSaveFilename(filename);
			userFile.setFiletype("image/png");
			userFile.setPath("empImg/" + userId + "/");
			
			if(userFileNo != 0) {
				UserFile origin = userFileMapper.selectUserFileOne(userFileNo);
				String originPath = path + userId + "/" + origin.getSaveFilename();
				File originFile = new File(originPath);
				
				if(originFile.exists()) {
					originFile.delete();
				}
				
				userFileMapper.deleteUserFile(userFileNo);
			}
			
			userFileMapper.insertUserFile(userFile);
			
			return filename;
		}catch(IOException e) {
			e.printStackTrace();
			return null;
		}
		
	}
	public int updateUserPw(String userId, String userPw) {
		return userMapper.updateUserPw(userId, userPw);
	}
}
