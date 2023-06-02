# Model View Controller (MVC)
>Cocoa Touch : iOS 앱을 개발하는데 쓰이는 애플의 프레임 워크와 기술의 집합체
>역할에 따라 객체를 분류하는 장점이 있다.
>재사용가능, 변화에 용이, 확장가능성이 많다.
>디자인패턴!, 애플에서 사용하는 MVC는 굉장히 구체적이다.

<img src="https://i.imgur.com/nV1oP0Z.png" width="600">


- model 객체 : 애플리케이션과 관련된 데이터를 캡슐화한다.
  - 데이터를 보유하고 조작하는 역할
  - 애플리케이션의 모든 데이터가 모델객체에 속해야 한다.
  - 예시, 게임의 캐릭터나 주소록의 연락처
  - 다른 모델 객체와 일대일 및 대다 관계 형성
  - 재사용 가능
  - interface와 presentation에는 관여하지 않는다.
  - <span style='background-color: #fff5b1'>데이터를 만들거나 수정하는 view 객체의 사용자 작업은 controller 에게 전달되고 model 이 update 된다. model이 다시 업데이트 되면 controller를 통해 view를 update 하도록 한다.</span>

- view 객체 : 사용자가 볼 수 있는 애플리케이션의 객체, 사용자에게 정보를 제공한다.
  - 애플리케이션의 모델 객체의 데이터를 표시하고 해당 데이터를 사용자가 편집할 수 있도록 함
  - 사용자의 관점에 따라 달라질 수 있다. (UIView가 View가 아닐수 있듯이!)
  - MVC 애플리케이션의 model 객체와 분리됨
  - 그러므로 데이터를 저장할 의무가 없음
  - model을 올바르게 표시하고 있는지 확인, model의 변화를 감지해야함
  - 재사용, 재구성을 하기 때문에 애플리케이션 간의 일관성을 제공함
  - <span style='background-color: #fff5b1'>controller를 통해 model 데이터의 변경사항을 전달 받고 user action을 다시 controller로 전달하여 Model에 전달하도록 한다.</span>

- controller 객체 : 하나 이상의 애플리케이션의 뷰 객체와 하나 이상의 모델 객체 사이의 중개자 역할을 함
  - view 객체와 model 객체의 변화에 대해 감지한다.
  - 애플리케이션의 설정 및 조정 작업을 수행하고 다른 객체의 수명 주기를 관리할 수 있음
  - view 객체에서 만들어진 사용자 작업을 해석하고 새롭게 변경된 데이터를 model과 통신
  - 재사용 불가능 
  - view controller, model controller 처럼 역할 결합이 가능
  - <span style='background-color: #fff5b1'>model 객체가 변경되면 컨트롤러는 새 모델 데이터를 view에 전달</span>

# Types of Cocoa Controller Objects
- mediating controller
   - NSController class의 특성을 가짐
   - <span style='background-color: #fff5b1'>Cocoa bindings technology 에서 사용됨</span>
   - interface builder library 로 부터 만들어진 기성품 객체
   - NSObjectController, NSArrayController, NSUserDefaultController, NSTreeController
- coordinating controller
   - NSWindowController, NSDocumentController (AppKit에서만 사용 가능)
   - 위의 2개의 controller는 문서 기반 애플리케이션에 사용
   - nib 파일에 보관된 객체를 컨트롤
  
# MVC as a Compound Design Pattern
> 사용자가 view 객체를 조작하면 controller가 그 변화를 감지하고 전략을 세운다. 전략을 세우면 메세지를 통해 model에게 전달하고 modeld은 관찰자 입장으로 view에게 변화를 나타내도록 알려준다
- composite 
  - 애플리케이션의 view 객체는 중첩된 view로 구성되어 있다. (view hierarchy) 
  - 디스플레이 구성요소는 window 부터 compound view(table view, individual view, button)의 다양한 범위를 갖고있다.
  - 사용자 입력과 디스플레이는 composite 구조의 어느 level에서 있을 수 있다.
- strategy
  - 하나 이상의 view 객체의 전략을 구현
  - view 객체는 시각적 측면이고 controller는 interface 모든 행위의 대한 결정을 맡아서 한다.
- observer
  - model은 자신의 변화를 view 객체에 알리고 view 의 변화를 감시한다.

<img src="https://i.imgur.com/N4faMyo.png" width="600">

# Cocoa version
> model과 view 를 분리시키는 것이 각각의 재사용성을 증가시키므로 아래와 같은 구조가 더좋다.

<img src="https://i.imgur.com/aWRhM1z.png" width="600">

- controller가 중재와 전략을 세우는 일 두가지를 한다.
- 그로인해 view와 model을 분리시켰다.

# Design Guidelines for MVC Applications

- cocoa binding 기술을 사용하여 NSController 객체의 하위 클래스를 사용하기 (만약 심플한 애플리케이션이라면 사용자 NSObject 서브클래스를 mediating controller로 사용)
- 역할을 구분하기
- model, view를 구분하여 재사용하기
- cocoa에서 프로그래밍 문제를 해결해줄 아키텍처를 제공한다면 그 아키텍처를 사용할 것

# Model-View-Controller in Cocoa (OS X)

- Document architecture : 전체앱(NSDocumentController), 문서창(NSWindowController), 컨트롤러와 모델의 역할이 합쳐진 객체(NSDocument)
- Bindings : NSController는 view와 model 객체를 적절히 바인딩해주는 기성품 컨트롤러를 제공한다.
- Application scriptability : 애플리케이션 상태 및 요청 애플리케이션 동작에 액세스하는 스크립팅 명령은 일반적으로 모델 객체 또는 컨트롤러 객체로 전송.
- Core data : 핵심데이터는 model에서 관리하고 저장한다.
- Undo : 실행취소, model에서 주로 작업한다.


## 참고
- [AppleDeveloper - MVC](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)
