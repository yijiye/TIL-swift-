# Properties (프로퍼티)

- 프로퍼티란, 타입 내부에 정의된 상수나 변수를 나타낸다.
특정 class, struct, enumeration의 값과 연관되어 있다.

## Stored properties (저장프로퍼티)

- 가장 기본이 되는 값
- var(변수), let(상수)로 선언할 수 있다.

예시코드

```swift
struct Computer {
    var version: Int
    let brand: String
}
var rijiComputer = Computer(version: 16, brand: "Apple")
rijiComputer.brand = "samsung" //error : let 이므로 변경할 수 없다
rijiComputer.version = 15

```
Computer라는 struct 를 만들고 rijiComputer 인스턴스를 정의하였다.
변수인 version 은 값을 변경할 수 있지만 상수인 brand 는 값을 변경할 수 없다.


## Lazy properties (지연저장프로퍼티)

- 사용되기 전까지 항상 변수로 선언!
그 이유는, 인스턴스 초기화가 완료된 후 까지 초기값이 회수되지 않을수도 있기 때문이다

- 상수 프로퍼티는 항상 값을 가져야 하므로 Lazy properties 를 선언할 수 없다.

🔍 **언제사용하면 좋을까?**
- 초기값이 외부요인에 의해 결정될 때
- 초기값이 필요하지 않을 때
이니셜라이즈가 필요하지 않고 값에 접근을 시도할 때만 실행되므로 메모리를 절약할 수 있다.

예시코드
```swift
struct Computer {
    var name: String = "맥북"
    lazy var type: String = self.name + "프로"
}

var mac = Computer()
mac.name = "리지의맥북"
print(mac.type)

```
type을 지연저장프로퍼티로 선언을 하였고 인스턴스 mac을 생성하여 type에 접근할 때에만 사용가능하다

## Computed properties (연산프로퍼티)

- get, set 구문을 사용하고 읽고 쓰기의 기능을 추가
- 값을 저장하는 것이 아니라 연산해주는 것!

예시코드
```swift
struct Money {
    var won: Double
    var yen: Double {
        get {
            return won * 1000
        }
        set(newValue) {
            won = newValue * 0.001
        }
    }
}

```
1) yen 이란 값을 읽어올 때 get 을 사용하고 yen 을 won에 1000을 곱한 값으로 return 을 한다
2) 그러면 return된 값은 yen의 값이 되고 그걸 쓸때 won은 새로운 yen(newValue) 값에 다시 1000을 나눈 값을 부여한다

## Property Observers (프로퍼티옵저버)

- willSet, didSet 구문을 사용
- willSet은 아직 변하지 않은 값, didSet은 변한 값 

예시코드
```swift
var age: Int = 29 {
    
    willSet(nextYearAge) {
        print(age,"willSet")
        print(nextYearAge)
    }
    didSet(lastYearAge) {
        print(age,"didSet")
        print(lastYearAge)
    }
}
age = age + 1
```

1. age = 29로 변수선언을 하고 willSet은 아직 변하지 않은 값이니까 29이고 변할 값인 nextYearAge에는 30이 출력된다.
2. didSet은 변한 값이니까 30이고 변하기 전의 값은 lastYearAge는 29이다.

## Property Wrappers

- 프로퍼티를 감싸주어 특정 범위를 지정해준다? 고 이해하였음

```swift
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}
```
Swift 공식문서의 예시

1. number의 최대값을 12로 설정하여 감싸주었다

```swift
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Prints "0"

rectangle.height = 10
print(rectangle.height)
// Prints "10"

rectangle.height = 24
print(rectangle.height)
// Prints "12"
```

2. 따라서 값을 24로 선언한다 해도 최대값을 12로 property wrapper 를 사용하여 지정했기 때문에 12가 출력되는 것을 알 수 있다.
[swift 공석문서, 프로퍼티](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)
