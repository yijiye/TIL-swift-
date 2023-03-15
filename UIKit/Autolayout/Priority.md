# autolayout hugging, compressionResistance priority

## setContentHuggingPriority(_:for)
> view의 intrinsic size 보다 커지는 것을 거부하는 우선 순위를 설정

<img src="https://i.imgur.com/88mRA6s.png" width="400">

</br>

 - priority : 우선순위를 부여
 `.default high` 높이가 고정되어야 할 객체
 `.default low` 높이가 조정될 객체
 `UILayoutPriority(Int)`  수치로 지정할 수 있음

 - axis : hugging priority를 설정해야하는 축을 설정

### 예시
```swift
alabel.setContentHuggingPriority(.defaultLow, for: .vertical)
blabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
```
- 두개의 label이 있을 때, hugging priority가 높으면 label의 높이가 고정되어 변하지 않는다.
- 즉, blabel의 크기는 고정되어 변하지 않게 된다.



## contentCompressionResistancePriority(for:)
> view가 intrinsic size 보다 작아지는 것을 거부하는 우선 순위를 반환

```bash
func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority
```

### 예시
- A label (글자수 100자)
- B label (글자수 5자)
```swift
A label.setContentCompressionResistancePrioity(.defaultHigh, for: .vertical)
Blabel.setContentCompressionResistancePrioity(.defaultLow, for: .vertical)
```
- A label의 모든 글자수가 보일때 까지 크기가 늘어나게 됨
- 반대로 priority가 상대적으로 작으면 글자수가 다 보이지 않음

## 참고
[공식문서-hugging](https://developer.apple.com/documentation/uikit/uiview/1622485-setcontenthuggingpriority)
[공식문서-contentCompressionResistancePriority](https://developer.apple.com/documentation/uikit/uiview/1622465-contentcompressionresistanceprio)
[sun02 velog](https://velog.io/@sun02/사이즈-조절-우선순위-설정)

