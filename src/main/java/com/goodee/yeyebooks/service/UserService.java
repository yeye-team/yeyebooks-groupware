package com.goodee.yeyebooks.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.yeyebooks.mapper.UserFileMapper;
import com.goodee.yeyebooks.mapper.UserMapper;
import com.goodee.yeyebooks.vo.Report;
import com.goodee.yeyebooks.vo.User;
import com.goodee.yeyebooks.vo.UserFile;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
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
	
	// 최근 6개월 입/퇴사자 수
	public Map<String, Object> selectRecentJoinLeaveCnt(){
		int[] monthList = {1,2,3,4,5,6,7,8,9,10,11,12}; 
		int startMonthIdx = (LocalDate.now().getMonthValue() + 5) % 12;
		Map<String, Object> recentJoinLeaveInfo = new HashMap<>();
		List<Integer> joinCntResult = new ArrayList<>(List.of(0, 0, 0, 0, 0, 0));
		List<Integer> leaveCntResult = new ArrayList<>(List.of(0, 0, 0, 0, 0, 0));
		List<String> monthNames = new ArrayList<>();
		List<Report> joinCnt = userMapper.selectRecentJoinCnt();
		List<Report> leaveCnt = userMapper.selectRecentLeaveCnt();
		
		for(Report joinInfo : joinCnt){
			int month = joinInfo.getMonth();
			joinCntResult.set(month-monthList[startMonthIdx], joinInfo.getCnt());
		}
		for(Report leaveInfo : leaveCnt) {
			int month = leaveInfo.getMonth();
			leaveCntResult.set(month-monthList[startMonthIdx], leaveInfo.getCnt());
		}
		for(int i = 0; i < 6; i++) {
			int nowMonthIdx = (startMonthIdx + i) % 12;
			monthNames.add(monthList[nowMonthIdx] + "월");
		}
		recentJoinLeaveInfo.put("joinCnt", joinCntResult);
		recentJoinLeaveInfo.put("leaveCnt", leaveCntResult);
		recentJoinLeaveInfo.put("monthNames", monthNames);
		
		return recentJoinLeaveInfo;
	}
	// 직원 남여 성비
	public Map<String, Object> selectFMCnt(){
		List<Report> fmResult = userMapper.selectFMCnt();
		Map<String, Object> fmCnt = new HashMap<>();
		fmCnt.put(fmResult.get(0).getGenderNm(), fmResult.get(0).getCnt());
		if(fmResult.size() > 1) {
			fmCnt.put(fmResult.get(1).getGenderNm(), fmResult.get(1).getCnt());
		}
		
		return fmCnt;
	}
	public Map<String, Object> selectRecentTotalUserCnt(){
		Map<String, Object> recentTotalUserInfo = new HashMap<>();
		List<String> yearMonthList = new ArrayList<>();
		List<Integer> totalUserCnt = new ArrayList<>();
		LocalDate today = LocalDate.now();
		for(int i = 5; i >=0; i--) {
			LocalDate targetDate = today.minusMonths(i);
			LocalDate displayDate = targetDate.minusMonths(1);
			yearMonthList.add(displayDate.getYear() + "년" + displayDate.getMonthValue() + "월");
			int targetMonthCnt = userMapper.selectTotalUserCntBeforeMonth(targetDate.getYear(), targetDate.getMonthValue());
			totalUserCnt.add(targetMonthCnt);
		}
		
		recentTotalUserInfo.put("yearMonthList", yearMonthList);
		recentTotalUserInfo.put("totalUserCnt", totalUserCnt);
		return recentTotalUserInfo;
	}
	public User selectUserInfo(String userId) {
		return userMapper.selectUserInfo(userId);
	}
}
