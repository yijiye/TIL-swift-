# Singleton
> 특정 클래스에 대한 인스턴스를 전역에 한번만 생성하고 그 인스턴스를 여러곳에서 공용으로 사용할수 있게 해주는 디자인 유형.

![](https://i.imgur.com/tmchUWc.png)


## 정의
```swift
class Person {
    static let shared = Person() // 전역으로 인스턴스를 저장할 프로퍼티를 선언
    
    var name: String?
    var age: Int?
    var nickName: String?
    private init() { } // init메서드를 호출하여 새로운 인스턴스 생성을 막기위해 private으로 접근을 막아준다.
}
```

## 참고
[Singleton 공식문서](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Singleton.html)
[Singleton 공식문서](https://developer.apple.com/documentation/swift/managing-a-shared-resource-using-a-singleton)
[Singleton 개발자소들이 블로그](https://babbab2.tistory.com/66)
