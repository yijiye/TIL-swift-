# Dictionary
> ```[key: value]```키값과 value 값이 쌍을 이룬 형태

- 순서가 정해져 있지 않다.
- Foundation의 NSDictionary class 와 연관
- 딕셔너리의 key 값은 Hashable 프로토콜을 준수한다.

### 빈 딕셔너리 생성하기

```swfit
var someDictionary: [Int: String] = [:]
```

### 딕셔너리 배열 생성하기
```[key 1: value 1, key 2: value 2, key 3: value 3]```
- 여러개의 값을 넣을때는 , (콤마) 로 구분지어 입력할 수 있다.

```swift
var soccerPlayerNumber: [String: Int] = ["손흥민": 7, "메시": 10]
```
- 딕셔너리 배열을 생성할때 추가로 생성될 여지가 있다면 var로 선언하고, 그렇지 않은 경우 let 으로 선언

```swift=
var soccerPlayerNumber = ["손흥민": 7, "메시": 10]
```
- 타입 명시를 해주지 않아도 [String: Int] 임을 추론할 수 있다.

### 딕셔너리 접근과 수정방법

#### count
>딕셔너리에 들어있는 아이템의 수를 확인할 때 사용

```swift=
var soccerPlayerNumber: [String: Int] = ["손흥민": 7, "메시": 10]

print("\(soccerPlayerNumber.count)개가 딕셔너리에 있습니다.") // 2개가 딕셔너리에 있습니다. 출력
```

#### isEmpty
>딕셔너리에 값이 없는지 확인할 때 사용

```swift
var soccerPlayerNumber: [String: Int] = ["손흥민": 7, "메시": 10]

if soccerPlayerNumber.isEmpty {
    print("딕셔너리에 값이 없습니다.")
} else {
    print("딕셔너리에 값이 있습니다.")
} // 딕셔너리에 값이 있습니다. 출력 
```
#### 딕셔너리에 값 추가하기
```swift=
soccerPlayerNumber["김민재"] = 3
print(soccerPlayerNumber)
// ["메시": 10, "김민재": 3, "손흥민": 7] 출력
```

- 새로 입력할 key값과 value값을 위와 같은 방법으로 추가할 수 있다.
- 딕셔너리는 순서가 없기 때문에 출력은 순서대로 출력되지 않는다.

#### 딕셔너리 값 변경하기 

**subscript syntax**
```swift
soccerPlayerNumber["손흥민"] = 10
print(soccerPlayerNumber["손흥민"])
// Optional(10) 출력
```
- 원래 있던 key 값의 value값을 변경해주려면 위와 같이 변경해줄 수 있다.
- 딕셔너리는 옵셔널 값으로 출력된다.

**updateValue**
- ```updateValue(_:forKey:)```를 사용하면 값이 없는 경우에는 새로운 값이 입력되고, 기존에 값이 있던 경우 값이 업데이트가 된다.
- 또한 값이 업데이트 되고 나면 예전 값을 반환하여 업데이트가 되었는지 확인할 수 있다.

```swift
if let oldValue = soccerPlayerNumber.updateValue(10, forKey: "손흥민"){
    print("손흥민의 예전 등번호는 \(oldValue) 입니다.")
}
// 손흥민의 예전 등번호는 7 입니다. 출력

if let oldValue = soccerPlayerNumber.updateValue(10, forKey: "손흥민") {
    if let newValue = soccerPlayerNumber["손흥민"] {
        print("손흥민의 예전 등번호는 \(oldValue) 이고 새로운 등번호는 \(newValue)입니다.")
    }
}
// 손흥민의 예전 등번호는 7 이고 새로운 등번호는 10입니다. 출력
```

- oldValue인 7을 확인할 수 있다.
- 옵셔널바인딩으로 newValue 10 

**nil 값으로 변환**
```swift
soccerPlayerNumber["손흥민"] = nil
if let number = soccerPlayerNumber["손흥민"] {
    print("\(number)")
} else {
    print("등번호가 없습니다.")
} // 등번호가 없습니다. 출력
```
- subscript syntax를 이용하여 값을 nil로 바꾸고 옵셔널바인딩을 해주면 값이 없으므로 등번호가 없습니다로 출력된다.

#### 딕셔너리 값 제거하기

- ```removeValue(forKey:)``` 키워드 사용
- 값이 만약 존재한다면 지워진 값을 반환하고 값이 원래 존재하지 않는다면 nil을 반환한다.

```swift
soccerPlayerNumber["손흥민"] = nil
if let removedValue = soccerPlayerNumber.removeValue(forKey: "손흥민") {
    print("손흥민의 지워진 등번호는 \(removedValue) 입니다.")
}else {
    print("등번호가 없습니다.")
} // 값이 원래 없는 경우, 등번호가 없습니다. 출력
```

```swift=
//soccerPlayerNumber["손흥민"] = nil
if let removedValue = soccerPlayerNumber.removeValue(forKey: "손흥민") {
    print("손흥민의 지워진 등번호는 \(removedValue) 입니다.")
}else {
    print("등번호가 없습니다.")
} // 값이 있는경우, 지워진 등번호는 7 입니다. 출력
```

#### 딕셔너리 반복문
- 딕셔너리의 key와 value를 튜플 형식으로 for _ in 구문으로 돌릴 수 있다.
- 또한 key, value 를 일시적으로 상수도 변수로 분해할 수 있다.

```swift=
for (player, number) in soccerPlayerNumber {
    print("\(player) 등번호는 \(number)")
}
/*
김민재 등번호는 3
손흥민 등번호는 7
메시 등번호는 10 출력 
*/
```

- 딕셔너리 key, value 접근하기
- soccerPlayerNumber.keys 키워드를 사용해서 key 값만 for_in 구문으로 돌려서 선수이름만 출력되도록 접근 할 수 있다.
```swift=
for player in soccerPlayerNumber.keys {
    print("선수명단: \(player)")
}
/*
선수명단: 손흥민
선수명단: 메시
선수명단: 김민재 출력
*/
```

- 딕셔너리의 key 값만 따로 배열로 만들고 싶다면 아래와 같이 할 수 있다.
```swift
let players = [String](soccerPlayerNumber.keys)
print(players)
// ["손흥민", "메시", "김민재"] 출력 
```

- 딕셔너리의 value 값만 따로 배열을 만들 수도 있다.
```swift
let playerNumber = [Int](soccerPlayerNumber.values)
print(playerNumber)
// [7, 3, 10] 출력
```
- 딕셔너리는 순서가 없지만 순서대로 출력하고 싶다면 ```sorted()```를 사용하면 된다.
```swift
let playerNumber = [Int](soccerPlayerNumber.values)
print(playerNumber.sorted())
// [3, 7, 10] 출력
```
---

# Hasable protocol?
- 자세히 이해하기 어렵지만, 한줄로 설명해보자면 딕셔너리에서 key와 value 값은 어떤 값을 해시 할건지에 대한 타입 설명이 명확해야 한다는 의미 같다!
- 딕셔너리와 set 은 Hasable protocol 을 준수해야한다.

```swift
struct Human {
    let name: String
    let age: Int
}
 
let myDict: [Human: Int]  // 오류발생!!
```

에러가 발생! 왜냐면 Human 이란 구조체에 name 과 age 가 기본타입이지만 어떤 것을 써야할지 정확히 모르기 때문에

- 기본형을 구현한다면 (Int, String, Double 같은) 자동으로 hasable protocol 이 채택된다

## 📚 참고
[딕셔너리 공식문서](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html)
[hasable protocol 블로그](https://babbab2.tistory.com/149)
