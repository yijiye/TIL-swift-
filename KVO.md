## KVO (일대일 관계)
> 다른 객체의 프로퍼티가 변했을 때, 바로 객체에게 알려주는 매커니즘

- MVC 디자인 패턴으로 디자인된 애플리케이션의 객체간 소통방식
- 예를들어, View 와 controller layer에 있는 객체와 model 객체의 상태를 동기화하는 것
- controller 객체 => model 객체, view 객체 => controller 객체, model 객체를 관찰
- KVO는 하나의 객체가 다른 객체의 프로퍼티를 관찰할 수 있게 해준다.



```swift
// 관찰 당하는 객체
class Player: NSObject {
    @objc dynamic var power: Int = 100
}
```
- 관찰 당하는 객체는 ```@objc dayamic var``` 로 정의할 수 있다.
- object C의 개념에서 가져온 내용이므로 앞에 ```@objc``` 를 붙여준다.
```swift
// 관찰 하는 객체
class Director: NSObject {
    @objc var player: Player // 관찰하는 것
    var observation: NSKeyValueObservation? // 관찰할때 필요함 (아래 코드로 구현!)
    init(player: Player) {
        self.player = player
        
        super.init()
        
        observation = observe(\.player.power,
                               options: [.old, .new],
                               changeHandler: { direcotor, change in print("파워가 변했습니다. \(change.oldValue) -> \(change.newValue)")})
    } // changeHandler에서 director, change는 개발자가 직접 정하는 이름으로 바꿀 수 있다.
    // oldValue, newValue로 변한 값을 확인할 수 있다.
}

let sonny: Player = Player() // 쏘니의 값이 변하는건 없지만 콘테가 관찰자로써 쏘니의 파워의 변화를 관찰한다.
let conte: Director = Director(player: sonny)
sonny.power = 100
sonny.power = 150

```
출력 예시
![](https://i.imgur.com/0Y8XzCS.png)


- 관찰당하는 player 안에서 변하는 값은 없지만 관찰하는 director 를 이용하여 player의 변화를 확인할 수 있다.
- player - director 간 일대일 관계 형성을 이룬다.


