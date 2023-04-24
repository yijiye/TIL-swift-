# UIView animations 구현

## iOS 내장된 애니메이션 도구를 사용하지 않는 경우 view를 애니메이션화 하는 단계 

- 매 프레임마다 호출될 메서드를 앱 내에 예약한다.
- 애니메이션의 기간을 기반으로 실행할 프레임 수를 결정하고, 각 프레임 마다 다음을 수행한다.
   - 애니메이션의 시작점과 목적지, 애니메이션의 실행 시간, 현재까지 실행된 시간 등을 고려하여 view의 새로운 위치를 계산
   - view의 위치를 직접 설정하거나, 위치를 결정하는 autolayout 제약 조건을 업데이트한다.
   - 애니메이션이 완료되거나 중단되면, view의 최종 상태가 올바른지 확인한다.

## iOS 내장된 애니메이션 도구를 사용하는 경우 (⭐️)
- UIView 애니메이션 메서드 중 하나를 호출하고, 애니메이션이 얼마동안 실행될지 등 몇가지 매개변수를 설정한다.
- 애니메이션 블록을 설정하고 UIKit에 애니메이션으로 움직이길 원하는 속성의 최종 값들을 알려준다.
- `animate(withDuration:delay:options:animations:completion)` 또는 `animateKeyframes(withDuration:delay:options:animations:completion:)`를 사용하면 된다!

## View의 상태를 바꿔주는 UIView 프로퍼티 알아보기
- frame : 슈퍼뷰의 좌표계에서 뷰의 위치와 크기를 설명하는 프레임 직사각형.
- bounds : 자체 좌표계에서 뷰의 위치와 크기를 설명하는 경계 직사각형.
    - frame과 bounds의 차이는 기준이 무엇이냐에 따라 다르다!
    - frame은 부모뷰를 기준으로 하고, bounds는 자기자신을 기준으로 한다.
- center : view frame의 center
- transform : bounds의 중심을 기준으로 변화되는 view의 transform을 의미
- alpha : 투명도 
- backgroundColor : 배경색

## UIView 프로퍼티에 따른 애니메이션 종류

### Position & Size
- 위치와 크기를 변형
- frame, bounds, center

**예시**
```swift
@IBAction func touchUpAnimationButton() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.autoreverse, .repeat]) { [self] in
            left.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
            right.trailingAnchor.constraint(equalTo: safe.trailingAnchor).isActive = true
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5) { [self] in
                line.frame.size.height = 100
                spider.frame = spider.frame.offsetBy(dx: 0, dy: 100)
            }
```
- UI요소들의 autolayout이 잡혀있는 경우, autolayout을 바꿔주고 view.layoutIfNeeded() 를 호출하면서 애니메이션을 줄 수 있다.
- frame의 size를 직접 지정하여 애니메이션을 줄 수 있다.

### transform 
- UIView의 animation을 줄 때, 유용하게 사용되는 프로퍼티이다!
- 움직임을 변형
- rotation, scale, translation을 조정할 수 있다.

**예시**
```swift
UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat]) {
            self.spider2?.transform = CGAffineTransform(rotationAngle: 1/3.0)
        } completion: { isFinished in
            UIView.animate(withDuration: 0.2) {
                self.spider2?.transform = CGAffineTransform(rotationAngle: -2/3.0)
            } completion: { isFinished in
                self.spider2?.transform = CGAffineTransform(rotationAngle: 0.0)
            }
        }
```

```swift
let scale = CGAffineTransform(scaleX: 2, y: 2)
            let rotate = CGAffineTransform(rotationAngle: .pi)
            let move = CGAffineTransform(translationX: 200, y: 200)
            let combine = scale.concatenating(rotate).concatenating(move)
            myView.transform = combine
```

- scale 값을 주면 크기가 확대되거나 작아질 수 있다.
- rotationAngle 값을 주면 회전되는 정도를 줄 수 있고, .pi는 180도 회전을 뜻함
- translation 값을 주면 위치의 변화를 줄 수 있다.
- 여러가지 값을 combine하여 여러개의 값을 한번에 줄 수 있다.


## 참고
- [UIView 공식문서](https://developer.apple.com/documentation/uikit/uiview)
- [Transform katarnios 티스토리](https://katarnios.tistory.com/44)
