# Peek and Pick

<img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/c5ca81be-c479-4db9-b0ba-dc46084d5632" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/c43778e1-284b-4ab7-9986-112eb63fa3f7" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/aaeefb26-c44b-4bdf-9025-887078563a6f" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/e4fbf8d2-76c4-4f0b-bdda-98610f4ac246" width="23%" height="23%">

## 개발 기간
2023.09.07 ~ 2023.09.15 (1주)

## 한 줄 소개
네이버 쇼핑 API을 활용해 여러 상품을 살펴보고 관심 있는 제품을 장바구니에 담을 수 있는 애플리케이션

## 기능 소개
- 네이버 쇼핑 내 상품 검색 기능
- 정확도, 시간, 가격을 기준으로 상품 정렬 가능
- 제품 상세페이지 확인 기능
- 관심 상품에 좋아요를 눌러 따로 저장
- 좋아요 목록 내 검색 기능


## 핵심 기술
- Alamofire와 Router 패턴을 활용하여 네트워크 통신을 구축. 이를 통해 네이버 쇼핑 API를 이용한 상품 검색
- WebView를 통해 제품의 상세 페이지 확인
- Realm DB CRUD 작업을 Repository Pattern을 통해 구조화
- prefetchsAt 메서드를 활용하여 효율적이고 매끄러운 페이지네이션 기능
- 상품 목록은 여러 가지 정렬 기준에 따라 확인할 수 있으며, 이러한 정렬 기준은 enum을 활용하여 직관적으로 관리
- GCD를 통해 비동기 작업과 UI 업데이트를 분리하여 동시성 문제를 방지

## 기술 스택 및 라이브러리
- UIKit
- WebView
- MVC
- Alamofire
- SnapKit
- ReamSwift
- Toast
- Extension, Protocol, Closure, Codable, UUID
