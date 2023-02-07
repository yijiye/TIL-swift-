# 메모리구조
- 주기억장치(RAM) 에 Code, Data, Heap, Stack 영역이 존재, 이 영역을 나눠주는 것은 운영체제 (OS)가 한다.

## Code 영역
- 개발자가 작성한 소스코드가 컴퓨터 언어 (이진법으로 이루어진) 형태로 저장되는 공간
- 컴파일 타임에 결정되고, 중간에 코드가 변경되지 않도록 `Read-Only` 형태로 저장된다.

## Data 영역
- 전역변수, static 변수가 저장되는 공간
- 프로그램 시작과 동시에 할당되고 종료되어야 메모리에서 해제된다.
- 실행 도중 값이 변할 수 있으므로 `Read-Wirte`로 지정된다.

> static의 경우 lazy가 디폴트이므로 해당값에 접근할때 할당되어 메모리에 올라갈 수 있음! *추가학습필요*

## Heap 영역
- 개발자가 할당/해제하는 메모리 영역
- 사용하고 난 후에는 반드시 메모리를 해제시켜줘야 한다.
- 해제되지 않으면 메모리누수가 발생
- `런타임`시 결정되기 때문에 데이터의 크기가 확실하지 않을때 사용
- 클래스, 클로저 같은 참조타입의 값은 힙에 할당된다.

## Stack 영역
- 함수 호출 시 지역변수, 매개변수, return 값 등이 저장된다.
- 함수가 종료되면 자동으로 해제된다.
- `컴파일 타임`에 결정되기 때문에 무한히 할당할 수 없다.
- 임시 메모리 영역!
- CPU가 스택 메모리를 구성하므로 속도가 빠르다.

```swift
func plus(_ a: Int, _ b: Int) -> Int {
    let result = a + b
    return result
}
```
- a, b, return Int 는 stack 영역에 저장
- 지역상수 result 는 stack 영역에 저장

## 궁금한 점
- swift의 메모리 영역은 64bit 아키텍처에 따라 결정된다.
- String, Array, Dictionary는 기본 데이터 타입이지만 heap 영역에 할당된다.
   - 왜? 런타임때 데이터의 크기가 정해지지 않아서 동적영역인 heap에 저장되는 것!
- 메모리의 크기를 결정하는 요인은?
   - 운영체제인 CPU가 결정한다.
- 스택영역에 있는 메모리는 어떻게 해제될까?
   - 사용이 완료될때마다 하나씩 pop 되는 것이 아니라 앱이 종료될때 한번에 pop 된다.
   - 왜? 다시 사용될 수 도 있기 때문에 일을 여러번 하지 않게 하려고!
- 반복문이 저장되는 공간은?
   - 코드 영역에 저장되므로 사용이 종료되고 다시 반복이 가능하다.
 
---

# ARC

## Q : ARC는 무엇인가?

- swift에서 하나의 인스턴스를 참조하는 경우 자동적으로 reference count를 계산해주는 기능으로 클래스 타입에서만 적용된다.
- 클래스 인스턴스가 더이상 필요하지 않을때 메모리를 자동으로 해제한다.
- Heap 영역을 관리한다.
- 인스턴스를 생성하면 주소값은 스택에 할당되고 실제 인스턴스는 힙 영역에 할당된다.
```swift
class Person {
    var name: String?
    init(name: String) {
        self.name = name
    }
}

let riji = Person(name: "리지") // riji 는 스택에 할당되고 실제 Person이란 값은 힙 영역에 할당
let riji2 = riji // Person을 가르키고 있음
```

### RC 특징
- 필요에 따라 개체를 할당하고 해제할 수 있어 효율적으로 메모리 관리를 할 수 있다.
- `컴파일 타임`에 자동으로 retain, release (MRC에서 사용했던) 를 적절한 위치에 삽입하고 삽입된 코드는 `런타임`에 실행된다.
- 모든 인스턴스는 자신의 RC 값을 가지고 있다.
- RC가 증가하는 경우?
   - init()이 될때, 즉 새로운 인스턴스를 생성할때
   - 프로퍼티, 변수, 상수에 인스턴스를 할당할때
   - 메서드 내부의 지역변수, 상수에 할당할때

- ARC 메커니즘은 `Swift Runtime` 이라는 `library`에 구현되어 있다.
   - swift Runtime은 동적 할당되는 모든 object를 HeapObject라는 struct으로 표현
   - HeapObject에서는 swift에서 객체를 구성하는 모든 데이터 (RC, type metadata)를 포함
   - class에 대한 HeapObject를 통해 RC를 관리한다.

(HeapObject에 대한 공부가 필요하다!!!)

### RC 카운트 해보기
- 아래 블로그를 참고해서 연습하니 이해가 잘되는 것 같다!!
[소들이블로그](https://babbab2.tistory.com/26)

## Q : ARC 이전의 메모리 관리는 어땠을까?

- 과거 Obj-C 에서는 `MRC (Manula reference counting)` 방법으로 retain, relase, autorelease 등을 통해 수동으로 메모리 관리를 해왔다.
- 개발자가 직접 retain, release 의 위치를 잡아주던 것을 compile time 에 자동으로 retain, release 를 적절한 위치에 삽입해 주는것이다.

## Q : ARC를 이해해야 하는 이유는 무엇무엇이 있을까?

- 메모리 누수를 방지하기 위해!
[내가공부한강순참](https://github.com/yijiye/TIL-swift-/blob/main/Memory/ARC%20강한순환참조.md)

## Q : 언제 구조체를 선택하고 언제 클래스를 선택해야할까?

swift에서는 struct 사용을 권장하며 디폴트이다
그래서 클래스로 사용해야하는 경우가 아니라면 기본적으로 struct을 사용하는 것이 좋다. [공식문서](https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes)
- 인스턴스는 바뀌지 않고 내부 프로퍼티만을 변경할 상황이 있을 때
- 다른곳에서 동일인스턴스에 접근하고 싶을 경우 - (ex. 싱글톤)
- 상속이 필요한 경우

---

## 궁금한 점 
- 공식문서에서 클래스 타입에 대해 ARC를 적용한다고 했는데 그럼 같은 값 타입은 클로저는 어떻게 관리할까? 

### 클로저의 값 캡쳐
- 클로저는 값을 캡쳐할 때, Value/Reference 타입에 관계없이 Reference Capture를 한다.
```swift
func doSomething() {
    var message = "Hi"
 
    //클로저 범위 시작
    
    var num = 10
    let closure = { print(num) }
 
    //클로저 범위 끝
    
    print(message)
}
```
- 클로저는 외부 변수인 `num`을 변수로 사용(print)하여 num의 값을 클로저 내부로 저장 => `num의 값이 캡쳐`되었다고 표현함
- 이때 `message`라는 변수는 클로저 내부에서 사용되지 않았으므로 캡쳐되지 않았음

- `num`은 `Int` 타입의 `구조체` 형식이자 `value` 타입이므로 값을 복사해서 저장하는게 일반적인데, 클로저는 `Value/Reference 타입에 관계없이` 캡쳐하는 값들을 참조한다.

### 클로저의 캡쳐 리스트
`let closure = { [num, num2] in`
- 클로저의 시작 { 바로앞에 [] 키워드를 사용해서 캡쳐할 멤버를 나열한 후 in을 붙여주는 형식으로 사용할 수 있다.

### 클로저와 ARC
```swift
class Human {
    var name = ""
    lazy var getName: () -> String = {
        return self.name
    }
    
    init(name: String) {
        self.name = name
    }
 
    deinit {
        print("Human Deinit!")
    }
}
```
- `getName` 이란 클로저를 호출하면 Heap에 할당되며 이 클로저를 참조하게 된다.
- `self.name` 을 통해 Human 인스턴스의 프로퍼티에 접근하고 있는데 클로저가 값 캡쳐를 할때 기본적으로 strong 으로 캡쳐를 하므로 Human 이란 인스턴스의 RC를 증가시킨다.
- Human 인스턴스는 클로저를 참조하고, 클로저는 Human 인스턴스의 변수를 참조하고 있어 서로 강한순환 참조가 발생!

### 클로저의 강순참 해결법
- weak & unowned + capture lists 를 이용하여 해결할 수 있다.
- self에 대한 참조를 클로저 캡쳐 리스트를 통해 weak, unowned로 캡쳐하면 된다.
```swift
class Human {
    lazy var getName: () -> String? = { [weak self] in
        return self?.name
    }
}
```

### 클로저 결론
- ARC 공식문서에서 클래스 타입에 한정되어있다고 하여 클로저가 궁금해졌는데 내용이 너무 어려워서 추가 공부가 더 필요해 보인다 🥲
오늘은 간략하게 클로저도 ARC와 연관되어 있고 클로저의 경우는 값 캡처를 통해 RC가 증가하고 이를 해결하려면 클로저의 캡쳐리스트를 weak / unowned로 해주면 RC가 증가하지 않아 메모리 누수르 방지할 수 있다는 내용까지 알아본 것으로 만족한다,,
[참고블로그](https://babbab2.tistory.com/83)

----
## 참고
- https://sujinnaljin.medium.com/ios-arc-뿌시기-9b3e5dc23814
- https://babbab2.tistory.com/25
- https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
- https://babbab2.tistory.com/83
- https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes
