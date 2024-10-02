document.addEventListener('DOMContentLoaded', function(){
    "use strict";   //엄격모드 활성화

    //달력 관련 변수
    var today = new Date(),
        year = today.getFullYear(),
        month = today.getMonth(),
        monthTag =[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        day = today.getDate(),
        calendarTable = document.getElementById('calendarTable'),
        days = calendarTable.getElementsByTagName('td'),
        selectedDay,    //사용자가 선택한 날짜 정보 : Sun Oct 27 2024 00:00:00 GMT+0900 (한국 표준시)
        setDate,        
        daysLen = days.length, //<td>요소의 총 개수. 한달의 일수
        headDate = document.getElementById('head-date');    //달력 중앙 '2024년 9월' 부분

    let clickedDietDay = document.getElementsByClassName('clickedDietDay')[0];

    //사용자 인증 정보 (일반, 구독자 계정 구분용)
    const userRole = document.getElementById('userRole').value;
    //버튼 선택 영역
    let btnDiv = document.getElementById('cal-title-btn');
    //식단 버튼
    let dietCalBtn  = document.getElementById('dietCalBtn');
    //영양소 버튼
    let nutrientCalBtn = document.getElementById('nutrientCalBtn');
    //버튼 활성화 확인
    let btnActiveCheck = true;  //기본적으로 식단 버튼 클릭 상태일 때 true, 영양소 버튼 상태일 때 false
    //식단 조회 영역
    let dietList = document.getElementById('diet-list');
    //영양소 조회 영역
    let nutrientList = document.getElementById('nutrient-list');



    /**
     * Calendar 객체 생성자 함수 정의
     * @param selector
     * @param options
     * @constructor
     */
    function Calendar(selector, options) {
        this.options = options;
        this.draw();
    }

    
    //버튼 선택 영역 : 구독 사용자에게만 보이도록 함
    if(userRole === 'ROLE_SUBSCRIBER'){
        btnDiv.style.visibility = 'visible';
    } else{
        btnDiv.style.visibility = 'hidden';
    }


    function btnActive(){
        dietCalBtn.style.backgroundColor = '#FFB524';
        nutrientCalBtn.addEventListener('click', function (){
            btnActiveCheck = false;
            dietCalBtn.style.backgroundColor = '';
            nutrientCalBtn.style.backgroundColor = '#FFB524';
            document.getElementById('nutrientCalTitle').style.display = 'block';
            document.getElementById('dietCalTitle').style.display = 'none';
        });
        dietCalBtn.addEventListener('click', function (){
            btnActiveCheck = true;
            nutrientCalBtn.style.backgroundColor = '';
            dietCalBtn.style.backgroundColor = '#FFB524';
            document.getElementById('dietCalTitle').style.display = 'block';
            document.getElementById('nutrientCalTitle').style.display = 'none';
        })

    }
    btnActive();

    /**
     * 달력을 계속 새로 그리는 함수
     */
    Calendar.prototype.draw  = function() {
        this.getCookie('selected_day');
        this.getOptions();
        this.drawDays();
        var that = this,
            //리셋 버튼
            reset = document.getElementById('reset'),
            //이전 버튼
            pre = document.getElementsByClassName('pre-button'),
            //다음 버튼
            next = document.getElementsByClassName('next-button');

        pre[0].addEventListener('click', function () {
            that.preMonth();
        });
        next[0].addEventListener('click', function () {
            that.nextMonth();
        });
        reset.addEventListener('click', function () {
            that.reset();
        });


        //페이지의 모든 <td>요소에 이벤트를 등록하는 반복문
        while (daysLen--) {
            days[daysLen].addEventListener('click', function () {
                if(btnActiveCheck) {
                    dietView(this);
                } else{
                    nutrientView(this);
                }
            });

            days[daysLen].addEventListener('dblclick', function () {
                if(btnActiveCheck){
                    modalOn();
                }
            });

            /*days[daysLen].addEventListener('mouseover', function () {
                if(!btnActiveCheck){
                    modalNutrientOn();
                }
            });
            days[daysLen].addEventListener('mouseleave', function () {
                if(!btnActiveCheck){
                    modalNutrientOff();
                }
            });*/


        }
    }

    /**
     * 식단 조회 함수
     * @param td
     */
    function dietView(td){
        //alert('식단 입력')
        selectedDay = new Date(year, month, td.innerHTML);

        calendar.drawHeader(td.innerHTML);
        calendar.setCookie('selected_day', 1);

        $.ajax({
            url : '/cal/dietList',
            type : 'post',
            data : {selectedDay: selectedDay.toLocaleDateString('en-CA')} ,    // o.toISOString().split('T')[0] T를 기준으로 자르고 첫번째 배열의 요소를 선택하는 방법. 이렇게 하니까 날짜가 선택한 날짜보다 하루 적게 나옴.
            dataType : 'json',
            success : function(calDTO){
                nutrientList.style.display = 'none';
                dietList.style.display = 'block';
                document.getElementById('diet-list-msg').style.display = 'none';
                //console.log(calDTO); //{"id":"alpha@yomakase.test","memberNum":1,"inputDate":"2024-08-02","dname":"손말이고기","lname":"부대찌개","bname":"맥심 커피"}
                if(!calDTO.bname && !calDTO.lname && !calDTO.dname){
                    dietList.style.display = 'none';
                    document.getElementById('diet-list-msg').style.display = 'block';
                } else{
                    let listBName = dietList.getElementsByTagName('td')[1];
                    let listLName = dietList.getElementsByTagName('td')[3];
                    let listDName = dietList.getElementsByTagName('td')[5];
                    listBName.innerText = calDTO.bname;
                    listLName.innerText = calDTO.lname;
                    listDName.innerText = calDTO.dname;
                }
            },
            error : function (){
                dietList.style.display = 'none';
                document.getElementById('diet-list-msg').style.display = 'block';
            }
        })
    }

    /**
     * 영양소 조회 함수
     * @param td
     */
    function nutrientView(td){
        //alert('영양소 입력');

        selectedDay = new Date(year, month, td.innerHTML);

        calendar.drawHeader(td.innerHTML);
        calendar.setCookie('selected_day', 1);

        $.ajax({
            url : '/cal/nutrientList',
            type : 'post',
            data : {selectedDay: selectedDay.toLocaleDateString('en-CA')} ,    // o.toISOString().split('T')[0] T를 기준으로 자르고 첫번째 배열의 요소를 선택하는 방법. 이렇게 하니까 날짜가 선택한 날짜보다 하루 적게 나옴.
            dataType : 'json',
            success : function(calDTO){
                dietList.style.display = 'none';
                nutrientList.style.display = 'block';
                document.getElementById('diet-list-msg').style.display = 'none';
                if(!calDTO.totalKcal && !calDTO.tooMuch && !calDTO.lack && !calDTO.recom){
                    dietList.style.display = 'none';
                    nutrientList.style.display = 'none';
                    document.getElementById('diet-list-msg').style.display = 'block';
                } else {
                    dietList.style.display = 'none';
                    nutrientList.style.display = 'block';
                    document.getElementById('diet-list-msg').style.display = 'none';
                    console.log(calDTO);

                    let listTotalKcal = nutrientList.getElementsByTagName('td')[1];
                    let listTooMuch = nutrientList.getElementsByTagName('td')[3];
                    let listLack = nutrientList.getElementsByTagName('td')[5];
                    //let listRecom = nutrientList.getElementsByTagName('td')[7];
                    //let listScore = nutrientModalContent.getElementsByTagName('td')[1];
                    listTotalKcal.innerHTML = calDTO.totalKcal;
                    listTooMuch.innerHTML = calDTO.tooMuch;
                    listLack.innerHTML = calDTO.lack;
                    //let recomSplit = calDTO.recom.split("\n");
                    //console.log(recomSplit);
                    nutrientList.getElementsByTagName('td')[7].innerHTML = calDTO.recom;

                    nutrientList.getElementsByTagName('td')[9].innerHTML = calDTO.score;

                    document.getElementById('diet-list-msg').style.display = 'none';
                }
            },
            error : function (){
                dietList.style.display = 'none';
                document.getElementById('diet-list-msg').style.display = 'block';
            }
        })

    }


    /**
     * @param e 사용자가 클릭해서 선택한 날짜(일)
     */
    Calendar.prototype.drawHeader = function(e) {
        var headDay = document.getElementsByClassName('head-day'),
            headMonth = document.getElementsByClassName('head-month');

        e ? headDay[0].innerHTML = e + "일" : headDay[0].innerHTML = day;
        headMonth[0].innerHTML = `${monthTag[month]}월`;
        headDate.innerHTML = year + '년 ' + monthTag[month] + '월';
        if (selectedDay){

        let formattedDay = selectedDay.toLocaleDateString('en-CA')
        console.log(selectedDay);
        console.log(formattedDay); //2024-08-31 선택한 날짜로 잘 나옴
        clickedDietDay.innerHTML = formattedDay;
        } else {
            console.warn('선택된 날짜가 정의되지 않음')
            selectedDay = new Date();
        }

    }; //drawHeader 함수 end


    /**
     * 달력의 날짜를 계산하고 그리는 함수
     */
    Calendar.prototype.drawDays = function () {
        var startDay = new Date(year, month, 1).getDay(),
            nDays = new Date(year, month + 1, 0).getDate(), //달의 마지막날
            n = startDay;

        for(var k = 0; k < 42; k++) {
            days[k].innerHTML = '';
            days[k].id = '';
            days[k].className = '';
        }

        for(var i = 1; i <= nDays; i++) {
            days[n].innerHTML = i;
            n++;
        }

        for(var j = 0; j < 42; j++) {
            if(days[j].innerHTML === ""){
                days[j].className = "disabledDay";
            } else if(j === day + startDay - 1){
                if((this.options && (month === setDate.getMonth()) && (year === setDate.getFullYear())) || (!this.options && (month === today.getMonth()) && (year===today.getFullYear()))){
                    this.drawHeader(day);
                    days[j].id = "today";
                }
            }
            if(selectedDay){
                if((j === selectedDay.getDate() + startDay - 1)&&(month === selectedDay.getMonth())&&(year === selectedDay.getFullYear())){
                    days[j].className = "selected";
                    this.drawHeader(selectedDay.getDate());
                }
            }

            }

    } //drawDays 함수 end
    

    Calendar.prototype.preMonth = function() {
        if(month < 1){
            month = 11;
            year = year - 1;
        }else{
            month = month - 1;
        }
        this.drawHeader(1);
        this.drawDays();
    };

    Calendar.prototype.nextMonth = function() {
        if(month >= 11){
            month = 0;
            year =  year + 1;
        }else{
            month = month + 1;
        }
        this.drawHeader(1);
        this.drawDays();
    };

    Calendar.prototype.getOptions = function() {
        if(this.options){
            var sets = this.options.split('-');
            setDate = new Date(sets[0], sets[1]-1, sets[2]);
            day = setDate.getDate();
            year = setDate.getFullYear();
            month = setDate.getMonth();
        }
    };

    Calendar.prototype.reset = function() {
        month = today.getMonth();
        year = today.getFullYear();
        day = today.getDate();
        this.options = undefined;
        this.drawDays();
    };

    Calendar.prototype.setCookie = function(name, expiredays){
        var date = new Date();
        date.setTime(date.getTime() + (expiredays * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toUTCString();
        document.cookie = name + "=" + selectedDay + expires + "; path=/";
    };

    Calendar.prototype.getCookie = function(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) selectedDay = new Date(c.substring(nameEQ.length, c.length));
        }
    };

    var calendar = new Calendar();  //해당 부분 필수! 없으면 달력이 그려지지 않음

}, false);  //전체 문서 addEventListener의 함수 end