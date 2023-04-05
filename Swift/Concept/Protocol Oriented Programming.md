# protocol oriented programming (POP)

- 기능의 청사진의 역할을 수행
- Delegate, DataSource 등으로 이용
- 기본 구현 가능 => `protocol + extension`

## 시작점

- 상속의 한계
  - 서로 다른 클래스에서 상속받은 클래스는 동일한 기능을 구현하기 위해 중복코드가 발생한다.
  - 단일상속으로 발생하는 한계 (현실세상과 괴리가 있다)
    - 자식클래스는 하나의 부모클래스만 상속받을 수 있다. (그렇지 않은 언어도 있음, 다중상속을 하게 되면 계층을 나누는게 모호해지는 문제가 있다.)
- 카테고리의 한계 및 부작용
   - 프로퍼티 추가 불가
   - 오직 클래스에만 적용 가능
   - 기존 메서드 오버라이드 가능
- 참조타입의 한계
   - 동적 할당과 참조 카운팅에 많은 자원 소모 
   - 다른 곳에서 참조를 건드리면 의도치않게 본래의 값이 변할 수 있는 문제 

**이러한 한계를 극복하기 위해 POP 개념 도입**

## 적용방법

**protocol + extension = Protocol Default Implementation**
- 특정 프로토콜을 정의하고 여러 타입에서 이 프로토콜을 준수하게 만들어 타입마다 똑같은 메서드, 똑같은 프로퍼티를 구현하게 된다면 중복 코드를 사용하게 되고 유지보수가 굉장히 힘들어진다.
- 이를 방지하는 것이 프로토콜 초기 구현 **Protocol Default Implementation** 이다.


```swift
protocol PokemonProtocol {
    var type: String { get }
    func skill()
}

extension PokemonProtocol {
    func skill() {
        print("주특기 공격!")
    }
}
```
- PokemonProtocol 의 skill() 메서드의 기본 구현을 extension을 통해 할 수 있다. 이렇게 되면 PokemonProtocol을 채택하는 타입은 skill을 구현하지 않아도 사용할 수 있게 된다.

```swift
// 상속을 사용하기 위해 class로 구현
class 피카츄: PokemonProtocol {
    
    var type: String = "전기"
    func electricAttack() {
        print("백만볼트")
    }
}

class 라이츄: 피카츄 {
    override func electricAttack() {
        print("천만볼트")
    }
}

let 피카츄우 = 피카츄()
피카츄우.electricAttack() // 백만볼트
피카츄우.skill() // 주특기 공격
피카츄우.type // 전기

let 라이츄우 = 라이츄()
라이츄우.type // 전기
라이츄우.electricAttack() // 천만볼트
```

- class 사용 없이 protocl + extension + struct 활용
```swift
protocol ElectricPokemonProtocol {
    var name: String { get }
    var type: String { get }
    func skill()
}

extension ElectricPokemonProtocol {
    var type: String {
        get {
            "전기"
        }
    }
    func skill() {
        print("전기 공격!")
    }
}
struct Pokemon: ElectricPokemonProtocol {
    var name: String
}


let 피카츄 = Pokemon(name: "피카츄")
피카츄.skill() // 전기 공격!
피카츄.type // 전기
피카츄.name // 피카츄

let 라이츄 = Pokemon(name: "라이츄")
라이츄.type // 전기
라이츄.skill() // 천만볼트
라이츄.name // 라이츄

```

## 이점
- 범용적인 사용
   - 클래스, 구조체, 열거형 등 모든 타입에 적용 가능
   - 제네릭과 결합하면 더욱 파급적인 효과 (Type safe & Flexible code)
- 상속의 한계 극복
   - 특정 상속 체계에 종속되지 않음
   - 프레임워크에 종속적이지 않게 재활용 가능

- 적은 시스템 비용
- 용이한 테스트
- 보일러플레이트 코드 혹은 보일러플레이트 (변화없이 여러 군데에서 반복되는 코드) 방지

## 한계
- default implimentation 이 object-c protocol에서는 적용되지 않는다.
- Delegate, DataSource는 object-c 로 작성되어 있어 그 프레임워크에 swift extension을 붙여줘도 작동하지 않는다. (기본구현 불가)

----

## protocol + struct vs class
> 어떤 상황에서 protocol을 사용하는 것이 좋고, 어떤 상황에서 class를 사용하는 것이 좋을까 ?

### 나만의 개념 정리
- protocol은 이 protocol을 채택할 시 준수해야 하는 메서드나 프로퍼티, 지켜야 하는 약속을 명시한 청사진이다. 그렇기 때문에 기본 구현은 필요 없다.
- struct은 값 타입으로 stack영역에만 저장되는 타입이다. 값 타입이기 때문에 새로운 인스턴스를 생성할 때 마다 새로운 값이 복사가 되고 다른 객체가 된다.
- class는 참조 타입으로 인스턴스는 heap 영역에 올라가 있으며 그 주소값이 stack 영역에 올라가게 된다. 참조 타입이므로 새로운 인스턴스를 만들어 그 내부 속성에 접근한다면 원래 본판의 속성도 같이 바뀌게 된다. 그래서 전역적으로 하나의 속성에 접근하도록 구현하는 singleton을 사용할 때 class를 사용하는 것이 좋다.

### class를 사용하면 좋은 경우
- singleton 구현 : 전역에서 하나의 인스턴스에 접근할 때
- 상속이 필요한 경우 ? struct도 protocol 기본 구현으로 상속의 역할을 대신 처리해 줄 수 있기 때문에 여러 경우를 생각해봐야 한다.

### protocol + struct을 사용하면 좋은 경우
- 여러타입이 같은 기능을 구현할 때 : protocol 기본 구현으로 중복 코드 방지
- 원래 본연의 값이 바뀌지 않아야 할 때 : class는 참조 타입이기 때문에 다른 곳에서 class의 값을 변경하게 되면 그 값이 전부 바뀌기 때문에, 값 타입은 strcut을 사용하는게 안전할 수 있다고 생각된다.

### 요약

- struct, protocol을 사용하자..🔥


----

## WWDC
<img src="https://i.imgur.com/GeirRPg.png" width="400">

- 메타타입
```swift
protocol Ordered {
    func proceds(other: Self) -> Bool // Self 메타타입
}

struct Number: Ordered {
    var value: Double = 0
    func proceds(other: Number) -> Bool {
        return self.value < other.value
    }
}
```
- Self 타입을 명시하여 Number 구조체가 Ordered 프로토콜을 채택시 Self에 본인 타입을 Number를 넣어줄 수 있다.

### 제네릭 + protocol
- 배열을 예시로 만든 코드로 제네릭타입 구현시 여러 타입으로 사용가능한 장점을 확인할 수 있다.

```swift
protocol Stackable {
    // 프로토콜을 채택하는 데이터 타입이 Generic일 경우 사용
    associatedtype item
     
    var items: [item] { get set }
    
    mutating func add(item: item)
}

// protocol 초기 구현
extension Stackable {
    mutating func add(item: item) {
        items.append(item)
    }
}

// struct
struct Stack<T>: Stackable {
    var items: [T]
    
    typealias item = T
}

var intStack = Stack<Int>(items: [1, 2, 3])
intStack.add(item: 4)
intStack.items // ---> [1, 2, 3, 4]

var strStack = Stack<String>(items: ["하나", "둘", "셋"])
strStack.add(item: "넷")
strStack.items // ---> ["하나", "둘", "셋", "넷"]
```
[코드참고](https://velog.io/@haanwave/iOS-Swift-Protocol-Oriented-Programming-POP)

----

## 참고
[WWDC16](https://developer.apple.com/videos/play/wwdc2015/408/?time=803)
[코드스쿼드 youtube](https://www.youtube.com/watch?v=9gkzHUsQiUc&t=2s)


