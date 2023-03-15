# 스토리보드 없이 코드로 UI 구현

## view 객체 타입 구현
#### 객체마다 파일을 분리해서 만드는 경우

```swift
import UIKit

final class ButtonStackView: UIStackView {
    let addClientButton = AddClientButton()
    let resetButton = ResetButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUpButtonStackView() 
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.axis = .horizontal
        self.distribution = .fillEqually
    }
    
    private func setUpButtonStackView() {
        self.addArrangedSubview(addClientButton)
        self.addArrangedSubview(resetButton)
    }
}
```
- `configure()` 메서드를 통해 ButtonStackView의 상태를 설정해줌
- `setUpButtonStackView()` 메서드를 통해 ButtonStackView에 띄워주고 싶은 객체들을 인스턴스로 선언하여 `addArrangedSubview()`에 넣어줌
- ButtonStackView의 이니셜라이저에 두 메서드를 호출해주고 viewController에서 ButtonStackView 인스턴스를 생성하여 사용
- init()에 대한 설명은 [여기참고](https://github.com/yijiye/TIL-swift-/blob/main/UIKit/View/init().md)

#### 하나의 파일안에 여러객체를 만들 때
```swift
import UIKit

final class ButtonStackView: UIStackView {
    // let addClientButton = AddClientButton()
   
    private let addClientButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false  
        return button
    }()   
```

- ButtonStackView 타입 안에 구현해 줄 수도 있다.

## Autolayout 설정
```swift
  private func configureConstraint() {
        //screenView
        NSLayoutConstraint.activate([
            screenStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

        ])
    }
```
- NSLayoutConstraint.activate 안에 원하는 제약을 걸어줄 수 있다. 기준은 view.safeAreaLayoutGuide, view 등 원하는 기준을 잡아 설정할 수 있다.
- 제약을 걸어주는 메서드는 객체의 이니셜라이저에 호출하거나 viewController viewDidLoad()에서 호출하여 적용할 수 있는데 이는 필요에 따라 조정하면 될듯!
- autolayout priorty는 [여기참고](https://github.com/yijiye/TIL-swift-/blob/main/UIKit/View/Autolayout/Priority.md)


## Button action 구현
- 스토리보드에서는 @IBAction 을 통해 버튼이 눌렸을 때의 이벤트를 설정할 수 있었다.
- 코드로 구현할 때는 아래와 같이 할 수 있다.

```swift
 private func addClientButtonTapped() {
        buttonStackView.addClientButton.addTarget(self, action: #selector(addTenClients), for: .touchUpInside)
    }
    
    @objc func addTenClients() {
    }
```
- [addTarget(_:action:for:)](https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget)

<img src="https://i.imgur.com/RqEntXG.png" width="400">

<br/>

  - 대상 객체와 액션 메소드를 컨트롤과 연관시킨다.
  - target: action method를 호출시키는 객체이므로 self
  - action: 호출할 작업 방법을 식별하는 selector, selector에 들어갈 메서드를 `@objc func`로 구현해주어야 한다.
  - for contolEvents: UIControl.Event : action method가 호출될 때 발생하는 이벤트 설정.
  - Discussion
      - 이 메서드는 여러번 호출하여 target, action을 구성할 수 있음 (같은 값의 target, action을 호출해도 안전하다.)
      - controlEvent 매개 변수에 0을 지정해도 이전에 등록된 이벤트 전달이 멈춰지지는 않는다. 
      - 이벤트 전달을 멈추려면 `removeTarget(_:action:for:)` 메서드를 호출해야한다.
