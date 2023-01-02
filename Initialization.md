
# Initialization
> 인스턴스를 생성할때 원하는 값을 바로 입력해줄 수 있다.
> 프로퍼티 기본값을 지정하기 어려운 경우 이니셜라이저를 사용한다.
> 프로퍼티의 초기값이 필요 없을때는 옵셔널을 사용, 옵셔널 값은 이니셜라이저에 넣어도 되고 넣지 않아도 된다.

### Initializers
``` init() ```으로 표현
```swift
struct Person {
    var name: String
    init() {
        name = "리지"
    }
}
```
### Customizing Initialization

#### Initialization Parameter

```swift
struct Person {
    var age: Int
    init(englishAge : Int) {
        age = englishAge
    }
    init(koreanAge : Int) {
        age = koreanAge
    }
}

let rijiEnglishAge = Person(englishAge: 20)
let rijiKoreanAge = Person(koreanAge: 21)

rijiEnglishAge.age // 20
rijiKoreanAge.age // 21

```
- age 라는 프로퍼티를 이용하여 enlishAge, koreanAge 값을 customizing 하여 나타낼 수 있다.

#### Parameter Names and Argument Labels
> 이니셜라이저 안에 매개변수로 지정할 수 있다.
```swift
struct Person {
    var age: Int
    var name: String
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}
```
- 매개변수가 있다면 생략해서 사용할 수 없다
- 매개변수 없이 사용하고 싶다면 _ 를 이용
### Optional Property Types

> 값이 있을수도 있고 없을수도 있다면 옵셔널타입으로 정의
> 옵셔널 값은 이니셜라이즈 생성을 안해주어도 된다. (자동적으로 nil 값이  default로 설정됨)

### Memberwise Initializers for Structure Types
> 구조체에서는 이니셜라이즈를 생성하지 않아도 자동으로 생성된다

### 이니셜라이저 extension 활용
> 만약 struct 안에 여러 이니셜라이저를 사용한다면 extension 을 사용할 수 있다.
```swift
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
}
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```
### convenience initializer (class 에서만 사용)
> 같은 클래스에서 지정된 이니셜라이즈를 사용하고 싶을때 사용
> 즉, 자신의 이니셜라이저를 사용할때 앞에 convenience를 입력한다

```swift
class Person {
    var name: String
    var age: Int
    var nickName: String?
    
    convenience init(name: String, age: Int, nickName: String) {
        self.init(name: name, age: age)
        self.nickName = nickName
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```
### designated vs convenience (class 에서만 사용)
- designated 는 superclass에서 호출 (수직적 구조)
- convenience 는 같은 class에서 호출 (수평적 구조)


### Initializer Delegation for Class Types
- 규칙 1. 자식클래스의 지정 이니셜라이저는 부모클래스의 지정 이니셜라이저를 반드시 호출해야 한다.
- 규칙 2. 편의 이니셜라이저는 자신을 정의한 클래스의 다른 이니셜라이저를 반드시 호출해야 한다.
- 규칙 3. 편의 이니셜라이저는 궁극적으로 지정 이니셜라이저를 반드시 호출해야 한다.

### 안전확인 4단계 two-phase initialization

```swift
class Human {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class riji : Human {
    var nickName: String
    init(nickName: String, name: String, age: Int) {
        self.nickName = nickName // 안전확인 1. 자식의 초기값을 먼저 설정해야 한다.
        // 안전확인 2. self.name / self.age 부모클래스의 초기화 값을 먼저 할당해줄 수 없다.
        super.init(name: name, age: age)
        // 안전확인 2. self.name / self.age 부모클래스의 초기화 값을 할당하면 그 이후에 값을 넣어줄 수 있고, 값은 변경된다.
    }
}
// 편리한 초기화의 사용법
class Person {
    var name: String
    var age: Int
    var nickName: String?
    
    convenience init(name: String, age: Int, nickName: String) {
        self.init(name: name, age: age)
        self.nickName = nickName
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}


class PersonA {
    var name: String
    var age: Int
    var gender: String

    init(name: String, age: Int, gender: String) {
        self.name = name
        self.age = age
        self.gender = gender
    }

    convenience init(name: String) {
        self.init(name: name, age: 20, gender: "남")
    }

    convenience init() {
        self.init(name: "아무개") // 안전확인 3. 편리한 초기화를 할때는, 무조건 지정 이니셜라이저를 호출해야한다. 만약 이 줄이 없이 self.age = 100 을 바로 입력할 수 없다.
        self.age = 100
    }

    func ageMinus() {
        self.age -= 5
        print("ageMinus!!!")
    }
}

class Harry: PersonA {
    var height: Int

    init(height: Int, name: String, age: Int, gender: String) {
        self.height = height
        // 안전확인 4. 1단계에서 초기값이 할당되기 전에 ageMinus 인스턴스를 호출할 수 없다.
        super.init(name: name, age: age, gender: gender)
        ageMinus() // 안전확인 4. 부모의 초기값을 할당하고 나서 1단계를 통과하고 메서드를 호출하는 것은 가능!
    }
//자식은 부모의 편리 초기화를 호출할 수 없다.
}

```
