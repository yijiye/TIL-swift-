# singleton 패턴의 장단점

지난번 `singleton` 개념에 대해 정리해보았다. [singleton 정리](https://github.com/yijiye/TIL-swift-/blob/main/Swift/Concept/singleton.md) `singleton`을 사용하면서 장점위주로 생각했는데, 단점에 대해 알아보자!!

## 장단점 
### 장점 
- 전역적으로 하나의 인스턴스만 생성되기 때문에 메모리 낭비를 방지할 수 있다.
- 메모리를 할당하고 초기화하는 시간이 줄어들어 객체 접근 시간이 줄어든다.

### 단점
- init이 private이기 때문에 Mock 객체를 만들어 내기 어려워 테스트가 힘들다.
- 전역적으로 접근할 수 있어서 의존성이 생긴다.
- 멀티 스레드에서 스레드 세이프하지 않다.
  - `singleton`은 하나의 인스턴스만 생성되어야 하는데 멀티스레드 환경에서 동시에 접근할 시 객체가 2개 생성되는 위험이 발생할 수 있다.


-----
`singleton` 패턴은 `anti-pattern`이고 `shared instance`와 다른점이 있는데, 이를 알아보자!
먼저 `singleton`을 만들 때 사용되는 `static keyword`에 대해 알아보자


## static 키워드
`static`키워드가 붙은 프로퍼티나 메서드는 타입메서드라고 하는데, 이는 타입 자체에 연관될 때 사용된다. 즉, `유일한 값`을 가질때 사용된다!
타입 메서드는 인스턴스를 생성하지 않고 타입 메서드 자체에서 바로 접근이 가능하다.

```swift
class SuperClass{
    class func printName(){
        print("this is \(self)")
    }

    static func printName2(){
        print("this is \(self)")
    }
}

class SubClass: SuperClass {
    override class func printName(){   // >>> 오버라이드 가능
        print("this is \(self)")
    }

    override static func printName2(){ // >>> 오버라이드 불가 컴파일 에러
        print("this is \(self)")
    }

}

SuperClass.printName()  // 인스턴스가 아니라 타입 자체에 접근하여 메서드를 호출한다.
SubClass.printName()   
```

- `static`과`class` 키워드의 차이점은 `class` 키워드는 오버라이드가 가능하지만 static은 오버라이드가 불가능하다. 또한 class 키워드는 클래스에서만 사용 가능하다.
- 인스턴스가 아니라 타입 자체에 접근하기 때문에 인스턴스를 만들어서 접근하려고 하면 **오류**가 발생한다!

### configuration을 위한 static property 사용하기
`static property`의 가장 일반적은 사례는 환경설정(configuration)이다.
enum의 네임스페이스를 제공하여 스타일 가이드로 사용하는 경우이다.
enum을 통해 `static property`를 사용하고 있는 이유는 설정 object를 인스턴스로 만들지 못하도록 하기 위해서이다! enum은 이니셜라이저를 가지고 있지 않아 해당 목적에 부합하다.

### 비싼 객체에 대해 static property 사용하기
또 다른 용도는 캐시로 사용하는 것이다. 특정 object를 생성하는 것은 많은 비용이 들 수 있기 때문이고 가장 좋은 예시는 `dateFormatter`이다. 
`dateFormatter`는 생성비용이 많이 들고, 아무런 영향 없이 재사용될 수 있기 때문에 `static property`로 생성할 수 있다.
**생성하는데 비용이 많이 들면서, 안전하게 재사용**될 수 있는 객체는 `static property`로 정의하는게 좋다.

#### shared instance는 언제 만드는가

- `URLSession.shared`
- `UserDefaults.standard`
- `NotificationCenter.default`
- `DispatchQueue.main`

이들은 모두 공유 인스턴스의 예시히다.
각 Object는 default를 갖고 있는 `static property`가 있거나, type의 `shared instance`가 있으며 이를 `singleton`이라 생각하면 잘못된 것이다!
`singleton`은 한가지 인스턴스만 가질 수 있는 객체이다. Swift에서는 property로 정의되는 경우가 많지만, 다른 언어에서는 단순히 이니셜라이저를 사용할 수도 있고 동일한 인스턴스를 반복해서 얻을 수 있다.

위의 예시는 `singleton`이라기 보다 `shared instance`이다. 그 이유는 모든 객체에 대해 각각의 인스턴스를 만들 수 있기 때문이다. 
`shared instance`를 사용할 때에도, 다른 인스턴스를 사용할 수 있는 경우를 대비해 `built-in escape hatch`를 만들어라.

```swift
struct NetworkingObject {
  let urlSession: URLSession
  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
}
```
Unit Test를 할때, Mock 객체를 만들어 다른 URLSession을 사용했던 경험이 있는데 이처럼 다른 인스턴스를 사용할 수 있게끔 해놓을 수 있다.

### `static let`과 `static var`는 언제 쓰일까?
`static let`이 거의 한 세트처럼 자주 쓰이는 것은 봤는데, `static var`는 뭔가 생소한 느낌이다. 그래서 언제쓰이는지 궁금해서 찾아봤는데 이해하기 좋은 예시를 발견했다!

<img src="https://hackmd.io/_uploads/SkEnGFCDn.png" width="500">

- [예시 출처](https://varyeun.tistory.com/entry/스위프트에서-static-키워드란-static-in-swift)

2개의 `Animal()` 인스턴스를 생성했는데 타입 메서드 `nums`는 공유할 수 있는 예시이다.


## 참고
- [Apple Developer - Methods](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/methods/)
- [sujinnaljin static과 class method, property 효과적으로 사용하기](https://sujinnaljin.medium.com/swift-static과-class-method-property-효과적으로-사용하기-b336311a923c)
