# ARC (Automatic Reference Counting)
- swift의 메모리 사용량 추적 및 관리 시스템
- 클래스 인스턴스를 할당할 때 해당 인스턴스에 대한 참조가 생김 (RC=1 증가)
- 더이상 필요하지 않은 클래스 인스턴스를 자동으로 메모리에서 해제한다. (struct은 힙 영역에 있지 않기 때문에 ARC와 관련 없다.)

```swift
class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
}

let personA = Person(name: "사람1") // personA 스택, Person 힙, RC=1 (사람1에 대한)
let personB = Person(name: "사람2") // personB 스택, Person 힙, RC=1 (사람2에 대한)

let personC = personA // 사람1 에 대한 RC=1 상승, 총 RC=2
```

### 강한 순환 참조 
- 기본적으로 값을 참조할 때는 강한 참조가 일어난다. 그런데 만약 인스턴스가 서로 강한참조를 하고 있고 그 인스턴스에 접근하는 인스턴스가 nil이 되어 더이상프로퍼티에 접근할 수 없다면 영원히 메모리에서 해제할 수 없게 된다. 이를 **강한순환참조** 라고 한다.
```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name)이 해제되었습니다.")}
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var 거주자: Person?
    deinit { print("아파트 \(unit) 이 해제되었습니다.")}
}

var 리지: Person?
var unit4A: Apartment?

리지 = Person(name: "리지")
unit4A = Apartment(unit: "4A")

```
- 리지와 unit4A라느 인스턴스를 만들면 아래와 같이 RC=1 씩 증가한다.

![](https://i.imgur.com/kiAkzcV.png)

- Person 클래스와 Apartment 클래스는 서로를 프로퍼티로 가지고 있고 그 값은 옵셔널 (?) 이기 때문에 기본값으로 nil이 할당된다.

```swift
리지!.apartment = unit4A
unit4A!.거주자 = 리지
```
- 프로퍼티 값을 서로의 값으로 입력해주면 < 상수 또는 변수에 클래스 인스턴스를 할당할 때, 해당 인스턴스에 대한 참조가 생긴다 > 는 전제에 맞게 서로를 참조하게 된다.

![](https://i.imgur.com/IwoIym7.png)

```swift
리지 = nil
unit4A = nil
```
- 각 인스턴스에 nil 을 할당하고 실행하면 ```deinit```이 실행되지 않는다.
- 왜냐하면 서로를 참조하고 있는 상태는 계속되기 때문에 RC=0 이 아니다.
- 이와 같은 상황이 되면 프로퍼티에 접근할 변수가 아예 nil이 되어버려 접근할수도 없고 메모리가 해제되지 않는다.
- 이런 문제를 **강한 순환 참조(Strong Reference Cycles)** 이라 부른다.

![](https://i.imgur.com/itCCsKV.png)

### 해결방법
**weak** : RC를 증가시키지 않는다.

```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name)가 해제되었습니다.")}
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var 거주자: Person? // weak 키워드
    deinit { print("아파트 \(unit) 가 해제되었습니다.")}
}

var 리지: Person?
var unit4A: Apartment?

리지 = Person(name: "리지")
unit4A = Apartment(unit: "4A")

리지!.apartment = unit4A
unit4A!.거주자 = 리지
리지 = nil

```
![](https://i.imgur.com/s5511mq.png)

- Apartment 클래스의 Person타입을 갖는 변수 거주자를 ```weak var```로 변경하고 인스턴스를 해제 한다면 메모리 할당이 해제된다.
- var 리지가 nil이 되면 강한 참조가 끊어지면서 RC=0이 된다. 그럼 Apartment를 참조하고 있던 person 인스턴스가 메모리에서 해제되고 결국 unit4A만 남게된다.
- 이 과정에서 Apartment에서 참조하는 person 이 사라지므로 자동으로 거주자는 nil 값으로 변경된다. 
    - 그렇기 때문에 항상 옵셔널로 선언해야한다. (nil로 변할 수 있으므로)
    - nil로 변할수 있기 때문에 항상 변수로 선언해야한다.

![](https://i.imgur.com/p1B5Kw9.png)

- 위의 코드를 실행시켜보면 디이니셜라이즈가 실행되어 출력문을 아래와 같이 확인할 수 있다.
<리지가 해제되었습니다.>

**서로 참조하는 경우 weak로 선언해야하는 인스턴스의 기준?**
- <span style='background-color:#fff5b1'>인스턴스의 수명이 더 짧은 쪽에 (먼저 할당 해제 할 수 있는 경우) 약한 참조를 사용한다.</span>
- 거주자와 아파트를 생각했을 때, 아파트는 있고 거주자가 있을지 없을지 모르는 상황이기 때문에 거주자가 아파트를 참조할 때 약한 참조로 설정한다.
- 만약 둘다 약한 참조라면? 🤔

**unowned** 
- weak 참조와 달리 <span style='background-color:#fff5b1'>인스턴스의 수명이 같거나 더 길 경우에 사용한다.</span>
- 항상 값이 있을 것이라 예상되기 때문에 옵셔널로 사용하지 않고 (일반적으로? 옵셔널인 경우도 있음 아래 설명추가), 참조하는 인스턴스가 nil이 되어도 그 값이 nil로 변경되지 않는다.

![](https://i.imgur.com/uyUy0rx.png)

- 이미 거주자에 들어있는 값은 메모리가 해제되어 존재하지 않는다.
- 해제된 메모리 영역을 가리키고 있는 것을 ```daling pointer```라고 한다.
- 그래서 ```uni4A.거주자``` 는 접근할 수 없게 된다.
- 이러한 경우 크래시가 발생할 수 있고 반드시 수명이 같거나 더 길 경우만 사용하도록 한다!

<공식문서 예제>
```swift
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var 리지: Customer?
리지 = Customer(name: "리지")
리지!.card = CreditCard(number: 1234_5678_9012_3456, customer: 리지!)

리지 = nil
// 리지 is being deinitialized 출력
// Card #1234567890123456 is being deinitialized 출력 
```
- 신용카드가 고객보다 먼저 사라지기 때문에 (즉 사람 인스턴스 수명이 더 길기 때문에) unowned 키워드를 사용한 예제이다.

![](https://i.imgur.com/NUr2h10.png)


- customer RC=1, creditcard RC=1 이다.
- 만약 customer를 nil로 할당하는 순간 RC=0이 되면서 메모리에서 해제되고 신용카드를 참조하는 것도 사라지게되어 RC=0이 된다. 그래서 출력하면 둘다 deinit 된 것을 확인할 수 있다.
- unowned 특징
   - nil이 될 일이 없다.
   - let으로 선언 가능하다.

**optional unowned**
- 항상 유효한 객체를 참조하거나 nil로 설정되어 있는지 확인해야 한다.
- 위에서 unowned는 수명주기가 같거나 더 길 경우에 사용하고 그렇지 않은 경우 daling pointer라는 오류를 만날 수 있다고 언급했다. 그런경우 optional unowned를 사용하면? 에러가 안난다. (그런데 이 경우 인스턴스 수명주기를 고려하면 weak를 사용하는게 가장 적절하다고 생각된다.)

```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name)가 해제되었습니다.")}
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    unowned var 거주자: Person? // 미소유 옵셔널로 변경
    deinit { print("아파트 \(unit) 가 해제되었습니다.")}
}

var 리지: Person?
var unit4A: Apartment?

리지 = Person(name: "리지")
unit4A = Apartment(unit: "4A")

리지!.apartment = unit4A
unit4A!.거주자 = 리지
리지 = nil // 리지가 nil 이어도 에러가 발생하지 않는다
```
- 그래서 왜 쓰는게 좋을까..? 이해가 잘 되지 않았는데 찾아보니 이런 장점이 있다.</br> [참고- zeddios 티스토리](https://zeddios.tistory.com/1214)
   - 신용카드랑 고객과의 관계처럼 고객이 절대 신용카드보다 수명주기가 짧을 수 없는 상황이라면 미소유 옵셔널을 사용하는게 좋다. 왜냐면 여기서 weak를 쓰면 관련 weak 참조를 전부 추적하고 있어야 한다고 한다. 이 자체가 굉장한 비용이 드는 일이라고 한다.
   - 미소유 옵셔널을 사용하면 내가 unowned로 참조하고 있는 인스턴스가 절대 해제될일이 없다는것을 표현해줄 수 있다고 함!!
   - 또한 weak 사용시 발생하는 비용적인 측면과 복잡성에서 이점이 있다고 한다.

---
## 참고
[🍎 공식문서](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)
