# String Subscript, Index

Swift 언어에서 String을 다루는게 까다롭고, 헷갈리는 경우가 많아 이번 기회에 딱 정리해보려고 한다!

## Overview
문자열은 컬렉션을 형성하는 "Swift"와 같은 일련의 문자이다. 스위프트의 문자열은 유니코드가 정확하고 로케일이 민감하지 않으며, 효율적으로 설계되었다. 문자열 유형은 Objective-C 클래스 `NSString`과 연결되어 있고 문자열과 함께 작동하는 C 함수와의 상호 운용성을 제공한다.


## String은 subscript로 접근할 수 없는 이유가 무엇일까?
**Subscripts 란** 컬렉션, 리스트, 시퀀스 등의 인스턴스를 Index로 접근할 수 있도록 해준다.
```swift
someArray[index]
someDictionary[index]
```
위와 같은 형식으로 인스턴스 접근이 가능하다.

**왜 String은 불가능할까?**
String은 `Unicode sclar`로 이루어진 `Character`의 배열인데 이 `Unicode Scalar`는 크기가 가변적이라 정수로 index를 구분하기 어렵다.
String내부의 문자들이 늘 같은 메모리로 저장되는 것이 아니기 때문에, 해당 문자의 위치에 접근하기 위해서는 각 `Unicode scalar`의 시작이나 끝부터 탐색을 해야한다.

- Unicode scalar란, 크기가 가변적인 String 문자열을 하나하나 개별적으로 접근하기 위한 방법으로 하나 이상의 Unicode Scalar가 모여 Character를 이루고, 그 Character가 모여 String을 이룬다.

예를들어, 'h'의 경우 UTF-8로 인코딩하면 길이가 1이지만 '홍'이란 문자는 3을 차지한다.

## String을 효율적으로 사용하려면?
Stirng에 대해 찾아보다 [Havi님 블로그](https://velog.io/@hansangjin96/Swift-String은-왜-subscriptInt로-접근이-안될까)에서 알고리즘을 풀 때, 어떤 식으로 사용하는 것이 효율적인지 알게 되었다.

String은 collection에서 O(1)으로 접근할 수 있는 `RandomAccessCollection` 프로토콜을 준수하지 않고, 앞 뒤의 원소만 참조할 수 있는 `BidirectionalCollection`을 준수한다. 그래서 시간 복잡도는 O(n)이 된다.
String.index는 +,- 연산을 지원하지 않기 때문에 index에서 n만큼 떨어진 글자를 참조하려면 O(n)의 시간 복잡도가 필요하다!

따라서 알고리즘을 풀때, Array(string)을 통해 명시적으로 [Character] 형태로 바꾸는게 좋다.

## String.index 메서드
- 문자열 첫 글자 구하기

```swift
let str = "abcdef"
str.startIndex // a
str.prefix(2) // ab 1,2번째 문자열 출력
```

- 문자열 n번째 글자 구하기

```swift
let str = "abcdef"
let first: String.index = str.startIndex
let second = str.index(after: first) // after 뒤에 오는 타입은 String.index 타입이 와야 한다.

str.index(after: first)
let test = str.index(first, offsetBy: 3)
print(str[test]) // d
```

- 마지막 문자 구하기

<img src="https://hackmd.io/_uploads/H1uAkVx_3.png" width="400">

**endIndex** 를 사용하면 되는데, 마지막 빈 공간을 가리키므로 런타임 에러를 발생하게 된다. 따라서 `index(before:)`를 사용하면 에러가 나지 않는다.

```swift
let str = "abcdef"
let last = str.endIndex
str[str.index(before: last)] // f

```

이렇게 하면 마지막 문자인 f가 출력되는 것을 확인할 수 있다.

- 끝에서 n번째 문자열 구하기

```swift
let str = "abcdef"
str.suffix(3) // def
```

- 특정 문자의 인덱스 구하기

```swift
let str = "aaaa"

let distance = str.distance(from: str.startIndex, to: str.firstIndex(of: "a")!)
print(distance) // 0

let lastDistance = str.distance(from: str.startIndex, to: str.lastIndex(of: "a")!)
print(lastDistance) // 3
```

firstIndex로 a가 나타나는 첫 번째 index 확인
lastIndex로 a가 나타나는 마지막 index 확인


## 참고 
- [Apple Developer - String](https://developer.apple.com/documentation/swift/string)
- [String.index jeong9216.tistory](https://jeong9216.tistory.com/556)
