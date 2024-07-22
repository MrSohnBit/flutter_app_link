
// pushType
String FCM_PUSH_TYPE_CLOSED = "closed";                         // 마감 리포트
String FCM_PUSH_TYPE_DAILY = "daily";                           // 일일 리포트
String FCM_PUSH_TYPE_DAILY_EXPECT = "daily_expect";             // 입금예정금액 리포트
String FCM_PUSH_TYPE_DAILY_SETTLEMENT = "daily_settlement";     // 매출 정산 리포트
String FCM_PUSH_TYPE_MARKETING = "mkt";                         // 마케팅
String FCM_PUSH_TYPE_CANCEL = "cancel";                         // 결제취소
String FCM_PUSH_TYPE_STORE_INFO = "storeInfo";                  //
String FCM_PUSH_TYPE_APP_INFO = "appInfo";                      // 단순공지(유저공지타입)
String FCM_PUSH_TYPE_ORDER_FAILED = "orderFailed";              // 결제실패
String FCM_PUSH_TYPE_NEW_REVIEW = "newReview";                  // 새로운 리뷰 알림

// landingType
String FCM_LANDING_TYPE_IN_APP = "inapp";       // 인앱링크
String FCM_LANDING_TYPE_IN_WEBVIEW = "webview"; // 앱내 웹뷰
String FCM_LANDING_TYPE_IN_CONTENT = "content"; // response의 content html 화면
String FCM_LANDING_TYPE_EXTERNAL = "external";  // 외부 링크
String FCM_LANDING_TYPE_NONE = "none";          // 동작없음
String FCM_LANDING_TYPE_WEBVIEW_EXT_CJ = "webview_ext_cj";   // CJFW 식자재몰 띄우기


// landingUrl
String LANDING_DAILY_REPORT = "dailyReport";                        // 일일 리포트
String LANDING_DAILY_EXPECT_REPORT = "dailyExpectReport";           // 입금예정 리포트
String LANDING_DAILY_SETTLEMENT_REPORT = "dailySettlementReport";   // 매출정산 리포트
String LANDING_CLOSE_REPORT = "closeReport";                        // 마감 리포트
String LANDING_DAILY = "landing_daily";                             // 마감 리포트
String LANDING_CANCEL  = "landing_cancel";                          // 취소 거래 내역 화면
String LANDING_PUSH_LIST = "landing_push_list";                     // 알림 내역 리스트
String LANDING_NON_SETTLEMENT  = "landing_non_settlement";	        // 카드 미지급금 내역(미매입)
String LANDING_NON_SETTLEMENT_HOLD   = "landing_non_settlement_hold"; // 카드 미지급금 내역(입금보류)
String LANDING_LOGIN = "landing_login";                             // 로그인 화면
String LANDING_STORE_REGIST = "landing_store_regist";               // 매장 미등록
String LANDING_DATA_REGIST = "landing_data_regist";                 // 데이터 미연동(포스연동)

String LANDING_NOTICE = "landing_notice";                           // 공지사항
String LANDING_VAT_REQUEST = "landing_vat_request";                 // 부가세 신청
String LANDING_STORE_INFO = "landing_store_info";                   // 새로운 연동유저 알림, 초대관리자 내보내기 당할때
String LANDING_CARDLIST = "landing_cardlist";                       // 결제정보 확인
String LANDING_DELIVERY_REVIEW = "landing_delivery_review";         // 우리 가게 리뷰 페이지로 이동

String LANDING_MENU = "landing_menu";                               // POS 메뉴별 매출

String LANDING_HOME = "landing_home";                               // 메인 대시보드
String LANDING_CALENDAR = "landing_calendar";                       // 메인 캘린더
String LANDING_ALL_LIST = "landing_all_list";                       // 메인 모든내역
String LANDING_SECRETARY = "landing_secretary";                     // 메인 매장비서


String LANDING_LINK = "landing_link";                               // 연동관리 (pending 2개 이상)
String LANDING_LINK_BANK = "landing_link_bank";                     // 은행계좌 연동
String LANDING_LINK_CREFIA = "landing_link_crefia";                 // 연동관리 - 여신협회
String LANDING_LINK_HOMETAX = "landing_link_hometax";               // 연동관리 - 홈택스
String LANDING_LINK_BAEMIN = "landing_link_baemin";                 // 연동관리 - 배달의민족
String LANDING_LINK_YOGIYO = "landing_link_yogiyo";                 // 연동관리 - 요기요
String LANDING_LINK_EATS = "landing_link_eats";                     // 연동관리 - 쿠팡이츠
String LANDING_BANK_ASSETS = "landing_bank_assets";                 // 사업용 계좌 목록
String LANDING_NEW_STORE = "landing_new_store";                     // 새로 오픈한 매장

String LANDING_LINK_REFUND = "landing_commission_refund";           // 내역보기 - 카드환급금 조회(배너에서만 사용)

String LANDING_ZINI_BIZ = "landing_zini_biz";                       // 상권분석 동종업매출비교로 이동

String LANDING_VAT_RESULT = "landing_vat_result";                   // 부가세 신고 자료 발송 결과 화면

String LANDING_DELIVERYINFO = "landing_deliveryinfo";               // CJFW 주소/업종 화면
String LANDING_BIZCODE = "landing_bizcode";                         // CJFW 업종 선택 화면
String LANDING_ADDRESS = "landing_address";                         // CJFW 주소 검색 화면

//landingUrl:  https://maapp.okpos.co.kr:8080/auth/web/issue/faq?storeId={storeId} -> landing_web_as (편집됨)
String LANDING_WEB_AS = "landing_web_as";                           //  AS 문의 웹페이지로 이동(landingType: inapp)


List<DeepLink> getDeepLinkDatas() {
  return [
    DeepLink("일일 리포트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DAILY_REPORT, "0", "0"),
    DeepLink("입금예정 리포트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DAILY_EXPECT_REPORT, "0", "0"),
    DeepLink("매출정산 리포트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DAILY_SETTLEMENT_REPORT, "0", "0"),
    DeepLink("마감 리포트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_CLOSE_REPORT, "0", "0"),
    DeepLink("마감 리포트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DAILY, "0", "0"),
    DeepLink("취소 거래 내역 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_CANCEL, "0", "0"),
    DeepLink("알림 내역 리스트", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_PUSH_LIST, "0", "0"),
    DeepLink("카드 미지급금 내역(미매입)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_NON_SETTLEMENT, "0", "0"),
    DeepLink("카드 미지급금 내역(입금보류)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_NON_SETTLEMENT_HOLD, "0", "0"),
    DeepLink("로그인 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LOGIN, "0", "0"),
    DeepLink("매장 미등록", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_STORE_REGIST, "0", "0"),
    DeepLink("데이터 미연동(포스연동)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DATA_REGIST, "0", "0"),
    DeepLink("공지사항", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_NOTICE, "0", "0"),
    DeepLink("부가세 신청", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_VAT_REQUEST, "0", "0"),
    DeepLink("새로운 연동유저 알림, 초대관리자 내보내기 당할때", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_STORE_INFO, "0", "0"),
    DeepLink("결제정보 확인", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_CARDLIST, "0", "0"),
    DeepLink("우리 가게 리뷰 페이지로 이동", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DELIVERY_REVIEW, "0", "0"),
    DeepLink("POS 메뉴별 매출", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_MENU, "0", "0"),
    DeepLink("메인 대시보드", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_HOME, "0", "0"),
    DeepLink("메인 캘린더", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_CALENDAR, "0", "0"),
    DeepLink("메인 모든내역", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_ALL_LIST, "0", "0"),
    DeepLink("메인 매장비서", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_SECRETARY, "0", "0"),
    DeepLink("내역보기 - 카드환급금 조회(배너에서만 사용)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_REFUND, "0", "0"),
    DeepLink("상권분석 동종업매출비교로 이동", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_ZINI_BIZ, "0", "0"),
    DeepLink("부가세 신고 자료 발송 결과 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_VAT_RESULT, "0", "0"),

    DeepLink("연동관리(pending 2개 이상)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK, "0", "0"),
    DeepLink("은행계좌:연동", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_BANK, "0", "0"),
    DeepLink("연동관리:여신협회", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_CREFIA, "0", "0"),
    DeepLink("연동관리:홈택스", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_HOMETAX, "0", "0"),
    DeepLink("연동관리:배달의민족", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_BAEMIN, "0", "0"),
    DeepLink("연동관리:요기요", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_YOGIYO, "0", "0"),
    DeepLink("연동관리:쿠팡이츠", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_LINK_EATS, "0", "0"),
    DeepLink("사업용계좌목록", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_BANK_ASSETS, "0", "0"),
    DeepLink("새로오픈한매장", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_NEW_STORE, "0", "0"),


    DeepLink("CJFW 주소/업종 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_DELIVERYINFO, "0", "0"),
    DeepLink("CJFW 업종 선택 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_BIZCODE, "0", "0"),
    DeepLink("CJFW 주소 검색 화면", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_ADDRESS, "0", "0"),
    DeepLink("AS 문의 웹페이지로 이동(landingType: inapp)", FCM_PUSH_TYPE_STORE_INFO, FCM_LANDING_TYPE_IN_APP, LANDING_WEB_AS, "0", "0"),
  ];
}



class DeepLink {
  // List<DeepLink> list = getDeepLinkDatas(_displayText == ''? -1 : int.parse(_displayText));

  String name = "";
  String type = "";
  String landingType = "";
  String landingUrl = "";
  String bankAccountId = "0";
  String reportMessageId = "0";

  DeepLink(
      this.name,
      this.type,
      this.landingType,
      this.landingUrl,
      this.bankAccountId,
      this.reportMessageId
      );
}