# Protocol
- 기능을 요구로 하는 프로퍼티나 메서드의 청사진
- struct, class, enum에 의해 protocol이 **채택**된다.
- protocol이 담고있는 모든 기능을 구현하는 것을 protocol을 **준수**한다고 한다.
- protocol은 확장할 수 있다.
- 타입간의 의존관계를 줄여서 유연한 코드를 작성하게 해준다.

```swift
protocol SomeProtocol {
    // protocol definition goes here
}
```
- protocol 정의하는 방법

```swift
class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}
```
- protocol을 채택할 때는 가장 마지막에 넣어주면 된다.

## property requirements

1. 저장 프로퍼티인지, 연산 프로퍼티인지 관계없이 프로퍼티의 이름과 타입으로만 정의하면 된다.
2. 프로퍼티의 get, set 속성을 같이 명시해주어야 한다.
3. 만약 get, set을 같이 사용한다면 상수 지정 프로퍼티나 읽기 전용 프로퍼티로 사용할 수 없다.
4. 만약 get (읽기전용) 으로만 사용한다면 모든 유형으로 사용 가능하다.

```swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
```
- protocol 의 프로퍼티는 늘 **변수**로 정의한다.
- 읽기전용, 쓰기전용을 명시해야한다.

```swift
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}
```
- 타입 프로퍼티는 항상 ```static```을 붙여준다.

```swift
protocol FullyName {
    var fullName: String { get }
}

struct Person: FullyName {
    var fullName: String
}
```
- Person 구조체는 FullyName protocol을 채택하고 var fullName 을 정의하여 protocol을 준수하고 있다. (만약 protocol내의 프로퍼티를 정의하지 않으면 오류가 뜬다.)

### 1,4 번 예제
1. 상수(constant) 저장 프로퍼티

```swift
protocol FullyName {
    var fullName: String { get }
}

struct Person: FullyName {
    let fullName: String
}
var riji = Person(fullName: "rijilee")
riji.fullName = "리지" // 에러발생
```
- 프로토콜은 연산프로퍼티인지 저장프로퍼티인지 타입을 나타내는 것은 상관 없이 변수로 읽기전용인지 쓰기전용인지만 정의해주면 된다.
- struct Person에 let으로 선언했기 때문에 fullName을 바꾸려고 하면 오류가 뜬다.

2. 변수(variable) 저장 프로퍼티

```swift
protocol FullyName {
    var fullName: String { get }
}

struct Person: FullyName {
    var fullName: String
}
var riji = Person(fullName: "rijilee")
riji.fullName = "리지"
```
- 변수로 선언한다면 에러가 발생하지 않는다. fullName을 변경할 수 있다.

3. 연산프로퍼티

- 연산프로퍼티는 변수로 정의해야한다.
- 값을 저장하고 리턴할 변수가 따로 있어야 한다.
```swift
protocol FullyName {
    var fullName: String { get }
}

struct Person: FullyName {
    var name: String
    var fullName: String {
        return name
    }
}

var riji = Person(name: "rijilee")
riji.fullName = "리지" // 에러발생
```
- 연산프로퍼티의 값을 저장하고 리턴하는 것을 ```name```으로 정의했기 때문에 인스턴스를 생성할 때 읽기전용인 FullName이 아닌 name을 받는다.
- ```fullName```은 읽기 전용으로 값을 바꿀 수 없다. 읽기만 가능

```swift
protocol FullyName {
    var fullName: String { get }
}

struct Person: FullyName {
    var name: String
    var fullName: String {
        get {
            return name
        }
        set {
            name = newValue
        }
    }
}

var riji = Person(name: "rijilee")
riji.fullName = "리지"
```
- protocol은 get 만 정의해주었지만 set도 사용 가능하므로 protocol을 준수하고 있는 struct 에서 쓰기 전용을 정의해줄 수 있다.
- set 쓰기 전용도 정의해주었기 때문에 ```newValue```로 값을 변경할 수 있다.

### 3번 예제

```swift
protocol FullyName {
    var fullName: String { get set }
}

struct Person: FullyName { // protocol을 제대로 준수하고 있지 않음 에러 발생!!
    var name: String
    let fullName: String
}
```
- get, set 으로 정의한다면 상수로 사용할 수 없기 때문에 protocol을 제대로 준수하지 않은 에러가 발생한다.
- set 을 구현했다는 것은 다른 값으로 바꿀수 있다는 뜻인데, 상수로 정의해버리면 값을 바꿀 수 없기 때문이다.

```swift
protocol FullyName {
    var fullName: String { get set }
}

struct Person: FullyName {
    var name: String
    var fullName: String { // 에러발생
        return name
    }
}
```
- get 만 구현해준다면? 당연히 에러가 발생한다. 쓰기 전용이 구현되어 있지 않기 때문이다.


## method requirements
- 중괄호나, 메서드의 body 부분 없이 정의한다.

```swift
protocol SomeProtocol {
    static func someTypeMethod()
}
```
- 타입 메서드 앞에는 ```static```을 붙여준다.

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}
```
- protocol에는 Double 타입으로 반환 한다는 정보만 줄 뿐 구체적인 범위를 주지 않으며 이를 통해 표준적인 범위를 제공한다.

## Mutating Method Requirements
- protocol 에 정의한 인스턴스 메서드를 변경해야할 경우```mutating``` 키워드를 사용할 수 있다. 이는 struct, enum 타입에 한정적이며 class는 사용할 필요가 없다.

```swift
protocol Togglable {
    mutating func toggle()
}
```
- Togglable protocol에 mutating method toggle을 정의하여 값이 변할수도 있음을 알려준다.

```swift
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on
```
- enum 타입에서 Togglable protocol을 채택하는 경우 마찬가지로 mutating 키워드를 붙여 protocol 메서드를 준수한다.
- case 따라 toggle 메서드의 기능이 변할 수 있다.

## Initializer Requirements
- protocol 내에 이니셜라이즈를 정의할 수 있다. 마찬가지로 바디 없이 기본 틀만 구현하면 된다.
```swift
protocol SomeProtocol {
    init(someParameter: Int)
}
```
### Class Implementations of Protocol Initializer Requirements

- 클래스 타입이 이니셜라이즈를 정의하고 있는 protocol을 준수하는 경우 지정 이니셜라이즈, 편의 이니셜라이즈 모두 가능하지만 앞에 ```required```키워드를 붙여서 사용해야 한다.

```swift
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
}
```
- 근데 만약 더이상 상속을 하지 않는 class의 경우 앞에 ```final```키워드를 붙여 상속을 하지 않음을 알리고 ```required```키워드 없이 사용할 수 있다.

```swift
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}
```
- 만약 자식클래스가 부모클래스를 상속받고, 프로토콜도 채택하는 경우에 부모클래스의 이니셜라이즈와 프로토콜의 이니셜라이즈가 같다면 자식클래스는 ```required```, ```override```키워드를 둘다 붙인다.

### Failable Initializer Requirements (실패가능한 이니셜라이즈)
- init? 으로 정의할 수 있다.


## Protocols as Types
- protocol 은 실제로 기능을 구현하지 않는다. 그럼에도 코드에서 타입으로 사용될 수 있다.
   - 함수, 메서드, 이니셜라이즈의 return 타입이나 파라미터 타입으로 사용
   - 상수 / 변수 프로퍼티의 타입으로 사용
   - array, dictionary의 item의 타입으로 사용
>    protocol 도 타입으로 사용되기 때문에 swift에서는 Int, String과 같이 네이밍을 대문자로 시작한다.

```swift
protocol RandomNumberGenerator {

    func random() -> Double

}
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator //protocol을 타입으로
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int { 
        return Int(generator.random() * Double(sides)) + 1
    }
}
```
- ```Dice``` 라는 클래스는 프로토콜을 채택하지 않고 상수 ```generator```의 타입을 ```RandomNumberGenerator protocol```로 받아주고 있다.
- 이렇게 되면 프로토콜을 채택한게 아니므로 프로토콜 내의 프로퍼티나 메서드를 반드시 구현할 필요가 없다.
- ```func roll()``` 에서 ```generator.random()``` 으로 접근할 수 있다. 왜냐면 ```generator```라 프로토콜을 타입으로 받고 있기 때문에

## Delegation 
- struct, class 가 책임을 다른 타입의 인스턴스에 위임 (delegate) 할 수 있게 해주는 디자인 패턴
- 책임을 캡슐화하여 protocol 에 정의해서 delegate 할 수 있다.
- delegation 을 이용하면 특정 동작에 응답하거나 외부 소스에서 해당 소스의 기본 데이터 타입을 알 필요없이 데이터를 검색할 수 있다.
- 위임의 주요 가치는 하나의 중앙 객체에서 여러 객체의 동작을 쉽게 사용자 정의할 수 있다는 것
- 종류
   - windowShouldClose: 화면을 닫으면 신호가 가고 delegate가 bool타입으로 반환하여 화면을 컨트롤한다.
   - NSWindondelegate
   
## 참고
[protocl-공식문서](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID281)
[protocol-zedd](https://zeddios.tistory.com/255)
[protocol-zedd](https://zeddios.tistory.com/263)
