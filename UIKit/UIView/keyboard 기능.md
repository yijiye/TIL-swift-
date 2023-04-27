# keyboard가 자동으로 올라오게 하려면?

textView가 있는 화면이 나타나면 자동으로 keyboard가 위로 올라오게 하는 방법에 대해 알아보자.

우선 textView 공식문서를 살펴보면,

<img src="https://i.imgur.com/nC8WI79.png" width="400">

<br/>

textView를 터치하면 자동으로 first responder가 되어 관련된 키보드가 화면에 올라온다는 것을 알 수 있다.

UITextView의 프로퍼티 중 `.becomeFirstResponder()` 가 있어 이를 활용해보았다.

처음 시도한 것은 viewDidLoad()에 띄워봤는데, 그러면 화면에 내용이 이미 입력되어 있으면 화면이 바뀌는 것과 동시에 키보드가 보여 글씨랑 키보드 화면의 애니메이션이 어색해보였다.

이를 보완하고자 viewDidAppear() 에 호출하여 시간 텀을 살짝 주는 방식으로 해결할 수 있었다. 상황에 따라 맞는 생명주기를 호출하면 좋을 것 같다!

```swift
override func viewDidAppear(_ animated: Bool) {
    if isAutomaticKeyboard == true {
        diaryTextView.becomeFirstResponder()
    }
}
```

## 참고
- [공식문서](https://developer.apple.com/documentation/uikit/uiresponder/1621113-becomefirstresponder)
