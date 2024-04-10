# Peek and Pick

<img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/c5ca81be-c479-4db9-b0ba-dc46084d5632" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/c43778e1-284b-4ab7-9986-112eb63fa3f7" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/aaeefb26-c44b-4bdf-9025-887078563a6f" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/e4fbf8d2-76c4-4f0b-bdda-98610f4ac246" width="23%" height="23%">
<br/><br>

## 한 줄 소개
네이버 쇼핑 API을 활용해 여러 상품을 살펴보고 관심 있는 제품을 장바구니에 담을 수 있는 애플리케이션

## 개발 기간
2023.09.07 ~ 2023.09.15 (1주)

## 기능 소개
- 네이버 쇼핑 내 상품 검색
- 정확도, 시간, 가격을 기준으로 상품 정렬 가능
- 제품 상세페이지 확인
- 관심 상품에 좋아요를 눌러 따로 저장
- 좋아요 목록 내 검색

## 기술 스택 및 라이브러리
- UIKit
- WebView
- MVC
- Alamofire
- SnapKit
- ReamSwift
- Toast
- Extension, Protocol, Closure, Codable, UUID

## 핵심 기술
- Alamofire와 Singleton Pattern을 활용한 네트워크 통신을 구현하고, Decodable 구조체를 사용하여 서버 응답값을 추출함
- DispatchQueue를 활용하여 URL 로드와 UI 업데이트가 비동기적으로 처리됨
- WKWebView를 통해 제품의 상세 페이지 확인
- Realm DB CRUD 작업을 Protocol과 Repository Pattern을 통해 구조화
- prefetchsAt 메서드를 활용하여 효율적이고 매끄러운 페이지네이션 기능
- 상품 목록은 여러 가지 정렬 기준에 따라 확인할 수 있으며, 이러한 정렬 기준은 enum을 활용하여 직관적으로 관리

## 고민한 지점

- cell 재사용 문제
```swift

override func prepareForReuse() {
        super.prepareForReuse()
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

```
서치바에 새로운 키워드를 검색했을 때, 혹은 페이지를 스크롤 할 때 이전에 좋아요를 눌러놓은 위치의 셀들에서 하트가 클릭된 상태로 화면에 나타나는 오류를 발견했다. <br>
전에 사용한 셀이 재사용 되어서 나타나는 문제로 인식하고, tableview의 delegate를 이용해서 셀을 재사용할때 재사용이 가능하도록 셀을 준비해준다는 prepareForeReuse() 함수를 불러왔다. 함수 내에 셀이 재사용되기 전에 해줘야 할 액션을 지정해주었다. (버튼의 이미지를 빈 하트로 만들어주기) <br>
TableView가 자동으로 처리해주기 때문에 따로 함수를 호출할 필요도 없었다. 이렇게 prepareForReuse() 메서드를 통해 간편하게 셀의 재사용을 관리하고 데이터 무결성을 유지할 수 있었다!


- 클래스 인스턴스 변수 값 공유 오류
```swift

if (shoppingTable != nil) {
            tempTable = ShoppingTable(productName: shoppingTable.productName, addedDate: shoppingTable.addedDate, mallName: shoppingTable.mallName, price: shoppingTable.price, imageData: shoppingTable.imageData, liked: shoppingTable.liked, productID: shoppingTable.productID)
            tempProductID = shoppingTable.productID
        } else {
            tempProductID = shoppingItem.productID
        }

```
 처음에는 tempTable를 tempTable = shoppingTable로 선언했었는데, 이때 shoppingTable 변경될 때 tempTable 값이 같이 변경되는 오류를 발견했다.<br>
 바로 ShoppingTable이 class로 선언되었기 때문이었다! <br>
 클래스 인스턴스인 shoppingTable은 참조 타입으로, 변수에 대입할 때 해당 변수의 메모리 주소 값이 전달된다.<br>
 따라서 동일한 인스턴스를 참조하게 되면 하나의 인스턴스를 수정하면 다른 변수에서도 해당 변경사항이 반영되었던 것이다.<br>
 이를 해결하기 위해 변수에 값을 부여할 때 같은 객체를 참조하도록 하지 않고 tempTable = ShoppingTable(name: shoppingTable.name, ...)와 같이 값을 복사해서 전달해주는 것으로 코드를 수정했다.<br>
 class는 참조 타입, struct는 값 타입. 기존에 알고 있던 내용인데도 코드로 마주치니 헷갈렸던 것 같다. 이번 기회를 통해 이론으로 배웠던 내용을 직접 확인해 보고, 확실히 이해하고 넘어갈 수 있어서 좋았다.

