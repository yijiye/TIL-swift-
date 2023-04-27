# UITextView placeholder 적용

UITextView를 구현하고 textField 처럼 Placeholder를 적용하고 싶을 때 어떻게 하면 좋을지 알아보자

```swift
private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.text = "내용을 입력하세요"
    // placeholder와 같은 회색으로 설정
    textView.textColor = .secondaryLabel
   
    return textView
   }()
```

```swift
extension ViewController: UITextViewDelegate {
    // didBiginEditing: textView에 텍스트 입력이 시작되면 실행되는 함수
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 분기 설정
        guard textView.textColor == .secondaryLabel else { return }

        textView.text = nil
        textView.textColor = .label
    }
}
```

- UITextViewDelegate의 메서드를 활용하여 textView의 텍스트를 클릭하여 입력이 시작되면 text 내용을 nil로 처리하고 색을 원래 label의 색으로 바꿔주면 placeholder와 같은 효과를 줄 수 있다.
- 그리고 ViewController에 viewDidLoad()에서 `textView.delegate = self`를 해주면 된다.

