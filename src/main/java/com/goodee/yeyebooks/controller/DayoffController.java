package com.goodee.yeyebooks.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.goodee.yeyebooks.service.DayoffService;
import com.goodee.yeyebooks.vo.Holiday;

@Controller
public class DayoffController {
	@Autowired
	DayoffService dayoffService;
	
	@GetMapping("/test")
	public String apiTest(Model model) throws Exception {
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=4VgUWnIlEkdnVe146v%2F%2Ba%2FlfOFm8lxd351nMT0LYt1HiiuhfCctnmM3TZ%2BhLsogtM4H7sIPUxj4%2FJ8Sa1jJJkQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("solYear","UTF-8") + "=" + URLEncoder.encode("2023", "UTF-8")); /*연*/
        //urlBuilder.append("&" + URLEncoder.encode("solMonth","UTF-8") + "=" + URLEncoder.encode("09", "UTF-8")); /*월*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("100", "UTF-8")); /*연*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(new InputSource(new StringReader(sb.toString())));
        NodeList dateNameList = document.getElementsByTagName("dateName");
        NodeList isHolidayList = document.getElementsByTagName("isHoliday");
        NodeList locdateList = document.getElementsByTagName("locdate");
        List<Holiday> list = new ArrayList<>();
        
        for(int i=0; i < dateNameList.getLength(); i++) {
        	Holiday h = new Holiday();
        	Node n1 = dateNameList.item(i).getChildNodes().item(0);
        	Node n2 = isHolidayList.item(i).getChildNodes().item(0);
        	Node n3 = locdateList.item(i).getChildNodes().item(0);
        	h.setDateName(n1.getNodeValue());
        	h.setIsHoliday(n2.getNodeValue());
        	h.setLocdate(n3.getNodeValue());
        	list.add(h);
        }
      
        
        
        model.addAttribute("list",list);
		return "/testApi";
	}
	
	@GetMapping("/attendance")
	public String attendanceManagement() {
		
		return "user/attendanceManagement";
	}
	
	
	@GetMapping("/userInformation")
	public String userInformation(Model model) {
		List<Map<String, Object>> deptList = dayoffService.getUserCntByDept();
		List<Map<String, Object>> userList = dayoffService.getUserListByDept();
		List<Map<String, Object>> userCnt = dayoffService.getUserCntByDeptAndAll();
		
		model.addAttribute("deptList",deptList);
		model.addAttribute("userList",userList);
		model.addAttribute("userCnt",userCnt);
		
		return "user/userInformation";
	}
}
