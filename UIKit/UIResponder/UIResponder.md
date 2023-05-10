# Using responders and the responder chain to handle envets
> 앱은 responder 객체를 사용하여 이벤트를 수신하고 처리한다.
- responder 객체는 `UIResponder `클래스의 객체로 하위 클래스에는 `UIView`, `UIViewController` 및 `UIApplication`이 포함된다.
- responder는 raw event data를 받고 이벤트를 처리하거나 다른 응답자 객체로 전달해야 한다.
- 앱이 이벤트를 받으면, UIKit은 자동으로 해당 이벤트를 첫 번째 responder로 전달한다.
- 처리되지 않은 이벤트는 앱의 responder 객체의 dynamic configuration인 active responder chain에서 responder에서 responder로 전달된다.
- 다음 이미지는 라벨, 텍스트 필드, 버튼 및 두 개의 배경 뷰가 포함된 인터페이스를 가진 앱의 responder를 보여주며 responder chain을 따라 이벤트가 어떻게 이동되는지 보여준다.

<img src="https://i.imgur.com/qSvfnhu.png" width="400">

- 텍스트 필드가 이벤트를 처리하지 않는다면 UIKit은 텍스트 필드의 부모 UIView 객체에 이벤트를 보내고, 화면의 루트뷰에도 보낸다.
- 루트 뷰에서 responder chain은 해당 이벤트를 화면에 전달하기 전에 소유하는 view controller로 전환한다.
- 화면이 이벤트를 처리할 수 없으면, UIKit은 이벤트를 UIApplication 객체로 전달하고, 이 객체가 UIResponder의 인스턴스이고 responder chain의 일부가 아닌경우, AppDelegate에도 이벤트를 전달할 수 있다.

## 이벤트 첫 번째 responder 결정
- UIKit은 해당 유형에 따라 첫 번째 responder를 결정한다.

<img src="https://i.imgur.com/iWOiPWq.png" width="400">
- accelerometers, gyroscopes, and magnetometer와 관련있는motion event는 responder chain을 따르지 않는다.


- control은 action 메시지를 사용하여 관련된 타겟 객체와 직접 소통한다.
- user가 control과 상호작용할 때, control이 타겟 객체에 action 메시지를 보낸다.
- action 메시지는 이벤트가 아니지만 responder chain을 이용할 수 있다.
- control의 타겟 객체가 nil일때, UIKit은 대상 객체에서 시작하여 적절한 작업 방법을 구현하는 객체를 찾을 때까지 응답자 체인을 가로지른다 예를 들어, UIKit 편집 메뉴는 이 동작을 사용하여 `cut(_:)`, `copy(_:)` 또는 `paste(_:)`와 같은 이름으로 메서드를 구현하는 responder 객체를 검색한다.
- 제스처 인식기는 보기 전에 터치 및 프레스 이벤트를 받는다. 뷰의 제스처 인식기가 일련의 터치를 인식하지 못하면, UIKit은 터치를 뷰로 보낸다. 뷰가 터치를 처리하지 않으면, UIKit은 이를 responder chain에 전달한다. 

## 터치 이벤트가 포함된 responder 확인
> 터치 이벤트가 발생한 위치를 판별하기 위해 UIKit은 view 기반의 hit-testing을 사용

- UIKit은 터치 위치를 view 계층 구조의 view 객체와 비교한다.
- hitTest(_:with:)메서드는 뷰 계층구조를 보면서 지정된 터치가 포함된 가장 깊은 서브뷰를 찾는다. 그리고 그 해당 서브뷰가 터치 이벤트에 대한 첫 번째 responder가 된다.
   - Note
   만약 터치 위치가 뷰의 경계를 벗어나면, hitTest메서드는 해당 뷰와 그 하위 뷰를 모두 무시한다.
   따라서 뷰의 clipsToBounds 속성이 true인 경우, 해당 뷰 경계 외부에 있는 서브뷰는 터치를 포함하더라도 반환되지 않음.
   
 - 터치가 발생하면, UIKit은 UITouch 객체를 생성하고 뷰와 연결한다.
 - 터치 위치나 다른 매개변수가 변경될 때 마다 UIKit은 새로운 정보로 UITouch 객체를 업데이트한다.
 - 유일하게 변경되지 않는 속성은 view 이다.
 - 터치가 끝나면 UIKit은 UITouch 객체를 해제한다.

## responder chain 바꾸기
> responder 객체의 next 속성을 재정의 하여 변경

- 다음 responder는 반환하는 객체가 된다.
- UIKit 클래스 중 다음과 같은 객체는 이미 속성을 재정의하고 특정 객체를 반환한다.
   - UIView : 뷰가 뷰 컨트롤러의 루트뷰라면 다음 responder는 뷰컨이된다. 그렇지 않으면, 뷰의 상위 뷰가 된다.
   - UiViewController : 만약 뷰컨의 뷰가 윈도우의 루트뷰라면 다음 responder는 window 객체이다. 만약 뷰컨이 다른 뷰컨에 의해 표시되었다면 다음 responder는 preseting view controller 이다.
   - UIWindow : 윈도우의 다음 responder는 UIApplication 객체이다.
   - UIApplication : 다음 responder는 app delegate이다. 그러나 앱 델리게이트가 UIResponder의 인스턴스이고 뷰, 뷰컨 또는 앱 자체가 아닌 경우에만 해당.


# Touch, presses, and gestures
> 앱의 이벤트 처리 로직을 제스처 인식기에 캡슐화하여 앱 전체에서 해당 코드를 재사용할 수 있습니다.

- UIKit의 표준 뷰와 컨트롤을 사용하여 앱을 구축하는 경우, UIKit은 터치이벤트를 자동으로 처리한다.
- 그러나 커스텀 뷰를 사용하여 콘텐츠를 표시하는 경우, 해당뷰에 발생하는 모든 터치 이벤트를 직접 처리해야 한다.
    - 터치를 추적하기 위해 제스처 인식기 사용
    - 터치를 직접 UIView 하위 클래스에서 추적
    
## 참고
- [공식문서](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events)
- [공식문서](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures)

------

## 1 Swipe Gesture Recognizer
```swift

    @IBOutlet var rightSwipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!

    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if (gestureRecognizer.direction == .left) {
            NSLog("Swipe Left")
            directionLabel.text = "왼쪽"
        }
        if (gestureRecognizer.direction == .right) {
            NSLog("Swipe Right")
            directionLabel.text = "오른쪽"
        }
    }

```

## 2 touchesMoved
```swift

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let theTouch = touches.first {
                let touchLocation = theTouch.location(in: self.view)
                let x: Int = Int(touchLocation.x)
                let y: Int = Int(touchLocation.y)

                locationLabel.text = ("x : \(x)")
                YLabel.text = ("y : \(y)")
            }
     }

```

## 3 Questions

### Q1 : Responder Chain이란?
- responder object들이 동적으로 구성된 이벤트 전달 체인
- view는 터치와 같은 이벤트를 받으면 responder chain을 통해 first responder를 찾는다

### Q2 : Responder Chain과 Gesture Recognizer는 이벤트 제어에서 상호간 상관관계일까요? 별개관계일까요?

- [공식문서](https://developer.apple.com/documentation/uikit/uigesturerecognizer)에 따르면 `A gesture recognizer doesn’t participate in the view’s responder chain.` 이라고 명시되어 있다. 그러나 완전히 별개의 관계라고 볼 수는 없다.
- 실제로 테스트를 해보면 UIView로 구현하는 것과 gesture recognizer로 구현한 것이 같은 화면에 있을 때 gesture recognizer가 진행되면 UIResponder메서드가 취소되는 경우도 생긴다. 이는 gesture recognizer가 우선이기 때문이다.

### Q3 : UIResponder 클래스의 역할? 

- 자체로 아무일을 하지는 않지만 responser로서 응답해야하는 기능을 모아둔 클래스 => 추상 인터페이스
- 다른 애들이 UIResponder를 상속받아서 reponder의 역할을 할 수 있도록 UIResponder가 기반을 다져놓음.

### 참고자료
- [trycatching.tistory](https://trycatching.tistory.com/12)
- [부스트코스](https://www.boostcourse.org/mo326/lecture/17992?isDesc=false)
![](https://i.imgur.com/dOjdTy0.png)
