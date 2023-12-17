# “무비톡” - 영화인들의 소모임

<img width="128" alt="appIcon" src="https://github.com/alexcho617/MovieTalk/assets/38528052/d9de60c4-b00d-4858-8e91-784d294bfefb">

<br>
<img width="2163" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/8a92d5f9-429f-4ee7-b12f-3ec66b4fc3f1">


## ⭐ 프로젝트 소개
영화를 좋아하는 사람들을 위한 SNS 앱입니다. 원하는 영화를 검색 하고 링크하여 게시글을 작성할 수 있으며 좋아요와 댓글 기능으로 다른 사람들과 교류할 수 있습니다.
<br>

## 👤 개발 인원
개인 프로젝트
<br>

## 📆 개발 기간
 2023.11.1. ~ 2023.12.7. (4주) 
<br>

## 🛠️ 기술스택
UIKit / MVVM / RxSwift / SnapKit / Realm / Kingfisher / Moya / OpenAPI
<br>

## 📦 개발환경 & 타겟
- Swift 5.8 / Xcode 14.3 / SnapKit 5.6 / Kingfisher 7.9 / Alamofire 5.8 / Realm 10.42
- iOS 16.0

## 🤔  개발하며 고민한 점
- JWT 기반 로그인 & 인증 구현 및 HTTP status code 확인하여 토큰 만료시 Refresh처리
- scrollViewDidScroll로 의 현재 오프셋과 콘텐츠의 길이를 비교 후 nextCursor로 fetch하여 커서 기반 페이지네이션 구현
- PHPicker로 사용자 사진 접근 후 서버 제한 사항에 맞추어 compressionQuality를 사용한 이미지 다운샘플링 후 POST 요청
- DTO를 사용한 레이어 분리와 Router를 통해 네트워크 모듈을 추상화하여 약 20개의 엔드포인트를 효율적으로 관리
- 영화 검색시 RxSwift debounce와 distincUntilChanged를 통해 API 과호출을 제어했으며 에러 발생시에도 UI 구독 유지
- MVVM + In/Out패턴을 도입하여 데이터 스트림이 직관적이도록 구조화
- DI적용을 통해 주요 ViewModel의 코어 비즈니스 로직 Unit 테스트

## ⚠️  트러블슈팅
- 홈 뷰와 댓글 뷰 사이에 강한참조 사이클이 발생하여 closure에 weak을 사용하고 댓글 뷰가 사라지는 시점에서 disposeBag의 인스탄스를 교체해주어 deinit이 호출됨을 확인 함으로 메모리 누수를 막았습니다.

- ScrollView의 서브뷰로 CollectionView가 임베딩 상황에서 스크롤이 제대로 동작하지 않아 CollectionView의 intrinsicContentSize를 오버라이드시키고 scrollEnabled를 false로 바꾸어 자연스러운 스크롤이 되도록 해결했습니다.

## 🍎 기능상세

- 영화 테마의 SNS 게시글
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/e8a1ed99-d679-425d-bbbc-b5adb16ee127">
<br>
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/f51a2f14-076d-4130-ac3e-699aa28fd405">
<br><br>

- 회원가입 및 로그인
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/0a7bcf36-af81-43fe-aa18-e1d078a05bdc">
<br><br>
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/4048dcdf-19f0-46f1-9ec9-3d0146a2b834">
<br><br>

- 영화 검색 & 링크
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/68a1a93d-ab5c-45e9-bbd6-14b07e049c40">
<br>
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/66e537b5-2df9-4e97-baf5-2b271102d781">
<br><br>

- 좋아요 & 댓글
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/f663c417-0d33-4a0a-8410-415901969ccb">
<br><br>

- 프로필 조회 및 수정
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/39ac8ad4-e782-4d2d-a4de-5976bf8d868f">
<br>
<img width="300" alt="image" src="https://github.com/alexcho617/MovieTalk/assets/38528052/6d6ae50e-26c3-4188-ac4c-87ee4b45371e">
<br><br>
