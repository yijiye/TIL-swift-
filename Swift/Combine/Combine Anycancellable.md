# AnyCancellable

> Class

> 취소 되었을 때, 제공된 클로저를 실행하는 type-erasing cancellable object 이다.

주로 `Combine`을 사용할 때, 구독하고 나서 스트림을 `AnyCancellable`에 담아주었다.
스트림을 구독하면 스트림으로부터 비동기적인 이벤트를 받을 수 있고, 이때 구독한 스트림을 취소할 수 있어야 하기 때문이다.

`store(in:)` 으로 담아주었는데, 이것은 말 그래도 Cancellable 인스턴스를 저장하는 메서드이다.

```swift
var cancellables = Set<AnyCancellable>()

let subject = PassthroughSubject<Int, Never>()
        
subject
.sink(receiveValue: { value in
   print(value)
})
.store(in: &cancellables)
```

이런식으로 사용할 수 있으며, `AnyCancellables`에 스트림을 담아주고 모든 구독을 한번에 취소할 수 있다.

이렇게 스트림을 담아주는 이유는 크게 2가지 있다.
- 스트림의 수명 관리 : 구독을 취소하기 전까지 스트림이 계속해서 이벤트를 발생시킬 수 있고 `AnyCancellables`를 통해 관리하면 메모리 누수 방지와 불필요한 리소스 사용을 줄일 수 있다.
- 비동기 작업의 완료 처리 : 비동기 작업이 완료되면 구독을 취소할 수 있다. 이로인해 비동기 작업을 제어할 수 있다.


ViewController가 메모리에서 해제되는 시점에서 AnyCancellables를 모두 비워주는 것으로 메모리 관리를 할 수있다.

```swift
 deinit {
        cancellables.forEach { $0.cancel() }
    }
```


## 참고
- [Apple Developer - AnyCancellable](https://developer.apple.com/documentation/combine/anycancellable)
- [Donnywals](https://www.donnywals.com/what-exactly-is-a-combine-anycancellable/)
