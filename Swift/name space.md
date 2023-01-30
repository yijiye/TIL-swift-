# Name space
> 연관된 값들을 한 공간에 이름을 지어 모아둔 공간

- 연관된 값들끼리 모아두어 유지보수, 재사용에 용이하다.
- 네임스페이스를 통해서만 문자열에 접근할 수 있게 캡슐화하는 방법!
- enum에서 네임스페이스를 이용하는 방법에 대해 알아보았다.

### rawValue(원시값) 으로 접근하는 방법

```swift
enum Greeting: String {
    case sayHello = "안녕"
    case sayGoodBye = "잘가"
}
print(Greeting.sayHello) // sayHello
print(Greeting.sayHello.rawValue) // 안녕
```
- `.rawValue` 로 접근하면 String 값을 확인할 수 있다.
- 확인할 때 마다 인스턴스를 생성하게 되는 단점이 있다.

### 인스턴스 메서드를 사용하는 방법

```swift
enum Greeting {
    case sayHello
    case sayGoodBye
    
    func message() -> String {
        switch self {
        case .sayHello:
            return "안녕"
        case .sayGoodBye:
            return "잘가"
        }
    }
}

print(Greeting.sayHello.message()) // 안녕

```
- `message()` 메서드를 만들어서 접근하는 방법인데 `rawValue`와 마찬가지로 인스턴스를 생성해야하는 단점이 여전히 존재한다.
- 또한 코드의 길이도 길어진다.

### 연산프로퍼티를 사용하는 방법
```swift
enum Greeting {
    case sayHello
    case sayGoodBye
    
    var message: String{
        switch self {
        case .sayHello:
            return "안녕"
        case .sayGoodBye:
            return "잘가"
        }
    }
}

print(Greeting.sayHello.message) // 안녕

```
- 메서드를 만드는 것이 아니라 연산프로퍼티로 적용하는 방법. 코드는 조금 간결해졌지만 인스턴스는 여전히 생성해야한다.

### 타입프로퍼티를 사용하는 방법

```swift
enum Greeting {
    static let sayHello = "안녕"
    static let sayGoodBye = "잘가"
}

print(Greeting.sayHello) // 안녕

```
- `case` 로 만들어 주는 것이 아니라 `static let` 타입 프로퍼티로 만들어주면 인스턴스 생성이 필요 없어진다!
- swift는 `Copy on Write` 를 적용하기 때문에 값 타입인 열거형이어도 참조만으로 접근할 수 있게 된다.
- 따라서 **`case`를 정의**하고 문자열을 꺼내게 된다면 꺼낼때 마다 **새로운 인스턴스를 생성하게 되는 것**이고, **`static let` 으로 접근한다면 참조만으로 문자열에 접근**할 수 있게 된다.

### 그렇다면 struct 에서 타입 프로퍼티를 적용할 수 있을까? 

- 처음엔 안되지 않을까? 생각했는데, 또 안되는 이유도 없었다. 결국 가능하다.

```swift
struct Greeting {
    static let sayHello = "안녕"
    static let sayGoodBye = "잘가"
}

print(Greeting.sayHello) // 안녕
```

#### 그럼 이 둘의 차이는 뭘까? 

- 정답은 **이니셜라이저**에 있다.
- struct 은 새로운 인스턴스를 만들 수 있다.

```swift
struct Greeting {
    static let sayHello = "안녕"
    static let sayGoodBye = "잘가"
}

print(Greeting.sayHello) // 안녕

let greeting = Greeting()
```
- 이런식으로 만들수야 있지만 내부에 타입 프로퍼티만 있기 때문에 할수있는 작업은 없지만 굳이 불필요한 초기값을 만들도록 냅둘 필요가 없어 보인다.
- 이를 방지하기 위해 `private init() { }`을 만들어주어 초기값을 만들지 못하게 할 수 있지만 굳이?
- 그냥 enum으로 쓰는게 더 깔끔하다,,

## 참고
[예거블로그](https://bicycleforthemind.tistory.com/26)
[Apple 공식문서-enum](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)
