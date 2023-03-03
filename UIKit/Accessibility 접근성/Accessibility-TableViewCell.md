# TableViewCell Contents Accessibility 적용

- 테이블 뷰에 VoiceOver를 실행해보니 Cell을 통째로 인식해서 내부의 Label Title이 모두 합쳐져 cell.accessibilityLabel에 설정되어 있음.

#### cell 내부 항목을 각각 voiceover로 나타내고 싶으면 어떻게 하면 좋을까?

**비공식 프로토콜 `UIAccessibilityContainer`**
- 직접 채택하여 구현할 수는 없지만 UIKit control이나 view는 `UIAccessibility` protocol을 암묵적으로 채택하고 있다.
- custom control의 경우 `UIAccessibilityElement` 라는 클래스를 상속시켜주는 것으로 접근성 지원이 가능하다.
- 암묵적으로 채택하고 있는 클래스는 해당 클래스의 subview를 선택적으로 accessibiliyElement로 만들어줄 수 있는 메서드 / 프로퍼티를 제공하고 있고 그 중에서 `var accessibilityElements: [Any]?`을 이용하여 해결

- tabelViewCell에 Accessibility를 적용할때 3가지 조건이 있다.
   1. cell 자체에 VoiceOver가 접근하지 못하도록 해준다.
   2. cell.accessibilityElements에 label, imageView를 추가한다.
   3. 각각의 subview들의 accessibilityProperty를 설정한다.


#### 소스코드
```swift
func setAccessibilityProperties(itemName: String, shortDescription: String) {
    self.itemNameLabel.accessibilityLabel = itemName
        
    self.shortDescriptionLabel.accessibilityLabel = "짧은 설명"
    self.shortDescriptionLabel.accessibilityValue = shortDescription
        
    self.itemImageView.isAccessibilityElement = true
    self.itemImageView.accessibilityLabel = itemName
    self.itemImageView.accessibilityTraits = .image
    self.itemImageView.accessibilityHint = "현재 셀을 선택하면 상세 화면으로 이동합니다."
        
    self.isAccessibilityElement = false
    self.accessibilityElements = [
        self.itemNameLabel!,
        self.shortDescriptionLabel!,
        self.itemImageView!
    ]
}
```

#### 내부 속성에 접근한다면 tableViewCell이 눌렸을 때, cell 전체에 accessibilityHint를 적용하고 싶으면 어떻게 할 수 있을까?
- 현재는 내부 속성에 접근하였기 때문에 전체로 인식하지 못하고 하나씩 인식한다 따라서 imageView에 accessibilityHint에 VoiceOver를 적용하는 방식으로 풀었다. 



## 참고
[UIAccessilbility 공식문서](https://developer.apple.com/documentation/objectivec/nsobject/uiaccessibility)
[accessibilityElement 공식문서](https://developer.apple.com/documentation/appkit/nsaccessibility/1535002-accessibilityelement)
