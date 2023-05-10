# UICalendarView
> 달력화면 구현
> iOS 16.0+

CalendarView를 이용하여 사용자 정의한 장식을 사용하여 추가 정보(예: 예정된 이벤트)가 있는 특정 날짜를 표시할 수 있다. 또한 사용자가 특정 날짜, 여러 날짜 또는 날짜 없음을 선택할 수 있다.

### 인터페이스에 UICalendarView 추가하는 방법

1. 캘린더와 Locale 구현
2. 처음에 볼 수 있도록 캘린더 뷰의 날짜 설정
3. 원하는 경우, 특정 날짜에 decoration을 제공할 delegate 구현
4. 선택 방법을 설정하고 날짜 선택을 처리하도록delegate에 위임
5. calendarView autolayout 설정

#### Configure a calendar view
```swift
let calendarView = UICalendarView()
let gregorianCalendar = Calendar(identifier: .gregorian)
calendarView.calendar = gregorianCalendar
calendarView.locale = Locale(identifier: "zh_TW") // 한국의 locale 은 "ko-KR" 이다.
calendarView.fontDesign = .rounded
```
**처음 날짜 설정하기**
```swift
calendarView.visibleDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2022, month: 6, day: 6) 

// 현재날짜로 설정하기
calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now)
```

#### Display decorations for specific dates
특정날짜에 표시를 하는등 이벤트를 넣으려면 아래 코드와 같이 `UICalendarViewDelegate`를 사용할 수 있다.

```swift
class MyEventDatabase: NSObject, UICalendarViewDelegate {
    // Your database implementation goes here.
    func calendarView(_ calendarView: UICalendarView, decorationFor: DateComponents) -> UICalendarView.Decoration? {
        // Create and return calendar decorations here.
    }
}

let database = MyEventDatabase()
calendarView.delegate = database
```

[자세한 내용은 여기에서 확인](https://developer.apple.com/documentation/uikit/uicalendarview#3992448)

#### Handle date selection
사용자가 캘린더 뷰에서 단일 날짜 또는 여러 날짜를 선택할 수 있도록 구현할 수 있다.
- 어떤 유형의 날짜를 원하는지 선택하기
- 그런 다음 해당 유형에 대한 객체와 delegate를 만들고, selectionBehavior에 할당하기

```swift
let dateSelection = UICalendarSelectionSingleDate(delegate: self)
calendarView.selectionBehavior = dateSelection
```

- 그런 다음 사용자는 달력 보기에서 날짜를 선택할 수 있다. 다음 예와 같이 선택한 날짜를 프로그래밍 방식으로 설정할 수 있다.

```swift
dateSelection.selectedDate(DateComponents(calendar: Calendar(identifier: .gregorian), year:2022, month: 6, day: 6))
```

- 다음으로, 날짜 선택 처리를 사용자 정의하기 위해 선택 방법에 대한 delegate 방법을 구현하기

```swift
func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
    // Return `true` to allow a date selection; a nil date clears the selection.
    // Require a date selection by returning false if dateComponents is nil.
    return dateComponents != nil
}
```

#### 직접 구현해보기
```swift
private func configureCalendarView() {
    calendarView.calendar = Calendar(identifier: .gregorian)
    calendarView.locale = Locale(identifier: "ko-KR")
    calendarView.fontDesign = .rounded
    calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now)
        
    guard let selectedDate = delegate?.selectedDate else { return }
        
    let dateSelection = UICalendarSelectionSingleDate(delegate: self)
    //date 타입을 dateComponent로 바꾸는 방법
    let dataComponent = calendarView.calendar.dateComponents([.year, .month, .day], from: selectedDate)
    dateSelection.setSelected(dataComponent, animated: true)
    calendarView.selectionBehavior = dateSelection
```
#### date 타입을 dateComponent 타입으로 변환

```swift
func dateComponents(
    _ components: Set<Calendar.Component>,
    from date: Date
) -> DateComponents
```
를 사용하여 변환할 수 있다. 이때 components에 들어갈 타입을 확인해보기 위해 Calendar.Component를 확인해보면 공식문서에서 아래와 같이 적혀있는 것을 확인할 수 있다.

```swift
let myCalendar = Calendar(identifier: .gregorian)
let ymd = myCalendar.dateComponents([.year, .month, .day], from: Date())
```

따라서 예제코드에서 date타입을 dateComponents 타입으로 바꾸기 위해 이 방법을 적용하였다.

#### setSelected(:animated:)
셀의 선택된 상태를 설정하고, 상태 간의 전환을 애니메이션화 할 수 있다. (애니메이션은 옵셔널)
```swift
func setSelected(
    _ selected: Bool,
    animated: Bool
)
```

- selected : cell이 선택된 상태인지 확인하는 bool 타입으로 선택되면 true이고 default는 false 이다.

예제코드에서는 화면간 선택된 날짜에 대한 데이터를 전달받는 기능이 필요하여 `UICalendarSelectionSingleDate(delegate: self)` 를 새로 구현하고 선택된 날짜를 `dateComponent` 타입으로 바꾼 뒤, `setSelected`에 넣어주도록 구현하였다. 

## 참고
- [공식문서-UICalendarView](https://developer.apple.com/documentation/uikit/uicalendarview#3992448)
- [공식문서-dateComponents](https://developer.apple.com/documentation/foundation/calendar/2293646-datecomponents)
- [공식문서-setSelected](https://developer.apple.com/documentation/uikit/uitableviewcell/1623255-setselected)
