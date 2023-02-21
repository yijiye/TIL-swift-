# Meta Type
- 타입의 타입

## Type 이란?

```swift
struct Person {
    static let name = "리지"
    var age = 20
}

let riji = Person.init()
riji.age
Person.name
```
- static let 으로 선언된 name을 호출할 때, Person을로 접근해야함 (타입의 이름으로 접근)
- age는 riji로 접근 가능 (생성된 인스턴스로 접근)

### Person이란 타입 이름을 모르는 경우 name에 어떻게 접근 할 수 있을까 👀
- `type(of:)` 메서드를 사용하여 접근할 수 있음!

```swift
let rijiType = type(of: riji)
print(rijiType) // Person
```
- 타입 자체의 타입을 바로 **메타타입** 이라 한다.
- rijiType은 Person 타입 자체 즉, 타입의 타입, 메타타입이다!!
- Person 타입은 Person 인스턴스의 타입을 의미하고 Peron 타입의 타입은 그 자체 메타타입임을 뜻한다

## .Type
- 메타타입을 나타내는 표현
- Person.Type 으로 표현 가능
```swift
let rijiType: Person.Type = type(of: riji)
```

## Static Metatype vs Dynamic Metatype

- Static Metatype: 메타타입의 값을 얻어내기 위한 `self` : 컴파일 시점에 타입이 정해진다.
- Dynamic Metatype: `Type(of:)` : 런타임 시점에 타입이 정해진다.
- 컴파일은 컴퓨터언어로 변환되는 시점, 런타임은 프로그램이 동작하는 시점

## TableView에서 찾아보기
```swift
let tableView = UITableView()
tableView.register(cell.self, forReuseIdentifier: "cell")

// register 함수
func register(
    _ cellClass: AnyClass?,
    forCellReuseIdentifier identifier: String
)

// AnyClass
typealias AnyClass = AnyObject.Type
```
- register 함수에서 self로 cell의 메타타입의 값을 의미
- register 함수를 보면 AnyClass? 가 있는데, 이는 .Type으로 메타타입이다.
- 즉 .Type 메타타입이므로 self로 받아주는 것!!

## 참고
[개발자소들이](https://babbab2.tistory.com/151)
[공식문서](https://developer.apple.com/documentation/uikit/uitableview/1614888-register)
