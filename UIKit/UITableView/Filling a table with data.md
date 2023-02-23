# Filling a table with data
> 데이터 소스 객체를 사용하여 테이블에 대한 셀을 동적으로 만들고 구성하거나 스토리보드에서 정적으로 제공

## Overview
- 테이블 뷰는 인터페이스의 data-driven 요소이다.
- 개발자가 데이터 소스 객체(`UITableViewDataSource` 프로토콜을 채택한 객체)를 사용하여 화면에 해당 데이터의 각 부분을 렌더링하는 데 필요한 뷰와 함께 앱의 데이터를 제공
- 테이블 뷰는 화면을 정렬하고 데이터 최신상태를 업데이트한다.
- 데이터를 섹션과 행으로 관리
- 행은 각각의 데이터 아이템을 표시하고 섹션은 관련있는 행을 그룹화 한다.
- 섹션은 필수사항은 아니지만 계층이 있는 데이터를 관리하는데 좋다.

<img src="https://i.imgur.com/vL37cyD.png" width ="400">

## 행과 섹션의 수 제공
- 화면에 띄우기 전, 테이블 뷰는 전체 행과 섹션의 수를 지정하도록 요청하고 데이터 소스 객체가 두가지 메서드를 이용하여 그 정보를 제공한다.

```swift
func numberOfSections(in tableView: UITableView) -> Int  // Optional 
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
```
- 이 두가지 메서드를 이용해서 행과 섹션의 수를 반환하려면 행과 섹션의 수를 검색하기 쉽게 구조화된 데이터로 변환이 필요할 수 있다.
   - 예) 배열을 이용하여 테이블 데이터 관리
   - 배열은 테이블 뷰 자체의 자연스러운 순서로 매치하기 때문에 섹션과 행을 관리하는데 좋은 툴이 된다.

- 데이터 소스 메서드를 이용한 예시

```swift
var hierarchicalData = [[String]]() 
 
override func numberOfSections(in tableView: UITableView) -> Int {
   return hierarchicalData.count
}
   
override func tableView(_ tableView: UITableView, 
                        numberOfRowsInSection section: Int) -> Int {
   return hierarchicalData[section].count
}

```
- 이 표에서 각 행은 문자열을 표시하므로 구현은 각 섹션에 대한 문자열 배열을 저장한다.
- 섹션을 관리하기 위해 `hierarchicalData` 배열을 이용
- 섹션의 수를 확인하기 위해 데이터 소스는 `hierarchicalData` 배열의 count를 반환한다.
- 특정 섹션에서 행의 수를 확인하기 위해 각각의 자식 배열의 값을 반환한다.

## 행의 모양 정의

- 셀을 이용하여 스토리 보드에서 모양을 정의할 수 있다.
- `UITableViewCell` 객체를 템플릿처럼 사용
- 셀은 뷰이고 서브뷰를 가질 수 있다.
- label, image views, other views도 추가할 수 있고 제약을 이용하여 정렬할 수 있다.

- 인터페이스에 하나의 테이블 뷰를 추가하려면 하나의 prototype cell이 필요하고 더 많은 prototype cell을 추가하려면 테이블 뷰를 선택하고 Prototype Cells attribute를 업데이트 해야 한다. *prototype: 원래의 형태, 전형적인 예시를 의미
- 각각의 셀은 스타일이 있고, UIKit이 제공하는 표준스타일을 선택하거나 커스텀 스타일을 만들 수 있다.

<img src="https://i.imgur.com/CVIEZu6.png" width="400">

- 스토리보드 파일에서 각 프로토타입 셀의 액션을 수행
   - 스타일 설정 (표준 or 커스텀)
   - cell identifier 속성에 비어있지 않은 문자열 할당
   - 커스텀 셀의 경우 셀에 뷰와 제약을 추가
   - Identity inspector에서 커스텀 셀의 클래스를 구체화

- 셀을 커스텀 하는 방법
   - UITableViewCell의 서브클래스를 정의해서 뷰를 관리한다. (이미지뷰의 변수명을 imageView로 하지않기!)
   - 셀의 컨텐츠뷰에 서브뷰 추가하기
- 서브클래스에 앱의 데이터를 보여줄 커스텀 뷰의 아울렛을 추가하고 스토리보드에서 실제 뷰와 아울렛을 연결시킨다.

## 각 행의 셀 구성 및 제작

- 테이블 뷰가 화면에 나타나기 전, 데이터 소스 객체에 테이블의 보이는 부분이나 그 근처의 행에 대한 셀을 제공하도록 요청하고 데이터 소스 객체의 `tableView(_:cellForRowAt:)` 메서드는 응답해야하고 아래와 같은 패턴을 이행한다.

   1. table view’s `dequeueReusableCell(withIdentifier:for:)` method 를 호출해서 셀 객체를 검색한다.
   2. 앱의 커스텀 데이터와 셀의 뷰를 구성한다.
   3. 테이블 뷰에게 셀을 리턴한다.

- 표준 셀 스타일인 경우, UITabelViewCell는 의 프로퍼티를 가지고 있다. 커스텀인 경우, design time에 셀에 뷰를 추가하고 아울렛으로 접근한다.


- 단일 텍스트 라벨을 가지고 있는 cell을 구성하는 예시(UITableViewCell의 textLabel 프로퍼티를 가지고 있다.)
- textLabel(주제목 레이블), detailTextLabel(추가 세부 사항 표시를 위한 부제목 레이블), imagView(이미지 표시를 위한 이미지뷰) 3가지 프로퍼티를 가진다.

```swift
override func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Ask for a cell of the appropriate type.
   let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        
   // Configure the cell’s contents with the row and section number.
   // The Basic cell style guarantees a label view is present in textLabel.
   cell.textLabel!.text = "Row \(indexPath.row)"
   return cell
}

```
- 테이블 뷰가 테이블의 행의 셀을 만들도록 요청하지 않고 대신에 테이블의 보이는 부분이나 근처에 있는 셀만 요청한다 (lazy) 그렇게 하여 테이블이 사용하는 메모리를 줄인다.
- 그러나, 그것은 데이터 소스 객체가 셀을 빠르게 만들어야만 한다는 의미이기도 하다. 그러므로`tableView(_:cellForRowAt:)` method를 사용하여 긴 작업을 하지 않도록 한다!


## 뷰의 재사용
- 화면에 사용할 수 있는 뷰의 개수는 한정되어 있고, 사용할 수 있는 메모리 또한 작아 뷰를 재사용함으로써 메모리르 절약하고 성능을 향상시킬 수 있다.

### 대표적인 예 & 재사용 원리
- 대표적인 예는 2가지가 있다.
  - UITableViewCell
  - UICollectionViewCell

- 원리
   1. 데이터 소스에 뷰(셀) 인스턴스 요청
   2. 새로운 셀을 만드는 대신 재사용 큐 (Reuse Queue)에 재사용을 위해 대기하고 있는 셀이 있는지 확인 후 있으면 그 셀에 새로운 데이터를 설정하고 없으면 새로운 셀을 생성
   3. 테이블 뷰 및 컬렉션뷰는 데이터소스가 셀을 반환하면 화면에 표시
   4. 스크롤하면 일부 셀들이 밖으로 사라지면서 다시 재사용 큐에 들어감
   5. 1-4번 과정 반복

<img src="https://i.imgur.com/Fwfh7JU.png" width="400">

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section < 2 {
            
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) // dequeueReusableCell: 재사용 가능한 cell을 꺼내어 쓴다는 의미
            
            let text: String = indexPath.section == 0 ? korean[indexPath.row] : english[indexPath.row]
            cell.textLabel?.text = text
            
            return cell
            
        }
```


## 참고
[Filling a table with data](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data)
[boostcourse](https://www.boostcourse.org/mo326/lecture/16892?isDesc=false)
