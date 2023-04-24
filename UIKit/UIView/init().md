# init(frame:), init(coder:)

- xcode 코드로 구현시 `override init(frame:)`, `required init(coder:)` 가 필요한데 그 이융에 대해 알아보았다.

## init(frame:)
> 지정된 프레임 직사각형으로 초기화된 뷰를 반환한다.

<img src="https://i.imgur.com/tEWTGbY.png" width="400">

<br/>

- 새로운 view 객체를 사용하기 전에 view 계층 구조에 삽입되어야 한다. 코드로 view를 구현하는 경우, UIView 클래스의 지정 이니셜라이저를 사용해야하고, frame을 가진 label, button, indicator, view 등 모든 view 객체는 해당 이니셜라이저 안에서 초기화 되어야 한다.
- 인터페이스 빌더를 사용하여 디자인하는 경우에는 view 객체가 nib file로 부터 load될 때 이니셜라이저 호출이 필요하지 않다.
   - xib: XML Interface Builder
   - nib: NeXT Interface Builder (빌드시 xib가 nib으로 변환한다.)

## init(coder:)
> 주어진 unarchiver(언아카이버)의 데이터에서 초기화된 객체를 반환한다.
- **required init**

<img src="https://i.imgur.com/OPmTOvy.png" width="400">

<br/>

- unarchiver: 스토리보드나 xib을 활용하면 별도의 코드 없이 앱의 속성을 수정할 수 있는데, 이것이 가능하도록 해주는 과정을 unarchiving 이라고 한다.
- 인터페이스 빌더는 코드로 구현하는 것이 아니기 때문에 **앱이 컴파일 하는 시점에서 컴파일러가 인식할 수 없고 이를 코드로 변환해주는 unarchiving 과정**이 필요하다.

### 구현해야 하는 이유?
- view 객체는 NSCoding을 채택하고 있고 init(coder:) 이니셜라이저는 required init 이기 때문에 필수 구현을 해야한다.



## 참고
[공식문서 init(frame:)](https://developer.apple.com/documentation/uikit/uiview/1622488-init)
[공식문서 init(coder:)](https://developer.apple.com/documentation/foundation/nscoding/1416145-init)
https://velog.io/@inwoodev/iOS-initframe-initcoder


