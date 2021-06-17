// 마커 이미지 경로
const bluePinSrc   = "resources/image/marker/bluePin.png";
const greenPinSrc  = "resources/image/marker/greenPin.png";
const whitePinSrc  = "resources/image/marker/whitePin.png";
const yellowPinSrc = "resources/image/marker/yellowPin.png";
const orangePinSrc = "resources/image/marker/orangePin.png";
const redPinSrc    = "resources/image/marker/redPin.png";

// 마커 이미지 크기
const imageSize = new kakao.maps.Size(35, 35);
// 마커 이미지 생성
const bluePin   = new kakao.maps.MarkerImage(bluePinSrc, imageSize);
const greenPin  = new kakao.maps.MarkerImage(greenPinSrc, imageSize);
const whitePin  = new kakao.maps.MarkerImage(whitePinSrc, imageSize);
const yellowPin = new kakao.maps.MarkerImage(yellowPinSrc, imageSize);
const orangePin = new kakao.maps.MarkerImage(orangePinSrc, imageSize);
const redPin    = new kakao.maps.MarkerImage(redPinSrc, imageSize);

//카카오맵 생성하여 지도 중심 옮겨줌
function focusMapCenter(latitude , longitude , zoom){

    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
    var options = { //지도를 생성할 때 필요한 기본 옵션
        center: new kakao.maps.LatLng(latitude, longitude), //지도의 중심좌표.
        level: zoom //지도의 레벨(확대, 축소 정도)
    };

    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
    return map;
}

//냄새강도에 따라 마커 이미지 반환
function returnMarkerImage(smellValue) {
    var markerImage;

    if(smellValue == '001' || smellValue == '(0)무취')       markerImage = bluePin;
    else if(smellValue == '002' || smellValue == '(1)감지 취기')  markerImage = greenPin;
    else if(smellValue == '003' || smellValue == '(2)보통 취기')  markerImage = whitePin;
    else if(smellValue == '004' || smellValue == '(3)강한 취기')  markerImage = yellowPin;
    else if(smellValue == '005' || smellValue == '(4)극심한 취기')  markerImage = orangePin;
    else if(smellValue == '006' || smellValue == '(5)참기 어려운 취기')  markerImage = redPin;


    return markerImage;
}
