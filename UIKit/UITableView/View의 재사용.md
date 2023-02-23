# TableView, View의 재사용

<img src="https://i.imgur.com/Fwfh7JU.png" width="400">

- `datasource`에 cell 인스턴스를 요청한다.
- 재사용 큐에 대기중인 cell이 있으면 그 cell에 데이터를 선택하고대기중인 cell이 없으면 새로운 cell을 생성한다.
- `tableView`는 `datasource`가 cell을 리턴하면서 화면에 cell을 표시한다.
- 스크롤하면서 사라지는 cell은 다시 재사용 큐에 들어간다.
- 이러한 과정을 반복하여 cell의 재사용이 일어난다.

✅ 이렇게 `dequeue`, `reuse` 되는 과정이 `cellForRowAt delegate` 메소드에서 `dequeuReusableCellWithIdentifier`함수를 통해 이루어진 것!

## 재사용되는 cell의 속성 초기화

### tableViewDataSource method
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // 이 안에서 조건을 줄 수 있음 
}
```
- 이 메서드 안에는 **단순한 코드**만 넣어주는 것을 Apple에서는 권장하고 있다. 

### prepareForReuse 
- `UITableViewCell`은 `prepareForReuse` 메서드를 가지고 있고, 이 메서드는 셀이 재사용될 때 마다 호출되며 이전에 설정된 속성을 초기화하고 다음 셀에 대해 준비한다. 
- `UITableViewCell` 객체에 재사용 식별자가 있는 경우, 테이블 뷰는 `UITableView` 메서드 `dequeueReusableCell(withIdentifier:)`에서 객체를 반환하기 직전에 이 메서드를 호출!
- `UITableViewCell class`에 기본적으로 구현되어 있어 사용자 지정 `UITableViewCell` 하위 클래스에서 이 메서드를 `override` 하여 cell의 모든 속성을 초기화 해야 한다.

### 코드
```swift
class MyTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = .white
    }

}
```
- 스토리보드에서 `tableViewCell`에 `MyTableViewCell` 새로만든 클래스를 연결시켜주고 `override func prepareForReuse()` 메서드 안에 초기화 시켜주는 코드를 작성
- 코드의 위치와 의미가 좀 더 명확해진다. 왜냐면 prepareForReuse() 메서드는 재사용 직전에 호출되므로 직전에 기존 속성을 초기화 시켜준다는 의미가 적절하기 때문이다.
