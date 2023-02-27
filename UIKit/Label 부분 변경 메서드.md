# Label 부분 변경 메소드
- text에서 일부 글자의 속성을 다르게 설정해야하는 경우 사용할 수 있다.

## NSMutableAttributedString
> 텍스트의 일부에 대한 관련 속성(예: 시각적 스타일, 하이퍼링크 또는 접근성 데이터)이 있는 변경 가능한 문자열.

```swift
private func convertTextSize(of label: UILabel, range: NSRange) {
        guard let target = label.text else { return }
        
        let fontSize = UIFont.systemFont(ofSize: 20)
        let attributedString = NSMutableAttributedString(string: target)
        
        attributedString.addAttribute(.font, value: fontSize, range: range)
        label.attributedText = attributedString
    }
```
- 텍스트의 일부 속성을 변경하기위해 `NSMutableAttributedString(String:)`을 attributedString 상수로 선언함
- `addAttribute(_:value:range:)` 인스턴스 메서드를 사용하여 지정된 범위의 문자에 주어진 이름과 값을 가진 속성을 추가

<img src="https://i.imgur.com/vq2Cn9N.png" width="400">

- 띄워줄 label에 `attributedText` 메서드를 사용하여 변경된 속성을 부여해줌
- range의 경우 index로 접근할수도 있고 특정 문자열을 입력하여 접근할 수도 있다.
   - NSMakeRange(Int,Int) : Int 부터 Int까지의 문자열, 지정된 값에서 새 NSRange를 만드는 메서드
   - range: (text as NSString).range(of: "특정문자열")

# decode 
- JSON 형식의 데이터를 불러오는 것을 step2에 들어가면서 진행했다. 그런데 try로 메서드를 호출하길래 어떤 형태로 되어있는지 찾아보았다.

## decode 메서드 형태

<img src="https://i.imgur.com/cAbvZaI.png" width="400">

- type 파라미터는 제공된 JSON 객체서 디코딩할 값의 유형을 의미한다.
- data 파라미터는 디코딩할 JSON 객체를 의미한다.

## Error

- 공식문서에 따르면, data가 유효하지 않은 JSON이라면 `decode`메서드가 `DecodingError.dataCorrupted(_:)` error를 던진다고 나와있다. 또한 디코딩에 실패하면, 이 메서드는 해당 오류를 던진다.
- `DecodingError`에 기본 구현으로는 `LocalizedError` 가 있다. 따라서 do-catch 구문에서 오류를 처리할 때, `error.localizedDescription` 을 사용하여 처리한다.

### localizedError
> 오류와 오류가 발생한 이유를 localized 메세지로 제공하는 protocol

- 해당 프로토콜을 준수하고, computed 프로퍼티를 정의하여 사용할 수 있다.
   - `errorDescription: String? { get }`
   - `failureReason: String? { get }`
   - `recoverySuggestion: String? { get }`
   - `halpAnchor: String? { get }`

- errorDescription을 정의하면 .localizedDescription을 사용할 수 있다.

```swift
import Foundation

enum someError: Error {
    case errorA
    case errorB
}

extension someError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .errorA:
            return "오류A"
        case .errorB:
            return "오류B"
        }
    }
}
print(someError.errorB.localizedDescription) // 오류B
```

# ImageSet

- UIImage 및 NSImage 인스턴스에 사용되는 named image asset의 그래픽 이미지 파일들.
- 프로젝트에 사용할 Image 파일을 Asset에 등록하여 사용하기 위해서 imageset으로 생성, 삽입해야 한다.
- 이후, 코드에서 imageset에 저장된 image를 사용하려면 `UIImage`, `NSImage` 인스턴스를 생성해야 한다.

```swift
// SwiftUI
let image = Image("ImageName")

// UIKit
let image = UIImage(named: "ImageName")

// AppKit
let image = NSImage(named: "ImageName")
```
----

## 참고
[NSMUtableAtrributedString 공식문서](https://developer.apple.com/documentation/foundation/nsmutableattributedstring/)
[zedd 블로그,NSMutableAttributedString](https://zeddios.tistory.com/300)
[decode 공식문서](https://developer.apple.com/documentation/foundation/jsondecoder/2895189-decode)
[DecodingError 공식문서](https://developer.apple.com/documentation/swift/decodingerror)
[김종권-localizedError](https://ios-development.tistory.com/849)

