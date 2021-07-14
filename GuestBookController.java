package com.it.herb.guestbook.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.it.herb.guestbook.model.GuestBookService;
import com.it.herb.guestbook.model.GuestBookVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class GuestBookController {
	private static final Logger logger = LoggerFactory.getLogger(GuestBookController.class);
	
	private final GuestBookService gbService;
	
	@RequestMapping(value = "/guestbook/write.do", method = RequestMethod.GET)
	public String write() {
		logger.info("방명록등록페이지");
		
		return "guestbook/write";
	} 
	
	@RequestMapping(value = "/guestbook/write.do", method = RequestMethod.POST)
	public String write_post(@ModelAttribute GuestBookVO vo, Model model) {
		//1 
		logger.info("방명록등록, vo={}", vo);
		
		//2
		int cnt = gbService.insertGuest(vo);
		String msg = "방명록작성 실패", url= "/guestbook/write.do";
		if(cnt>0) {
			msg = "방명록 작성 성공";
			url = "/guestbook/list.do";
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("url", url);
		
		return "common/message";
	}
	
	@RequestMapping("/guestbook/list.do")
	public String list2(Model model) {
		logger.info("방명록리스트");
		//2
		List<GuestBookVO> list = gbService.selectAll();
		//3
		model.addAttribute("list", list);
		return "guestbook/list";
	}
	
	@ResponseBody
	@RequestMapping("/guestbook/ajaxList.do")
	public List<GuestBookVO> ajaxList() {
		logger.info("방명록리스트");
		List<GuestBookVO> list = gbService.selectAll();
		return list;
	}
	
	@RequestMapping("/guestbook/detail.do")
	public String detail(@RequestParam(defaultValue = "0") int no, Model model) {
		logger.info("디테일,  no={}", no);
		
		GuestBookVO vo = gbService.selectByNo(no);
		logger.info("디테일 정보 vo={}",vo);
		
		model.addAttribute("vo", vo);
		
		return "guestbook/detail";
	}
	
	@ResponseBody
	@RequestMapping("/guestbook/ajaxDetail.do")
	public GuestBookVO ajaxDetail(@RequestParam(defaultValue = "0")int no) {
		logger.info("ajax detail, 파라미터 no={}",no);
		GuestBookVO vo = gbService.selectByNo(no);
		return vo;
	}
	
	@RequestMapping(value = "/guestbook/edit.do", method = RequestMethod.GET)
	public String edit(@RequestParam(defaultValue = "0") int no, Model model) {
		logger.info("수정페이지");
		
		GuestBookVO vo = gbService.selectByNo(no);
		
		model.addAttribute("vo", vo);
		
		return "guestbook/edit";
	}
	
	@RequestMapping(value = "/guestbook/edit.do", method = RequestMethod.POST)
	public String edit_post(@ModelAttribute GuestBookVO vo, Model model) {
		logger.info("방명록수정 vo={}",vo);
		
		int cnt = gbService.updateGuest(vo);
		String msg ="수정실패" , url="/guestbook/edit.do?no"+vo.getNo();
		if(cnt>0) {
			msg="수정성공";
			url="/guestbook/list.do";
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("url", url);
		
		return "common/message";
	}
	
	@RequestMapping(value = "/guestbook/delete.do", method = RequestMethod.GET)
	public String delete(@RequestParam(defaultValue = "0")int no, Model model) {
		logger.info("딜리트 no={}",no);
		if(no==0) {
			model.addAttribute("msg", "잘못된경로입니다.");
			model.addAttribute("url", "/guestbook/list.do");
			
			return "common/message";
		}
		
		return "/guestbook/delete";
	}
	
	@RequestMapping(value = "/guestbook/delete.do", method = RequestMethod.POST)
	public String delete_post(@ModelAttribute GuestBookVO vo, Model model ) {
		logger.info("삭제 vo={}",vo);
		
		
		int cnt = gbService.deleteGuest(vo.getNo(),vo.getPwd());
		String msg="삭제 실패", url="/guestbook/delete.do?no="+vo.getNo();
		if(cnt>0) {
			msg="삭제 성공";
			url="/guestbook/list.do";
		}
		
	    model.addAttribute("msg", msg);
	    model.addAttribute("url", url);
		
	    return "common/message";
	}
}
