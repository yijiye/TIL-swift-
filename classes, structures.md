# Memory 구조
- physical memory에 직접적으로 접근하기 어렵기 때문에 운영체제(OS)를 이용하여 logical memory에 접근하여 값을 다룰 수 있다.
- logical memory에는 code,data,stack,heap 이 존재한다.

### stack & heap
- stack과 heap은 같은 공간을 사용한다.
- stack은 높은주소공간에서 쌓이고 heap은 낮은주소공간에서 쌓이는데 서로의 영역을 침범할경우 overflow 오류가 나타난다.
- stack은 선형자료구조로 메모리할당에 좋다. 반면 heap은 비선형자료구조로 값에 접근하는데 stack보다 까다롭다.
- stack 크기는 컴파일 시점에서 결정되는데, struct이나 enum은 크기가 정해져 있고 class는 크기가 정해져있지 않기 때문에 서로 다른 영역에 메모리를 할당한다.


# Structures and Classes
- swift 에서는 단일 파일에서 각 구조체와 클래스를 정의하고 다른 코드에서 사용하는데 용이하다.
## 비교 

### 공통점 
- 저장 프로퍼티를 정의한다.
- 메서드를 정의한다.
- subscript syntax를 이용하여 값에 접근할 수 있다.
- 초기값을 설정할 수 있다.
- 확장하여 사용할 수 있다.
- 프로토콜을 준수한다.

### class만이 가지는 특징
- 상속이 가능하다.
- 타입캐스팅으로 클래스 인스턴스의 타입을 확인할 수 있다.
- 디이니셜라이저로 클래스 인스턴스의 메모리 할당을 해제할 수 있다.
- 하나 이상의 참조가 가능하다.

## 정의
```swift
struct SomeStructure {
    // structure definition goes here
}
class SomeClass {
    // class definition goes here
}
```

## Structure 
![](https://i.imgur.com/UyH4DGt.png)

```swift
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")
// Prints "The current direction is north"
// Prints "The remembered direction is west"
```

- 값을 복사하는 enum도 마찬가지로 CompassPoint.west 값을 가지는 currentDirection 변수와 remeberedDirection은 서로 다른 값을 복사해서 가지고 있다.
- 따라서 rememberedDirection의 값을 바꿔도 currentDirection의 값은 변하지 않는다.

## Class
![](https://i.imgur.com/Itbgbud.png)

```swift=
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0
```
- 주소를 복사하는 class 의 경우 같은 VideoMode() 인스턴스를 참조한다.
- 같은 인스턴스를 참조하고 그 frameRate 값을 25.0 -> 30.0으로 변경하면 값이 변경된다.

## 비교 예문 
```swift
struct Riji {
    var name: String
}

var riji = Riji(name: "riji")
var 리지 = riji
print(riji.name) // riji
리지.name = "리지"
print(리지.name) // 리지
print(riji.name) // riji
```
- struct의 경우 별개의 값이 복사되었으므로 riji 인스턴스를 참조하는 리지의 이름이 바뀌어도 riji의 이름은 바뀌지 않는다.

```swift
class RijiA {
    var name: String
    init(name: String) {
        self.name = name
    }
}

var riji = RijiA(name: "riji")
var 리지 = riji
print(riji.name) //riji
리지.name = "리지"
print(리지.name) //리지
print(riji.name) //리지
```
- 주소를 복사하는 class의 경우 riji 인스턴스를 참조하는 리지의 이름이 리지로 변경되면 riji의 이름도 리지로 변경된다.

## Identity Operators
- 같은 인스턴스를 참조하고 있는지 확인하기 위해 사용
- Identical to (===)

- Not identical to (!==)

```swift
print(tenEighty === alsoTenEighty) // true
```
- alsoTenEighty 는 VideoMode() 클래스의 인스턴스이고 같은 인스턴스를 참조하고 있기 때문에 true가 출력된다.

예시
```swift
class Book {
}
let book1 = Book()
let book2 = Book()
let book3 = book1

print(book1 === book3) //true
print(book1 === book2) //false
print(book2 === book3) //false
```

- book3은 book1과 같은 인스턴스를 참조하니까 true
- book2와 book1은 서로 Book() 이란 같은 클래스의 다른 인스턴스이므로 false
- book2 와 book3 도 마찬가지로 다른 인스턴스를 참조하므로 false 

## Copy on write 
- swift에서 제공하는 것으로 실제 값을 복사하여 인스턴스를 새로 만들어도 프로퍼티나 메서드가 변하지 않으면 새로 만들어 내지 않고 주소값을 복사하도록 유지해주는 기능

```swift
struct Person {
    var name: String
}
let riji = Person(name: "리지")
let 리지 = riji
```
- ```riji```라는 인스턴스를 생성하고 그 인스턴스의 값을 복사한 새로운 인스턴스인 ```리지```가 있다.
- 현재까지는 ```리지```의 프로퍼티값이 바뀐게 없기 때문에 실제로 값을 복사하였지만 변경되기 전엔 주소값을 복사한것으로 유지해준다.
- 만약 ```리지```의 프로퍼티 값이 바뀌면 그땐 값이 복사된 형태가 된다.

## 참고 
[공식문서](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)
