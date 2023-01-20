# Methods
> 메서드는 특정 타입과 관련된 함수이다.
> 클래스, 구조체, 열거형은 인스턴스 메서드와 타입 메서드를 정의할 수 있다.

# Instance Methods

- 함수와 같다 ```func 함수이름 () 로 표현```
- 그러나 인스턴스 메서드는 인스턴스 생성 없이는 호출 될 수 없다.


## The self Property

- 모든 인스턴스는 ```self (인스턴스 그자체)```라고 불리는 함축적 프로퍼티를 가진다.
- self는 생략가능하다. swift 가 생성된 메서드에서 추론하기 때문!
```swift
class Counter {
    var count = 0
    func increment() {
        count += 1 // self.count 인데 self 생략
    }
}
```
- 그러나, 파라미터 이름과 프로퍼티 이름이 동일한 경우는 self를 입력하여 구분짓는다.

## Mutating 
> Modifying Value Types from Within Instance Methods
- 구조체와 열거형은 값 타입이다.
- 값 타입의 프로퍼티는 인스턴스 메서드 내에서 수정할 수 없다.
- 만약 수정한다면 mutating 을 사용할 수 있다!

예시코드
```swift
struct Person {
    var name: String = "리지"
    var age: Int = 20
    func nextYear() {
        age += 1 // age 값을 변경할 수 없으므로 error
    }
}
```
```swift
struct Person {
    var name: String = "리지"
    var age: Int = 20
    mutating func nextYear() {
        age += 1 // mutating 을 붙여주어 변경 가능!!
    }
}
```

- mutating method는 self 프로퍼티에 새로운 인스턴스를 할당할 수 있다.
```swift
struct Person {
    var name: String = "리지"
    var age: Int = 20
    mutating func nextYear() {
        self = Person(age: self.age + 1)
    }
}
```
위의 예시코드와 동일

- enum 타입에서도 동일하게 사용 가능하다
```swift
enum SizeSwitch {
    case small, medium, large
    mutating func size() {
        switch self {
        case .small:
            self = .medium
        case .medium:
            self = .large
        case .large:
            self = .small
        }
    }
}
var sizeList = SizeSwitch.small
sizeList.size() // medium
sizeList.size() // large
```

처음 값은 small 이므로 ```size()``` 메서드를 호출하면 medium이 출력된다.
medium이 출력된 후 medium 으로 값이 변경되었기 때문에 ```size()``` 메서드를 호출하면 large가 호출된다.

# Type Methods
> class/static func 함수이름()


```swift
class SomeClass {
    class func someTypeMethod() {
        // type method implementation goes here
    }
}
SomeClass.someTypeMethod()
```
- 타입메서드의 self 기능은 타입의 인스턴스를 지칭하는게 아니라 타입 그 자체를 지칭한다.
- 그로인해 타입프로퍼티와 타입메서드의 파라미터를 구분한다.
- 결국은 인스턴스 생성없이 클래스내의 메서드를 호출하는 것을 타입 메서드라고 한다.
- ```someClass```를 할당받는 인스턴스가 없는데 바로 그 안의 메서드 ```someTypeMethod()``` 를 호출하는 것 처럼!!
- class func 는 메서드의 override 를 허용한다.
- 반면 static func 는 메서드의 override 를 허용하지 않는다.
- 그 이유는 struct, enum 은 상속이 불가능 하기 때문에 override를 허용하지 않는 class 는 사용할 수 없다.
- 타입메서드를 사용할 때는 해당 프로퍼티나 메서드가 타입 자체와 연관될 때 사용하면 좋다고한다.

---

[메서드공식문서](https://docs.swift.org/swift-book/LanguageGuide/Methods.html)
[타입메서드 참고](https://infinitt.tistory.com/399)
[mutating 참고](https://seons-dev.tistory.com/entry/Swift-기초문법-메서드-2-mutating)

