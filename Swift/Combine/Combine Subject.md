## Subject
> PassthroughSubject, CurrentValueSubject 

Subject는 Publisher의 일종이다. 즉, publisher 프로토콜을 따른다.
차이점은 밖에서 값을 방출할 수 있다!

<img src="https://hackmd.io/_uploads/BkWfaQQH3.png" width="400">

send를 사용해서 외부에서 스트림에 값을 주입할 수 있다.

### PassthroughSubject
> Downstream subscriber에게 element를 broadcast하는 subject

```swift
example(of: "PassthroughSubject") {
// 1. String과 Never 타입의 PassthroughSubject 객체를 생성합니다.
let subject = PassthroughSubject<String, Never>()

// 2.sink 를 이용하여 subscription1을 생성합니다.
let subscription1 = subject
    .sink(
        receiveCompletion: { completion in
              print("Received completion (1)", completion)
        },
        receiveValue: { value in
              print("Received value (1)", value)
        }
      )
// 3.sink 를 이용하여 subscription2을 생성합니다.
let subscription2 = subject
    .sink(
        receiveCompletion: { completion in
              print("Received completion (2)", completion)
        },
        receiveValue: { value in
              print("Received value (2)", value)
        }
      )
//4. 값을 보냅니다.
subject.send("Hello")
subject.send("World")
}
```

subject에 값을 보내면 이를 구독하고 있는 subscription1, 2 가 모두 값을 받게된다.
```
——— Example of: PassthroughSubject ———
Received value (1) Hello
Received value (2) Hello
Received value (1) World
Received value (2) World
```

그리고 나서 1의 구독을 취소하면
```swift
// 5. subscription1의 구독을 취소합니다.
subscription1.cancel()
// 6. 또 다른 값을 전송합니다.
subject.send("Still there?")
```

1의 값이 사라지고 새로 추가된 
```
Received value (2) Still there?
```
가 찍히게 된다. 여기까지 이해가 잘 됨!!

```swift
//7. finished라는 완료 이벤트를 보냅니다
subject.send(completion: .finished)
//8. 또 다른 값을 전송합니다.
subject.send("How about another one?")
```

완료 이벤트 보내면 완료 이벤트만 찍히고 How about 이거는 안찍힘 왜냐면 완료 이벤트를 받은 후에 더이상 다른 완료이벤트나 값을 받지 않기 때문이다!! 오키오키

### CurrentValueSubject
> 초기값과 최근 발행된 element에 대한 buffer를 갖는다.

```swift
var subscriptions = Set<AnyCancellable>()
example(of: "CurrentValueSubject") {
    // 1. Int와 Never 타입을 갖는 CurrentValueSubject를 생성합니다. 
  // 1-1. CurrentValueSubject는 반드시 초기값이 있어야합니다. 여기서는 0입니다.
    let subject = CurrentValueSubject<Int, Never>(0)
      
      // 2. sink를 통해 subject를 구독합니다. Failure Type이 Never일때 receiveCompletion은 생략 가능합니다.
      subject
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions) // 3. subcription을 subscriptions 묶음에 저장합니다.
}
```
0이란 초기값과 함께 생성

- store 짚고가기 : in 안에 들어가는 parameter 타입은 `Set<AnyCancellable>` 으로 이곳에 여fjsubscription을 저장할 수 있으며 저장된 subscription들은 해당 set이 초기화 해체(deinitialized)될 때 같이 자동으로 취소되어 메모리 관리에 용이하다.
    
```swift
subject.send(1)
subject.send(2)
```
send를 통해 새로운 값을 발행할 수 있다.

```
——— Example of: CurrentValueSubject ———
0 //초기 값
1 //subject.send(1)로 받은 값
2 //subject.send(2)로 받은 값
2 //print(subject.value)로 확인한 현재 값
```

여기서는 subject.value = .finished 와 같은 완료이벤트를 주입할 수 없다. 단지 값만 주입 가능하다! 만약 완료 이벤트를 발핸하고 싶으면 PassthroughSubject와 같은 방법을 사용하면 된다.
