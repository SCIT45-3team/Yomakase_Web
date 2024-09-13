package net.datasa.yomakase_web.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.datasa.yomakase_web.domain.dto.CalendarDTO;
import net.datasa.yomakase_web.domain.entity.CalendarEntity;
import net.datasa.yomakase_web.security.AuthenticatedUser;
import net.datasa.yomakase_web.service.CalendarService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * 캘린더 ajax요청을 처리하는 컨트롤러
 */
@RestController
@Slf4j
@RequestMapping("cal")
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarService calendarService;

    /**
     * 식단 저장 메소드
     * @param arr
     */
    @PostMapping("diet")
    public void dietInputMethod(@RequestParam("dietArr") String[] arr) {
//        throw new RuntimeException("오류");
        //calendarDTO.setMemberNum(user);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-M-d");
        LocalDate date = LocalDate.parse(arr[3], formatter);

        CalendarDTO calDTO = new CalendarDTO();
        calDTO.setBName(arr[0]);
        calDTO.setLName(arr[1]);
        calDTO.setDName(arr[2]);
        calDTO.setInputDate(date);
        for (String s : arr) {
            log.debug("배열요소 : {}", s);
            //AuthenticatedUser user = new AuthenticatedUser();
        } //success로 설정한 그 함수로 리턴되어 간다. 리턴값이 있든 없든!
            log.debug("배열:{},{},{},{}", arr[0], arr[1], arr[2], date);
        calendarService.dietSave(calDTO);
    }

}