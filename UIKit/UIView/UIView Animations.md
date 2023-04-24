# UIView Aniamtions 

## animate(withDuration:delay:options:animations:completion)
> Type Method
> 특정 기간, 지연, 옵션 및 completion 핸들러를 사용하여 하나 이상의 뷰에 대한 변경을 애니메이션화한다.

```swift
class func animate(
    withDuration duration: TimeInterval,
    delay: TimeInterval,
    options: UIView.AnimationOptions = [],
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
)
```
- duration : 애니메이션의 최종 duration으로 초 단위로 측정. 마이너스 값이나 0을 지정하면, 애니메이션을 만들지 않고 변경된다.
- delay : 애니메이션을 시작하기 전에 기다리는 시간(초 단위로 측정됨). 애니메이션을 즉시 시작하려면 0을 지정하면 된다.
- options : 애니메이션을 어떻게 표현하고 싶은지 나타내는 옵션
- animations : view에 커밋할 변경사항을 포함하는 블록 객체. 이것은 뷰 계층 구조에서 뷰의 애니메이션 속성을 프로그래밍 방식으로 변경하는 곳이다. 이 블록은 매개 변수를 사용하지 않으며 반환 값이 없다. 이 매개변수는 nil이 되면 안된다.
- completion : 애니메이션이 끝날 때 실행되는 블록 객체. 이 블랙은 리턴값이 없고 completion handler가 호출되기 전에 애니메이션이 실제로 끝났는지 아닌지 bool 값으로 나타낸다. 만약 애니메이션의 durationdl 0 이라면 이 블록은 다음 run loop cycle의 시작점에서 수행된다. 이 매개변수는 nil이 될 수 있다.

### Discussion
이 메서드는 view에서 수행되는 애니메이션의 set를 초기화한다. 애니메이션 매개변수에서 블록 객체들은 하나 이상의 view의 프로퍼티가 애니메이션화 되는 코드를 포함 하고 있다.
애니메이션 되는 동안 사용자 상호작용은 일시적으로 사용될 수 없다. 만약 view와 사용자가 상호작용하길 원한다면 options 매개변수에 `allowUserInteraction`을 넣으면 된다.

## animateKeyframes(withDuration:delay:options:animations:completion:)
> Type Method
> 현재 view의 keyframe기반의 애니메이션을 설정하는데 사용할 수 있는 애니메이션 블랙 객체를 만든다.

- keyframe이란? 특정한 프레임에서 시작점과 끝점을 지정하여 여러가지 효과를 적용하기 위한 포인트!

```swift
class func animateKeyframes(
    withDuration duration: TimeInterval,
    delay: TimeInterval,
    options: UIView.KeyframeAnimationOptions = [],
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
)
```

- duration : 전반적인 애니메이션의 duration으로 초 단위로 측정된다. 만약 마이너스 값이나 0의 값을 지정하면 애니메이션 없이 즉시 변경된다.
- delay : 애니메이션이 시작하기 전에 기다리는 시간 (초 단위로 측정)
- options : 애니메이션을 어떻게 수행되도록 원하는지 나타내는 옵션
- animations : view에 커밋할 변경사항을 포함하는 블록 객체.
- completion : 애니메이션이 끝나는 지점에서 실행되는 블록 객체. 이 블록은 리턴값이 없고 completion handler가 호출되기 전에 애니메이션이 끝났는지 안끝났는지 bool 값으로 나타낸다. 만약 애니메이션 기간이 0이라면, 이 블록은 다음 run loop cycle의 시작점에서 실행된다. 이 파라미터에 nil값을 줄 수 있다.

### addKeyframe 
animation 블록에서 한번 이상의`addKeyframe(withRelativeStartTime:relativeDuration:animations:)` 메서드를 호출한다. 만약 전체기간이상 변화에 대한 애니메이션을 주고 싶다면 view 값을 직접적으로 변화할 수 있다. 이 블록은 매개변수와 리턴값이 없다. 이 매개변수에 nil을 사용할 수 없다.
 
- relativeStartTime / relativeDuration / animation 3개의 매개변수가 존재. 
(시작 시간/ 지속시간/ 애니메이션 구현 부분)
- relativeStartTime, relativeDuration 값은 withDuration에 영향을 받는 상대적인 값이다.
- withDuration * relativeTime = 실제 애니메이션에 해당하는 시간 값 
- withRelativeStartTime : 0에서 1 사이 0은 animation이 시작되는 부분, 1은 끝나는 부분

```swift
 UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.autoreverse, .repeat]) { [self] in
       
        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
            
        UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5) { [self] in
            line.alpha = 1
            spider.alpha = 1
            line.frame.size.height = 100
            spider.frame = spider.frame.offsetBy(dx: 0, dy: 100)
        }
    }
```

withDuration이 2초이므로 `withRelativeStartTime: 0.1` 은 0.2초를 의미하고 `relativeDuration: 0.3`은 0.6초동안 지속됨을 뜻한다.

### Discussion

completion handler를 사용하여 동기코드로 부터 이 메서드를 호출할 수 있다. 또는 아래와 같이 비동기 메서드로 호출할 수 있다.

```swift
class func animateKeyframes(withDuration duration: TimeInterval, delay: TimeInterval, options: UIView.KeyframeAnimationOptions = [], animations: @escaping () -> Void) async -> Bool
```

이 메서드는 keyframe 기반 애니메이션을 설정할 수 있는 애니메이션 블록을 생성한다. keyframe 자체는 이 메서드를 사용하여 만든 초기 애니메이션 블록이 아니며, 애니메이션 블록 내부에서 `addKeyframe(withRelativeStartTime:relativeDuration:animations:)`메서드를 한번 이상 호출하여 keyframe 시간과 애니메이션 데이터를 추가해야 한다.
keyframe을 추가하면 지정한 시간대에 view를 현재 값에서 첫 번째 keyframe 값으로, 그 다음 keyframe 값으로 이동하면서 애니메이션을 실행한다.
만약 애니메이션 블록 내에서 어떤 keyframe도 추가하지 않으면, 애니메이션은 일반적인 애니메이션 블록 처럼 시작부터 끝까지 진행된다. 즉, 시스템은 지정한 기간 동안 현재 view 값에서 새로운 값으로 애니메이션을 실행한다.

## 참고
- [animate(withDuration:delay:options:animations:completion:) 공식문서](https://developer.apple.com/documentation/uikit/uiview/1622451-animate)
- [animateKeyframes(withDuration:delay:options:animations:completion:) 공식문서](https://developer.apple.com/documentation/uikit/uiview/1622552-animatekeyframes)
- [티스토리](https://i-colours-u.tistory.com/4)
