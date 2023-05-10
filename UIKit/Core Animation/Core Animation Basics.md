# Core Animation Basics

Core Animation은 App의 View를 대체하는 것이 아니라 애니메이션 지원을 제공하기 위해 View와 통합되는 기술이다.
View의 content를 비트맵으로 캐싱하여 애니메이션을 나타낸다.
Core Animation을 사용하여 앱의 View나 시각적 객체의 변경 사항을 애니메이션화 한다. 이러한 변경을 할 때, Core Animation은 현재 값과 지정한 새 값 사이에서 애니메이션 된다.

## Layer 객체

Layer 객체는 3D공간에서 구성된 2D 표면으로 Core Animation으로 하는 모든 일의 중심이 된다. View와 달리 Layer는 자신의 모습을 정의하지 않는다. Layer는 단지 비트맵을 둘러싼 상태 정보를 관리할 뿐, 즉, 단순 그림일 뿐이지만 View는 유저와 상호작용을 한다.

### Layer 기반 드로잉 모델 

Layer는 실제 그림을 그리는 것이 아니라 앱이 제공하는 콘텐츠를 캡처하고 백킹 스토어라 불리는 비트맵에 캐시를 한다.
이후 Layer 속성을 변경할 때, Layer 객체와 관련된 상태 정보를 변경하기만 하면 된다. Core Animation은 Layer의 비트맵과 상태 정보를 그래픽 하드웨어 전달하며 새로운 정보를 사용하여 비트맵을 렌더링 하는 작업을 수행한다. 하드웨어에서 비트맵을 조작하면 소프트웨어에서 할 수 있는 것보다 훨씬 빠른 애니메이션을 얻을 수 있다!

<img src="https://hackmd.io/_uploads/HkVRI2_En.png" width="400">

정적 비트맵을 조작하기 때문에, Layer 기반 드로잉은 View 기반 드로잉 기술과 크게 다르다. View 기반 드로잉을 사용하면 View 자체를 변경할 때, View의 `drawRect:`메서드가 호출되어 새로운 매개 변수를 사용하여 콘텐츠를 다시 그릴 수 있다. 하지만 이런 식으로 그리는 것은 main 스레드에서 CPU를 사용하기 때문에 비싸다. Core Animation은 동일하거나 유사한 효과를 얻기 위해 하드웨어에서 캐시된 비트맵을 조작하여 가능한 한 이 비용을 피할 수 있다.


### Layer 기반 애니메이션

Layer 객체의 데이터와 상태 정보는 화면상의 해당 Layer 콘텐츠의 시각적 표현과 분리된다. 이 디커플링은 Core Animation에 스스로 개입하고 이전 상태 값에서 새로운 상태 값으로 변화를 애니메이션화 하는 방법을 제공한다.
애니메이션 과정에서 Core Animation은 하드웨어에서 개발자를 위해 모든 프레임별 드로잉을 수행한다. 애니메이션의 시작점과 끝점을 지정하고 Core Animation이 나머지를 하도록 하기만 하면 된다!

<img src="https://hackmd.io/_uploads/Sy_MO3dV3.png" width="400">

### layer geometries

<img src="https://hackmd.io/_uploads/r1cxo2OEn.png" width="400">

iOS는 왼쪽 상단이 (0,0)이고 OS X는 왼쪽 하단이 (0,0) 이다.


- AnchorPoint는 Layer에 rotation transform을 주게되면, anchorPoint를 기준으로 rotation이 된다.

<img src="https://hackmd.io/_uploads/rkzYj3OEn.png" width="400">

### Layer Tree
#### model Layer tree

모델 레이어 트리(또는 단순히 "레이어 트리")의 객체는 앱이 가장 많이 상호 작용하는 객체이다. 이 트리의 개체는 모든 애니메이션의 대상 값을 저장하는 모델 개체이다. 레이어의 속성을 변경할 때마다, 이 객체들 중 하나를 사용해야 한다.
**모든 애니메이션의 대상값을 저장하는 모델 객체**


#### presentation tree

프레젠테이션 트리의 객체는 실행 중인 애니메이션의 in-flight value를 포함한다. Layer 트리 객체는 애니메이션의 대상 값을 포함하는 반면, **프레젠테이션 트리의 객체는 화면에 나타나는 현재 값을 반영한다.** 이 트리에 있는 물체를 절대 수정해서는 안된다. 대신, 이 객체를 사용하여 현재 애니메이션 값을 읽고, 그 값에서 시작하는 새로운 애니메이션을 만들 수 있다.

### 직접 구현해보기
[참고사이트](https://www.objc.io/issues/12-animations/animations-explained/) 의 예시를 활용하여 직적 구현해보기

- plus 버튼 화면에 그리기
- plus 버튼을 클릭하면 45도 회전
- 다시 클릭하면 제자리로 돌아오기

#### 애니메이션이 끝나면 제자리로 돌아오는데 이를 방지하는 2가지가 있다.

1. presentation Layer의 마지막 값을 고정시키기

```swift
rotation.fillMode = .forwards
rotation.isRemovedOnCompletion = false
```
      
2. model Layer에 position 값을 주는 것

model Layer에 position값을 주면 애니메이션이 끝나고 원래자리로 돌아오지 않는다.


**소스 코드**
```swift
import UIKit
//@IBDesignable
final class PlusButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = bounds.width
        let height = bounds.height
        let circleFrame = bounds.insetBy(dx: width * 0.05, dy:  height * 0.05)
        
        context.beginPath()
        context.setLineWidth(20)
        context.addEllipse(in: circleFrame)
        context.setStrokeColor(UIColor.systemGreen.cgColor)
        
        context.move(to: CGPoint(x: width * 0.2, y: height * 0.5))
        context.addLine(to: CGPoint(x: width * 0.8, y: height * 0.5))
        context.move(to: CGPoint(x: width * 0.5, y: height * 0.2))
        context.addLine(to: CGPoint(x: width * 0.5, y: height * 0.8))
        context.setLineCap(.round)
        
        context.drawPath(using: .stroke)
        context.closePath()
    }
}
```
```swift
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var plusButton: PlusButton!
    
    private let rocketLayer: CALayer = {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.backgroundColor = UIColor.yellow.cgColor
        return layer
    }()
    
    var isRotate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton.layer.addSublayer(rocketLayer)
    
    }

    @IBAction func plusButtonTapped(_ sender: PlusButton) {
        isRotate == false ? rotateButton() : undoButton()
    }
    // keyPath: 어떤 애니메이션을 줄지 정해주는 것!
    private func rotateButton() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi / 4.5
        rotation.duration = 0.5
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        plusButton.layer.add(rotation, forKey: "rotation")
        isRotate = true
    }
    
    private func undoButton() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = Double.pi / 4.5
        rotation.toValue = 0
        rotation.duration = 0.5
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        plusButton.layer.add(rotation, forKey: "undo")
        isRotate = false
    }
    
```
- keyPath : 어떤 속성을 애니메이션 할지 적어주는 것 
주석 처리한 곳을 보면 `CABasicAnimation(keyPath: "transform.rotation")`로 되어있는데, transform.rotation.z가 생략되어 있다. z축을 기준으로 회전하는 keyPath 이고 .x, .y도 존재한다.

## 참고
- [Core Animation Basics](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW3)
- [Animations Explained](https://www.objc.io/issues/12-animations/animations-explained/)

