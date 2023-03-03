# Accessibility (손쉬운사용)
> 얼마나 접근하기 쉬운지, 얼마나 많은 사람이 이용 가능한지의 정도
> 
> 사용자의 조건과 상관없이 가능한 많은 사용자가 불편없이 사용할 수 있도록 제품을 구성해야한다.
>
> 누구라도 동등하게 `정보`에 접근할 수 있어야 한다.

## Apple의 Accessibility 

### Vision (시각)
- 텍스트 크기를 확대/ 축소
- VoiceOver : 문자를 읽어주는 말하기 기능
- 화면 요소의 움직임을 줄이는 동작 
- 화면의 다크, 라이트모드 지원
- Siri
- 받아쓰기

### Hearing (청각)
- 보청기기
- 화재경보, 초인종등 소리르 감지해 화면에 표시하는 소리 인식 기능
- 청각 장애인용 자막 지원

### Mobility (운동능력)
- 음성명령
- 스위치 제어
- AssistiveTouch : 누르지 않고도 작동시키는 버튼 지원
- Apple Watch : 빠른 터치 및 동작 지원
- 뒷면 탭
- 받아쓰기 기능
- 자동완성 텍스트

### Cognitive (인지능력)
- 일련의 단계를 기억하는데 어려움을 겪거나 지나치게 복잡한 사용자 인터페이스를 이용하기 어려워하는 사람들을 돕는 기능
- Safari 읽기 도구 - 광고나 애니메이션 등의 방해 요소를 줄이고 콘텐츠에 집중할 수 있도록 지원
- 한번에 하나의 앱만 실행하거나 화면의 특정 부분에 대한 터치 입력을 제한하는 사용법 유도 기능

## Accessibility의 필요성
- 사소한 부분에도 집중할 수 있다.
   - 접근성을 개선하다보면 신경쓰지 못한 UI 요소들까지 신경쓰게 된다. 그렇기 때문에 더 완전하고 일관성 있는 앱을 만들게 된다.
 
- UITest가 쉬워지게 한다.
   - Accessbility Label 과 같은 몇가지 특성을 이용하면 Accessibility Inspector를 통한 UI Test가 쉬워진다.

- 모든 사람이 이용할 수 있다.
   - 장애인을 위한 개선이 아닌, 모든 사람을 위한 개선이다. 즉 접근성을 개선하는 것은 앱의 버그를 고치는 것과 비슷한 개념이다.

# 접근성 개선하기 

## VoiceOver
> 화면의 구성요소를 소리로 읽어주는 기능

### Accessibility Inspector
<img src="https://i.imgur.com/ysd8iZN.png" width="400">

- Xcode -> Open Developer Tool -> Accessibility Inspector

<img src="https://i.imgur.com/adcMLC4.png" width="400">

- Target 을 simulator로 설정해준다.
- 왼쪽 버튼 3개
   - 1. Inspection : VoiceOver에 대한 탭
   - 2. Audit : 시뮬레이터에서 표시하고 있는 UI의 접근성에 대해 검사
   - 3. Settings : 접근성에 대한 다양한 설정들을 즉각적으로 시뮬레이터에 적용시킬 수 있다.


#### Inspection
<img src="https://i.imgur.com/NhDhFW2.png" width="300">

1. Navigation : 
VoiceOver를 읽어주는 control
2. Basic : 
UI요소를 어떻게 읽어낼지에 대한 정보를 나타냄
3. Actions : 
시뮬레이터의 UI를 컨트롤, Perform 버튼을 눌러 원하는 동작을 실행
4. Element : 
VoiceOver가 인식하는 UI요소의 정보를 나타냄.
상속받은 클래스, 메모리 주솟값, Controller 등 정보 표시 
6. Hierarchy : 
View의 계층구조, 어떤 계층에 속한 UI 인지 파악할 수 있다.

#### Audit
- Run Audit 버튼을 눌러 시뮬레이터의 UI 검사 진행
- 문제가 있는 곳에 경고창으로 표시됨 => 물음표 버튼을 누르면 문제를 파악할 수 있고 해결방안을 제시해준다.
- 하지만, 검사결과가 반드시 정답은 아니며 꼭 Inspector가 제시한 기준대로 접근성을 개선할 필요는 없다. 참고용을 확인하기 좋다!

#### Setting
- 접근성에 대한 다양한 설정들을 즉각적으로 시뮬레이터에 적용시킬 수 있다.
- dynamic type을 적용한 label의 크기를 조절하거나, bold체로 바꾸는 등 예상 동작을 확인해볼 수 있다.


### Accessibility API (Application Programming Interface)
#### UIAccessibility
> 접근성 지원을 구현할 때 사용되는 API 중에 가장 중심이 되는 protocol
> view와 control에 대한 접근성 정보를 제공하는 informal protocol (informal protocol 이므로 직접 채택하도록 구현할 수는 없다.)

- 직접 채택하여 구현할 수는 없지만 UIKit control이나 view는 `UIAccessibility` protocol을 암묵적으로 채택하고 있다.
- custom control의 경우 `UIAccessibility` protocol을 직접 채택하여 구현할 수 없지만 `UIAccessibilityElement` 라는 클래스를 상속시켜주는 것으로 접근성 지원이 가능하다.
- 프로퍼티의 종류 
   - `isAccessibilityElement`: 접근성을 지원하는 요소인지를 결정하는 Bool 타입의 프로퍼티
   - `accessibilityLabel`: 접근성 요소가 무엇인지 설명하는 짧은 localizing된 문자열
   - `accessibilityValue`: 접근성 요소의 값을 설명하는 localizing된 문자열
   - `accessibilityTraits`: 접근성 요소의 특징에 대한 값 (ex: Button, Seleted)
   - `accessibilityHint`: 접근성 요소의 실행 결과를 설명하는 짧은 localizing된 문자열

#### 스토리보드에서 UIAccessibility 프로퍼티 설정하기

<img src="https://i.imgur.com/vjdXjEJ.png" width ="300">

- Identify Inspector - Accessibility -> Label, Identifier등 기입

#### 코드로 UIAccessibility 프로퍼티 설정하기

```swift=
extension DetailViewController {
    private func configureLogoImageAccessibility() {
        languageImageView.isAccessibilityElement = true // 1
        languageImageView.accessibilityLabel = "\(languageTitleLabel.text ?? ) 로고"
        languageImageView.accessibilityTraits = .image
        languageImageView.accessibilityIdentifier = "DetailViewController.languageImageView"
        languageImageView.accessibilityHint = "주황색 바탕, 오른쪽 아래로 날고있는 하얀 새" // 2
    }

```

- 위와 같이 코드로 구현한 후, viewDidLoade에서 호출한다.
- `accessibilityIdentifier` 
UI요소에 고유한 식별자를 지정한다. iOS앱의 경우 동일한 이름을 가진 여러 UI요소가 있을 수 있으며 이 경우 VoiceOver가 구분하지 못할 수도 있음! 따라서 고유한 식별자를 지정하여 정확한 정보를 전달할 수 있게 해준다.

## 참고
[WWDC19](https://developer.apple.com/videos/play/wwdc2019/257/?time=422)
[WWDC19](https://developer.apple.com/videos/play/wwdc2019/254/)
[Accessilbilty 공식문서](https://developer.apple.com/documentation/accessibility)
[야곰닷넷](https://yagom.net/ios-swift-courses/ios-courses/)
