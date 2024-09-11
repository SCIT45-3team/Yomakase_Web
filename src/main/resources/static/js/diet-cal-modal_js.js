//식단 달력 모달 자바스크립트 파일
const dietModal = document.getElementById("diet-modal");

function modalOn() {
    dietModal.style.display = "flex"
}

function isModalOn() {
    return dietModal.style.display === "flex"
}

function modalOff() {
    dietModal.style.display = "none"
}

// 모달창의 클로즈(x) 버튼을 누르면 모달창이 꺼지게 하기
const calCloseBtn = dietModal.querySelector(".close-btn")
calCloseBtn.addEventListener("click", e => {
    calBackgroundChange();
    modalOff()

})
// 모달창 바깥 영역을 클릭하면 모달창이 꺼지게 하기
dietModal.addEventListener("click", e => {
    const evTarget = e.target
    if (evTarget.classList.contains("diet-modal-overlay")) {
        calBackgroundChange();
        modalOff()

    }
})
// 모달창이 켜진 상태에서 ESC 버튼을 누르면 모달창이 꺼지게 하기
window.addEventListener("keyup", e => {
    if (isModalOn() && e.key === "Escape") {
        modalOff()
        calBackgroundChange();
    }
})


//달력 배경화면 바꾸는 함수 (모달창이 꺼질 때마다 실행)
let index = 0;
function calBackgroundChange() {
    let path = "url(/img/cal_food_";
    let calBackgroundAddress = [0, 1, 2, 3, 4];
//url(assets/img/calBackgroundAddress[index])
    if(index >= calBackgroundAddress.length){
        index = 0;
    }
    else if(index === 0) {
        index++;
    }
    let bgAddress = path + calBackgroundAddress[index] + '.png)';
    $('.wrap-header').css('background-image', bgAddress);
    index++;
}

//영양소 부분의 모달
let nutrientModal = document.getElementById("nutrient-modal");
function modalNutrientOn() {
    nutrientModal.style.display = "flex"
}

function isModalNutrientOn() {
    return nutrientModal.style.display === "flex"
}

function modalNutrientOff() {
    nutrientModal.style.display = "none"
}


// 모달창의 클로즈(x) 버튼을 누르면 모달창이 꺼지게 하기
const closeNutrientBtn = nutrientModal.querySelector(".close-btn")
closeNutrientBtn.addEventListener("click", e => {
    modalNutrientOff()

})
// 모달창 바깥 영역을 클릭하면 모달창이 꺼지게 하기
nutrientModal.addEventListener("click", e => {
    const evTarget = e.target
    if (evTarget.classList.contains("modal-overlay")) {
        modalNutrientOff()

    }
})
// 모달창이 켜진 상태에서 ESC 버튼을 누르면 모달창이 꺼지게 하기
window.addEventListener("keyup", e => {
    if (isModalNutrientOn() && e.key === "Escape") {
        modalNutrientOff()
    }
})


