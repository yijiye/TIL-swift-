# keyboard 구현

## keyboardFrameEndUserInfoKey
> 애니메이션 끝에 키보드의 프레임을 검색하는 사용자 정보 키.

이 키의 값은 키보드를 애니메이션화한 후 키보드의 frame 직사각형(화면의 좌표 공간)을 식별하기 위한 CGRect를 포함하는 NSValue 객체이다. frmae 직사각형은 장치의 현재 방향을 반영한다.

```bash
Important 
이 키를 사용하여 키보드의 프레임을 추적하는 대신, 앱에서 키보드 움직임에 동적으로 반응할 수 있는 UIKeyboardLayoutGuide를 사용하기
```

```swift
guard let userInfo = notification.userInfo else { return }

// iOS 16 버전 이후 keyboard notification 객체는 keyboard 가 나타난 화면을 의미
guard let screen = notification.object as? UIScreen,
      // 애니메이션의 끝에 keyboard 프레임을 얻는다.
      let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
// 변환할 좌표 공간을 확인 
let fromCoordinateSpace = screen.coordinateSpace

let toCoordinateSpace: UICoordinateSpace = view

// 키보드의 프레임을 화면의 좌표 공간에서 보기의 좌표 공간으로 변환하기 
let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
```

키보드는 view의 일부와 겹칠 수 있어 frame을 view의 좌표 공간으로 변환한 후, 키보드의frame과 겹치는 view 또는 window의 교차점을 확인한다.
이 값을 사용해서 view를 offset 하거나 UI에 필요한 다른 업데이트를 수행할 수 있다.
아래 예제는 키보드 frame과 관련하여 view 하단의 거리를 offset 하는 방법이다.

```swift
// 키보드가 offscreen 일때 
var bottomOffset = view.safeAreaInsets.bottom
    
// 키보드의 Frame과 view의 bounds의 교착점을 확인 
let viewIntersection = view.bounds.intersection(convertedKeyboardFrameEnd)
    
// offset을 조정하기 전 교착점이 있는지 없는지 확인 
if !viewIntersection.isEmpty {
        
    // view의 height과 교착지점 사각형의 height 사이의 차이에 의한 offset 조정
    bottomOffset = view.bounds.maxY - viewIntersection.minY
}

// UI를 조정하기 위한 새로운 offset 적용
movingBottomConstraint.constant = bottomOffset
```

## keyboardFrameBeginUserInfoKey
> 애니메이션의 시작 부분에서 키보드의 프레임을 검색하는 사용자 정보 키.

`keyboardFrameEndUserInfoKey`와 달리 키보드의 애니메이션이 일어기 전 키보드의 frame 사각형을 identify 하는 CGRect를 포함하는 NSValue의 key 값이다. 

이 둘은 모두 키보드 frame 정보를 제공하지만 서로 다른 시점을 나타낸다.

- `keyboardFrameBeginUserInfoKey`는 키보드가 활성화 되기 전에 키보드 프레임을 나타내며 사용자가 textView를 탭해서 입력하기 전 이것을 통해 키보드의 높이를 알 수 있다.
- `keyboardFrameEndUserInfoKey`는 키보드가 활성화된 후 키보드 프레임을 나타낸다.


## keyboard notification
keyboard가 나타났다 사라지는 알림을 주는 notification

```swift
private func setUpNotification() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
    )
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
    )
}
```

## keyboard가 올라왔을 때, view와 겹치지 않도록 구현

```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo as NSDictionary?,
          var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
    keyboardFrame = view.convert(keyboardFrame, from: nil)
    var contentInset = diaryTextView.contentInset
    contentInset.bottom = keyboardFrame.size.height
    diaryTextView.contentInset = contentInset
    diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
}
    
@objc private func keyboardWillHide(_ notification: Notification) {
    diaryTextView.contentInset = UIEdgeInsets.zero
    diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
}
```

- userInfo : notification에서 사용자 정보를 나타내는 NSDictionary 인스턴스
- keyboardFrame : 키보드 프레임을 나타내는 CGRect
- view.convert(,from:) : view 좌표계에 전달된 좌표를 view의 좌표계로 변환
- contentInset : textView의 내부 컨텐츠와 경계 사이의 간격을 나타냄
bottom 을 keyboardFrame의 높이만큼 올려주어 겹치는 것을 방지
- diaryTextView.scrollIndicatorInsets : textView 스크롤을 표시할 값을 textView의 contentInset으로 잡아줌
- 키보드가 사라지면 다시 원위치로 돌리는 코드를 WillHide에 구현

[UIView.animation으로 키보드 구현하기](https://poky-develop.tistory.com/18)

## 화면 밖을 터치했을 때, 키보드 내리기
`UITapGestureRecognizer`를 활용하여 키보드를 내릴 수 있다.

```swift
private func hideKeyBoard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
}

@objc private func dismissKeyboard() {
    view.endEditing(true)
}
```

이때 키보드가 내려가면서 notification에 알림이 발생한다.


## 참고
- [keyboardFrameEndUserInfoKey 공식문서](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey) 
- [keyboardFrameBeginUserInfoKey 공식문서](https://developer.apple.com/documentation/uikit/uiresponder/1621616-keyboardframebeginuserinfokey)
- [keyboard가 TextView를 가릴때 hoBahk.log](https://velog.io/@qudgh849/keyboard가-TextView를-가릴-때)
