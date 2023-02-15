# Table views
> 사용자 정의 가능한 행의 단일 열에 데이터를 표시한다.

## Overview
- 테이블 뷰는 행과 섹션으로 나뉘어 있는 수직적으로 스크롤링 컨텐츠의 하나의 column(열)을 표시한다.
- 한 테이블의 각 행은 앱과 관련있는 정보의 단일 조각들을 표시한다.
- 섹션은 관련있는 행을 그룹화하는 것을 의미한다. 
- 예를들어 연락처 앱은 유저의 연락처의 이름들을 표시할때 테이블을 사용한다.
- 테이블 뷰는 여러 객체간 콜라보레이션이다.
    - **Cells** 
    하나의 셀은 컨텐츠의 시각적 표현을 제공한다. UIKit에서 제공하는 디폴트 셀을 사용할수도 있고, 앱의 니즈에 맞는 셀을 커스텀화하여 사용할 수도 있다.
    - **Table view controller**
    테이블 뷰를 관리할 때UITableViewController를 사용한다. 다른 view controller를 사용할수 있지만 일부 테이블 관련 기능을 작동하려면 table view controller가 필요하다.
    - **Data source object**
    UITabelViewDataSource 프로토콜을 채택하고 테이블을 위한 데이터를 제공한다.
    - **Delegate object**
    UITableViewDelegate 프로토콜을 채택하고 테이블의 컨텐츠와 유저가 서로 상호작용하도록 관리한다.

## UITableView class
> 단일 열에 행을 사용하여 데이터를 나타내는 뷰

<img src="https://i.imgur.com/dFpWJXL.png" width="500">

### Overview
- 테이블은 고도로 구조화되거나 계층적으로 구성된 데이터가 있는 앱에서 일반적이다. 
- 계층적 데이터가 포함된 앱은 종종 네비게이션 뷰 컨트롤러와 함께 테이블을 사용하여 `계층 구조의 다른 수준 간의 네비게이션`을 용이하게 해준다. 
    - 예시) 설정 앱은 테이블과 내비게이션 컨트롤러를 사용하여 시스템 설정을 구성한다.
- `UITableView`는 테이블의 기본적인 모습을 관리하지만 앱은 실제 컨텐츠를 표시하는 cell(`UITableViewCell` 객체)을 제공한다.
- 표준 셀 구성은 텍스트와 이미지의 간단한 조합을 표시하지만 개발자가 원하는 컨텐츠를 표시하는 커스텀 셀을 만들 수도 있다.
- 또한 머리글과 바닥글 보기를 제공하여 셀 그룹에 대한 추가 정보를 제공할 수 있다.

### Add a table view to your interface
- 인터페이스에 테이블 뷰를 추가하려면 table view controller (`UITableViewController`) 객체를 스토리보드에 드래그하면 된다.
- Xcode는 뷰 컨트롤러와 테이블뷰를 가지고 있는 새로운 화면을 만들고 개발자가 사용할 수 있게 준비한다.
- 테이블 뷰는 데이터 기반으로 일반적으로 개발자가 제공하는 `데이터 소스 객체`로 부터 데이터를 불러온다.
- 데이터 소스 객체는 앱의 데이터를 관리하고 테이블의 셀을 만들고 구성하는데 책임이 있다.
- 만약 테이블의 컨텐츠가 절대 바뀌지 않는다면 대신 스토리보드 파일에서 컨텐츠를 구성할 수 있다.

#### <details><summary>[UITableViewCell](https://developer.apple.com/documentation/uikit/uitableviewcell)</summary>
    
> 테이블 뷰에서 단일 행의 시각적 표현

<img src="https://i.imgur.com/oFNZHSG.png" width="500">

- 단일 테이블 행의 컨텐츠를 관리하는 특별한 타입이다.
- 주로 앱의 사용자 지정 콘텐츠를 구성하고 표시하기 위해 셀을 사용하지만, UITableViewCell은 다음과 같은 테이블 관련 동작을 지원하기 위해 몇 가지 특정 사용자 지정을 제공한다.
   - 셀의 선택 또는 하이라이크 색상 제공 
   - 세부사항이나 공개통제와 같은 표준 악세서리 뷰 추가
   - 편집 가능한 상태로 변경하기
   - 셀의 내용을 들여쓰기하여 테이블에 시각적 계층 구조 제공

- 앱의 컨텐츠는 대부분의 셀의 바운드를 차지한다 그러나 셀은 다른 컨텐츠를 위한 공간을 조정해야한다.
- 셀은 컨텐츠 영역의 trailing edge에 악세서리 뷰를 나타낸다.
- 편집 모드일 때, 셀은 컨텐츠 영역의 leading edge에 삭제 컨트롤을 추가하고 선택적으로 악세서리 뷰를 재정렬 컨트롤로 변경한다.

<img src="https://i.imgur.com/QkhwAnW.png" width="500">

- 모든 테이블 뷰는 적어도 한개 이상의 표시하는 컨텐츠 셀을 가져야하고 테이블은 다른 타입의 컨텐츠를 표시하기 위해 여러 셀 타입을 가진다.
- 테이블 데이터 소스 객체는 온스크린 하기 전 셀의 구성과 생성을 핸들링한다.

#### 셀 컨텐츠 구성
- 스토리보드 파일에서 셀의 레이아웃과 컨텐츠를 구성한다.
- 테이블은 디폴트로 하나의 셀 타입을 가지고 있지만 테이블의 Prototype Cells attribute에서 값을 변경하여 더 추가할 수도 있다.
- 셀 컨텐츠를 구성하는 것 외에 아래와 같은 속성을 구성해야한다.
   - Identifier : cell을 만들기 위해 reuse identifier로 알려져 있는 identifier를 사용
   - Style : 커스텀 cell이나 표준 타입 중 하나를 선택
   - Class : 사용자 지정 동작으로 UITabelViewCell subclass를 정의

- 테이블 뷰 만들기
  - [init(style:reuseIdentifier)](https://developer.apple.com/documentation/uikit/uitableviewcell/1623276-init)
    
</details>

### Save and restore the table's current state
- 테이블 뷰는 UIKit app 복원를 지원한다.
- 테이블의 데이터를 복원하고 저장하기 위해 테이블 뷰의 `restoration Identifier` 프로퍼티에 비어있지 않은 값을 할당한다.
- 부모 view controller를 저장할 때, 테이블 뷰는 자동적으로 현재 선택되고 보이는 행의 인덱스 경로를 자동으로 저장한다.
- 만약 테이블의 데이터 소스 객체가 UIDataSourceModelAssociation 프로토콜을 채택한다면, 테이블은 그것들의 인덱스 경로 대신에 아이템에 제공하는 특정 ID를 저장한다.

#### <details><summary>[RestorationIdentifier](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621499-restorationidentifier)</summary>
    
>뷰 컨트롤러가 상태 복원을 지원하는지 여부를 결정하는 식별자

<img src="https://i.imgur.com/J1V41rG.png" width="500">

- 이 프로퍼티는 뷰 컨트롤러와 그 내용을 보존해야 하는지 여부를 나타내며 복원 과정에서 뷰 컨트롤러를 식별하는 데 사용된다.
- 디폴트 값은 `nil`이며 뷰 컨트롤러가 저장할것이 없다는 것을 의미한다.
- 프로퍼티에 문자열 객체를 할당하면 뷰 컨트롤러가 저장할 것이 있다는 것을 시스템에게 알려주고 문자열 컨텐츠는 뷰 컨트롤러의 목적을 식별하는 방법이될 수 있다.
- **간단히 프로퍼티 값을 세팅하는 것은 뷰컨트롤러가 저장하고 복원해야하는 것을 보증하기 충분하지 않다. 모든 부모 뷰 컨틀롤러가 restoration identifier를 가져야만 한다.**
</details>

## UITableViewController
> 테이블 뷰를 관리하는 view controller

<img src="https://i.imgur.com/ZhFPkdH.png" width="500">

### Overview
[참고링크](https://developer.apple.com/documentation/uikit/uitableviewcontroller)
- 인터페이스가 테이블 뷰를 구성되어 있고 다른 컨텐트가 거의 없거나 또는 전혀 없는 경우 UITableViewController 하위클래스.
- 테이블 뷰 컨트롤러는 이미 테이블 뷰의 관리하고 변화에 반응하는에 필요한 프로토콜을 채택하고 있다.
- UITableViewController가 포함하고 있는 기능
   - tableView 프로퍼티를 사용하여 접근가능한 스토리보드 또는 nib 파일에 보관된 테이블 뷰를 자동으로 로드할 수 있다.
   - 테이블 뷰의 데이터 소스와 delegate를 self로 설정
   - `viewWillAppear(_:)` 메소드를 실행하고, 첫 등장 시 테이블 뷰의 데이터를 자동으로 다시 로드하고, 테이블 뷰가 나타날 때마다 선택(요청에 따라 애니메이션 유무에 관계없이)을 지운다.(`clearsSelectionOnViewWillAppear`의 값을 변경하여 이 마지막 동작을 비활성화)
   - `viewDidAppear(_:)` 메소드를 실행하고 처음 나타날 때 테이블 뷰의 스크롤 표시기를 자동으로 깜박이게 한다.
   - `setEditing(_:animated:)` 메소드를 실행하고 사용자가 네비게이션 바에서 Edit|Done 버튼을 탭하면 테이블의 편집 모드를 자동으로 전환한다.
   - 화면 키보드의 나타나게하거나 사라지게하기 위해 테이블 뷰의 크기를 자동으로 조정한다.

- 테이블 뷰 컨트롤러를 초기화 할때, 반드시 테이블 뷰의 스타일을 지정해야한다 (그룹화 or 일반화)
- 데이터로 테이블을 채우려면 delegate 메서드와 데이터 소스를 재정의 해야한다.
- loadView() 또는 다른 슈퍼클래스 메서드를 재정의할 수 있지만, 그럴 경우 일반적으로 첫 번째 메서드 호출로 메서드의 슈퍼클래스 구현을 호출해야 한다.


## UITableViewDataSource
> 객체가 데이터를 관리하고 테이블 뷰를 위한 셀을 제공하기 위해 채택하는 프로토콜

<img src="https://i.imgur.com/CV3hCVt.png" width="500">

### Overview
[참고링크](https://developer.apple.com/documentation/uikit/uitableviewdatasource)
- 테이블 뷰는 데이터의 프레젠테이션만 관리하고 데이터를 관리하려면, `UITableViewDataSource` 프로토콜을 구현하는 객체인 `데이터 소스 객체`를 테이블에 제공해야한다.
- 데이터 소스 객체는 테이블의 데이터 관련 요청에 반응하고 또한 테이블의 데이터를 직접 관리하거나 앱의 다른 부분과 조정하여 해당 데이터를 관리한다.
- 데이터 소스 객체의 다른 책임은 아래와 같다.

   - 표의 섹션과 행 수를 보고
   - 테이블의 각 행에 셀을 제공
   - 섹션 머리글과 바닥글에 대한 제목을 제공
   - 테이블의 인덱스를 구성
   - 기본 데이터를 변경해야 하는 사용자 또는 테이블이 시작한 업데이트에 대응

- 이 프로토콜의 두가지 메서드
```swift
// Return the number of rows for the table.     
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return 0
}

// Provide a cell object for each row.
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Fetch a cell of the appropriate type.
   let cell = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath)
   
   // Configure the cell’s contents.
   cell.textLabel!.text = "Cell text"
       
   return cell
}
```
- `tableView(_:commit:forRowAt:)` 는 swipe-to-delete 기능을 할 수 있는 또 다른 메서드이다.

### 행과 섹션 위치 정하기
- 테이블 뷰는 `NSIndexPath` 객체의 프로퍼티인 행과 섹션을 사용하여 셀의 위치를 조정할 수 있다.
- 행과 섹션의 기본 indexsms 0이다 => First section은 index 0, second은 index 1
- 만약 테이블이 섹션이 없으면 row 값만 필요하다.
<img src="https://i.imgur.com/xfA1ycW.png" width="500">

## UITableViewDelegate
> 선택 관리, 섹션 머리글 및 바닥글 구성, 셀 삭제 및 재정렬, 테이블 보기에서 다른 작업을 수행하는 방법

<img src="https://i.imgur.com/IAZFC7I.png" width="500">

### Overview
[참고링크](https://developer.apple.com/documentation/uikit/uitableviewdelegate)
- 사용자 지정 머리글과 바닥글 보기를 만들고 관리할 수 있다.
- 행, 머리글 및 바닥글에 대한 사용자 지정 높이를 지정할 수 있다.
- 더 나은 스크롤 지원을 위해 높이 추정치를 제공
- 행 내용을 들여쓰기
- 행 선택에 응답하기
- 테이블 행의 스와이프 및 기타 작업에 응답하기
- 테이블의 내용 편집지원


