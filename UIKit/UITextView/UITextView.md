# UITextView
> 스크롤이 가능한, 여러줄의 텍스트가 보여지는 view

## Overview
- custom 스타일이나 text editing을 지원하는 텍스트를 보여줄 수 있다.
- 주로 여러줄의 text를 화면에 띄울 때 사용한다.
- `attributedText` 프로퍼티로 다양한 텍스트 스타일을 지원한다.
- font, textColor, textAlignment도 사용 가능하지만 이런 프로퍼티는 전체 텍스트에만 지원가능하다.


### Manage the keyboard
사용자가 textView를 탭하면 textView는 first responder가 되고 자동으로 시스템에 연관된 키보드를 보여줄지 묻는다. tableView와 같은 view는 first responder를 자동으로 스크롤하여 도와줍니다. 그러나 first responder가 스크롤 영역 하단에 있다면, 첫 번째 응답자가 보이도록 스크롤 뷰 자체의 크기를 조정하거나 위치를 변경해야 할 수도 있다.

사용자의 액션에 따라 키보드를 사라지게 하고 싶다면 `resignFirstResponder()` 메세지를 현재 first responder인 textView에 전달하면 된다. 그렇게 하면 텍스트 보기 객체가 현재 편집 세션을 종료하고(delegate 객체의 동의하에) 키보드를 숨긴다.

키보드 자체의 모습을 커스텀화 하고 싶으면 `UITextInputTraites`  프로토콜이 제공하는 프로퍼티를 활용하면 된다. ASCII, Numbers, URL, Email 기타 등등 사용할 수 있다.

### Keyboard notifications
시스템이 키보드를 보여주거나 숨길 때, 몇가지 키보드 notification을 포스팅한다. 이런 notification은 키보드의 정보 (사이즈와 같은)를 가지고 있어 view를 resizing하는 것을 계산하는데 도와준다.
- keyboardWillShowNotification
- keyboardDidShowNotification
- keyboardWillHideNotification
- keyboardDidHideNotification

### State preservation
iOS6 버전 이후에 만약 view의 `restoration Identifier` 프로퍼티에 값을 할당한다면 아래와 같은 정보를 보존하게 된다.
- 텍스트의 범위를 선택 `selectedRange`
- textView의 상태를 관리 `isEditable`

다음 출시 cycle동안, view는 이러한 속성을 저장된 값으로 복원하려고 시도한다. restored view의 텍스트에 선택 범위를 적용할 수 없는 경우, 텍스트가 선택되지 않는다.



## 참고
- [UITextView 공식문서](https://developer.apple.com/documentation/uikit/uitextview/)
