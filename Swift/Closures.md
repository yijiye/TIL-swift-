# Closure 클로저

## 특징
클로저는 어떤 상수나 변수의 참조를 캡쳐해 저장할 수 있다.
클로저는 3가지 형태로 나타난다.
 - 전역 함수 : 이름이 있고 어떤 값도 캡쳐하지 않는 클로저
 - 중첩 함수 : 이름이 있고 관련한 함수로 부터 값을 캡쳐 할 수 있는 클로저
 - 클로저 표현 : 값을 캡쳐할 수 있는 이름이 없는 클로저 

## 주 사용 목적
- 고차 함수
- completion block : 비동기 작업에 많이 사용되어 값 캡쳐 기능이 필요!

## 클로저 표현

### 정렬 메소드 (sorted method)
```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
```
```swift
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
```
- `(string, string) -> Bool` 의 클로저를 활용하여 일반적인 방법으로 함수를 만든 예시

### 클로저 표현 문법
```swift
{ (parameters) -> return type in
    statements
}
```
- parameter에 인자를 넣을 수 있고, 인자 값으로 처리할 내용을 statements, return type은 type에 넣어주면 된다.

#### 인라인 클로저
```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in                         
    return s1 > s2
})

// 단일 표현 클로저에서 반환 키워드 생략 
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

// 인자 이름 축약
reversedNames = names.sorted(by: { $0 > $1 } )

// 연산자 축약
reversedNames = names.sorted(by: >)
```

#### 후행 클로저 
```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// 반환 타입 생략
someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// 후행클로저로 표현
someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}

// 예시
reversedNames = names.sorted() { $0 > $1 }

// 마지막 인자이 클로저이고 후행 클로저를 사용하면 괄호() 생략 가능
reversedNames = names.sorted { $0 > $1 }
```

## 값 캡쳐
- 클로저는 상수나 변수의 값을 캡쳐하여 원본 값이 사라져도 클로저의 body 안에서 그 값을 활용할 수 있다.
```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```
- `func incrementer()` 안에 runningTotal, amount가 캡쳐링 되어 사용 가능해진다.
- swift에서 기본적으로 클로저에 의해 값이 사용되지 않으면 그 값을 저장하지 않는다. 즉 메모리 관리를 알아서 처리한다.

#### 예시
```swift
func doSomething() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = {
        print("num check #3 = \(num)")
    }
    
    num = 20
    print("num check #2 = \(num)")
    closure()
}
```
```bash=
num check #1 = 0
num check #2 = 20
num check #3 = 20
```
- closure를 실행하기 전 num 값을 외부에서 변경하면 클로저 내부의 num 값도 캡쳐에 의해 변하게 됨.

```swift
func doSomething() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = {
        num = 20
        print("num check #3 = \(num)")
    }
    
    closure()
    print("num check #2 = \(num)")
}
```
```bash=
num check #1 = 0
num check #3 = 20
num check #2 = 20
```
- closure 외부에 있는 num 값도 변경됨
- 이때 클로저는 참조 타입으로 closure의 값 타입이 참조이든 값 타입이든 상관없이 `Reference Capture`를 한다.

### 캡쳐 리스트
- Value Type으로 capture 하기 위해 사용
- 만약 클로저를 어떤 클래스 인스턴스의 프로퍼티로 할당하고 그 클로저가 그 인스턴스를 캡쳐링하면 강한 순환참조에 빠지게 된다.
강순참을 해결하기 위해 사용

```swift=
let closure = { [num, num2] in //}
```
- { 바로 옆에 [] 안에 캡쳐할 멤버를 나열한 후 in 키워드를 사용한다.

#### value 타입을 복사해서 캡쳐하는 방법 
```swift
func doSomething() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = { [num] in
        print("num check #3 = \(num)")
    }
    
    num = 20
    print("num check #2 = \(num)")
    closure()
}
```
```bash
num check #1 = 0
num check #2 = 20
num check #3 = 0
```

- 캡쳐리스트에 num을 넣어주면 값 타입으로 캡쳐되어 클로저 안에서 20이란 숫자가 아닌 0의 값을 캡쳐해서 사용한다.
- 이때, `value type으로 캡쳐한 경우`, 클로저 선언시 num을 `상수`로 캡쳐해서 값을 변경할 수 없다.
- **Reference type은 캡쳐리스트로 캡쳐해도 value type이 될 수 없음!!**

#### Reference type의 캡쳐 리스트 (강한순한참조 해결)
- 이는 강한 순한참조를 해결하기 위한 방법으로 사용된다.
- `weak`, `unowned` 키워드를 사용할 수 있다.

```swift
class Human {
    lazy var getName: () -> String? = { [weak self] in
        return self?.name
    }
}

class Human {
    lazy var getName: () -> String = { [unowned self] in
        return self.name
    }
}
```
- unowned 를 사용하는 경우는 메모리에서 해제되는 시점 즉, 생명주기가 더 짧은 경우에 사용하면 된다.
[내가 정리한 강순참](https://github.com/yijiye/TIL-swift-/blob/main/Memory/ARC%20강한순환참조.md) 에서 가져온 내용!

**unowned** 
- weak 참조와 달리 <span style='background-color:#fff5b1'>인스턴스의 수명이 같거나 더 길 경우에 사용한다.</span>

- 사용하면 안되는 예시
![](https://i.imgur.com/uyUy0rx.png)

- 이미 거주자에 들어있는 값은 메모리가 해제되어 존재하지 않는다.
- 해제된 메모리 영역을 가리키고 있는 것을 ```daling pointer```라고 한다.
- 그래서 ```uni4A.거주자``` 는 접근할 수 없게 된다.
- 이러한 경우 크래시가 발생할 수 있고 반드시 수명이 같거나 더 길 경우만 사용하도록 한다!
- 수명이 더 짧은 쪽에 선언해주면 된다.

### @escaping closure
- 클로저를 함수의 파라미터를 넣을 수 있는데, 함수가 끝나고 실행되는 클로저 (비동기로 실행되거나 completionHandler로 사용되는 클로저) 앞에는 `@escaping` 키워드를 명시해야 한다.

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```
- `completionHanlder`는 `someFunctionWithEscapingClosure` 함수 실행이 끝나고 나중에 처리된다.
- 또한`@escaping` 클로저에는 `self`를 명시적으로 언급해야 한다.

---

## 참고
[공식문서-Closures](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Capturing-Values)
[공식문서-한글버전](https://jusung.gitbook.io/the-swift-language-guide/language-guide/07-closures)
[소들이-블로그](https://babbab2.tistory.com/83)

