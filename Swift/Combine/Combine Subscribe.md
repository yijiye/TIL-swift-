## Subscribe 구독하기 (custom)
`Subscriber`는 어떻게 `Publisher`를 구독하고 값을 받을까?
`protocol Publisher`에 정의되어 있는 `subscribe` 함수를 이용해서!

<img src="https://hackmd.io/_uploads/HJq3KQXH3.png" width="400">

날진 블로그의 비유에 따르면,
유튭의 구독자가 subscriber, 헤어몬이 publisher, 내가 지금 원하는 것 헤어몬 구독 subscribe 가 되는 것!!

- 헤어몬 (Publisher)에게 subscriber를 요청 
Publisher.subscribe(subscriber) = 헤어몬.구독한다(내가)
- subscribe 구현부에서 `receive(subscriber:)` 라는 함수를 호출한다.

<img src="https://hackmd.io/_uploads/r1rc9QQrn.png" width="400">

- `receive(subscriber:)`를통해 `publisher`와 `subscriber`를 연결해준다.

custom으로 하는 방법에 대해 [날진 블로그](https://sujinnaljin.medium.com/combine-subscribe-1f09ce19477d)에 아주 자세히 나와있으니 추후 공부해보도록 하자...!
나는 우선 애플이 기본으로 제공하는 sink를 사용해서 해봐야겠다.

## Subscribe 구독하기 (sink & assign)
애플에서는 Subscriber를 상속받아서 구현하는 것을 권장하지 않고 제공하는 Sink, Assign등 기본 Subscriber를 사용하는 것을 권장한다!

### sink(receiveCompletion:receiveValue:)
클로저에서 새로운 값이나 종료 이벤트에 대해 처리한다.

```swift
example(of: "sink") {
  // 1. Publisher의 한 종류인 Just를 생성합니다.
  let just = Just("Hello world!")
  
  // 2. .sink를 통해 publisher에 대한 subscription을 작성합니다.
  _ = just
    .sink(
      receiveCompletion: {
        print("Received completion", $0)
      },
      receiveValue: {
        print("Received value", $0)
    })
}
```

sink는 subscriber가 같이 제공되고 연결되기 때문에 value나 completion의 새로운 값만 받아서 편리하게 처리할 수 있다.


### assign(to:on:)
새로운 값을 Keypath에 따라 주어진 인스턴스의 property에 할당한다.

```swift
example(of: "assign") {
  // 1. didSet을 통해 value 값이 바뀌면 새 값을 print합니다.
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }
  
  // 2. 위에서 만든 class의 instance를 선언합니다.
  let object = SomeObject()
  
  // 3. String 배열로 이뤄진 publisher를 생성합니다.
  let publisher = ["Hello", "world!"].publisher
  
  // 4. publisher를 구독하면서 새롭게 받은 값을 object의 value에 할당합니다.
  _ = publisher
    .assign(to: \.value, on: object)
}
```

assigndms Publisher로 부터 받은 값을 주어진 인스턴스의 프로퍼티에 할당할 수 있도록 한다.
주어진 값이 무조건 있어야 하기때문에, sink와 달리 pulbisher의 failure 타입이 never일때만 사용 가능하다!!

`.assign(to: \.value, on: object)` 에서 \. 의 의미가 바로 object의 프로퍼티를 특정하기 위해 사용하는 key-path 표현이다.
