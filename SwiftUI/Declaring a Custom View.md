# Decalring a custom view 
> view 계층안에서 뷰를 조립하고 정의하기

## Overview
SwiftUI는 유저 인터페이스 디자인에 선언적 접근을 제공한다.
기존의 방법대로 유저 인터페이스를 구현한다면 뷰를 인스턴스화 하고 레이아웃을 잡고 변화가 생길때 마다 업데이트를 해줘야 한다.
그러나, 선언적 접근을 한다면 간결하게 UI를 구현할 수 있다. SwiftUI는 상태 변화나 유저 입력과 같은 이벤트에 대한 응답으로 뷰를 그리고 관리한다.


<img src="https://hackmd.io/_uploads/ryl4PMQOn.png" width="400">

SwiftUI는 유저 인터페이스에서 뷰를 정의하고 구성하는 도구를 제공한다. SwiftUI가 제공하는 내장 뷰와 이미 정의한 다른 복합 뷰로 사용자 지정 뷰를 구성한다. 뷰 modifier로 이러한 뷰를 구성하고 데이터 모델에 연결한다. 그런 다음 앱의 보기 계층 구조 내에 사용자 지정 보기를 배치한다.

## view protocol 준수하기
`View protocol`을 준수하여 커스텀 뷰를 정의할 수 있다.

```swift
struct MyView: View {
}
```

다른 swift protocol과 같이 `View protocol`은 기능적으로 청사진을 제공한다.

## body 선언하기
`View protocol`의 주요 요구사항은 `body` 지정 프로퍼티를 정의해야하는 것이다.

```swift
struct MyView: View {
    var body: some View {
    }
}
```

SwiftUI는 뷰를 업데이트가 필요할때 항상 이 프로퍼티의 값을 읽는다. 일반적으로 사용자 입력 또는 시스템 이벤트에 대한 응답으로 뷰가 있는 동안 반복적으로 발생할 수 있다. 뷰가 반환하는 값은 SwiftUI가 화면에 그리는 요소를 의미한다.

`View protocol`의 두 번째 요구 사항은 준수 유형이 본문 속성에 대한 관련 유형을 나타내야 한다는 것입니다. 하지만, 명시적인 선언을 하는대신, 본문의 유형이 View와 일치한다는 것만 나타내기 위해 일부 View 구문을 사용하여 본문 속성을 `opaque type`으로 선언한다. 정확한 유형은 `body`의 내용에 따라 다르며, 이는 개발 중에 `body`를 편집함에 따라 다르다. swift는 정확한 유형을 자동으로 추론한다.

## view content 조립하기

```swift
struct MyView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
```

Hello, World! 를 출력하려면 위와 같은 예시로 출력할 수 있다. 만약 그 아래 새로운 Text를 입력하고 싶다면, 

```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("Glad to meet you.")
        }
    }
}
```

이렇게 추가할 수 있고, 이는 `VStack`이기 때문에 위아래로 표현된다.

## modifier와 함께 view 구성하기
View안에 있는 text의 font나 다른 속성을 변경하려면 아래와 같이 표현할 수 있다.

```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.title)
            Text("Glad to meet you.")
        }
    }
}
```

## data 관리하기
view에 입력을 제공하려면 프로퍼티를 추가하면 된다.

```swift
struct MyView: View {
    let helloFont: Font
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(helloFont)
            Text("Glad to meet you.")
        }
    }
}
```
만약 입력 값이 바뀐다면, SwiftUI는 변화를 알리고 인터페이스에서 영향을 받은 부분만 새로 그린다. 이것을 SwiftUI가 알아서 관리해준다.

## view 계층에 view 추가하기
view를 정의한 후에 내장 view와 마찬가지로 다른 뷰에 통합할 수 있다. 그 view가 나타나기를 원하는 계층 구조의 지점에서 선언하여 추가할 수 있다. 예를 들어, Xcode가 새 앱의 루트 보기로 자동으로 생성하는 앱의 ContentView에 MyView를 넣을 수 있습니다.

```swift
struct ContentView: View {
    var body: some View {
        MyView(helloFont: .title)
    }
}
```

## 참고
- [Apple Developer - Declaring a custom view](https://developer.apple.com/documentation/swiftui/declaring-a-custom-view)
