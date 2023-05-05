# UITextViewDelegate
> textView객체에 대한 편집 관련 메세지를 받는 방법

이 protocol의 메서드는 모두 옵셔널이고 상황에 맞는 메서드를 선택해서 활용할 수 있다.

## textViewShouldBeginEditing(_: )
특정 textView에서 편집을 시작할 것인지 아닌지 delegate에 물어보는 메서드

```swift
optional func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
```
리턴값이 true면 편집가능하고, false면 불가능하다.
사용자가 일반적으로 편집 세션을 시작하는 작업을 수행할 때, textView는 이 메서드를 먼저 호출하여 편집이 실제로 진행되어야 하는지 확인한다. 대부분의 경우, 편집을 진행할 수 있도록 이 방법에서 true를 반환할 수 있다.

## textViewDidBeginEditing(_: )
특정 textView의 편집을 시작할 때 delegate에게 알려주는 메서드

```swift
optional func textViewDidBeginEditing(_ textView: UITextView)
```
사용자가 textView에서 편집을 시작한 직후, 실제 변화가 일어나기 전에 delegate에 이 메세지를 전달한다.
이 방법을 사용하여 편집 관련 데이터 구조를 설정하고 일반적으로 향후 편집 메시지를 받을 수 있도록 delegate를 준비할 수 있다.

## textViewShouldEndEditing(_: )
특정 textView에서 편집을 멈추는지 아닌지 delegate에 물어보는 메서드

```swift
optional func textViewShouldEndEditing(_ textView: UITextView) -> Bool
```

textView가 first responder 상태가 해제될 때 호출된다. 이것은 사용자가 편집 focus을 다른 컨트롤로 변경하려고 할 때 발생할 수 있다. 그러나 focus가 실제로 바뀌기 전에, 이 방법을 호출하여 delegate에게 그래야 하는지 여부를 결정할 기회를 제공한다.

대부분 true를 반환하지만, delegate가 textView의 내용을 검증하려는 경우 false를 반환할 수 있다. False를 반환하면 textView에 유효한 값이 포함될 때까지 사용자가 다른 컨트롤로 전환하는 것을 방지할 수 있다.

이 방법은 편집이 끝나야 하는지에 대한 권장 사항만 제공하기 때문에 이 방법에서 false를 반환하더라도, 편집은 끝날 수 있다. 예를 들어, 이것은 textView가 상위 view나 window에서 제거되어 first responder 상태를 사임해야 할 때 발생할 수 있다.

## textViewDidEndEditing(_: )
특정 textView의 편집이 끝날 때 delegate에 말하는 메서드

```swift
optional func textViewDidEndEditing(_ textView: UITextView)
```
textView는 보류 중인 편집을 닫고 first responder 상태를 사임한 후 이 메시지를 delegate에게 보낸다. 이 방법을 사용하여 데이터 구조를 파괴하거나 편집을 시작할 때 설정한 상태 정보를 변경할 수 있다.

## 참고
- [UITextViewDelegate 공식문서](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
