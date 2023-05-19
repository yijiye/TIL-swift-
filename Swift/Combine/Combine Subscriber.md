## Subscriber
> `Publisher`에서 나오는 요소의 흐름을 받는다.

`Publisher`에 Output, Failure가 있듯이, `Subscriber`에는 Input, Failure가 있다.
위에서 언급했듯이 둘이 서로 일치해야한다.


### Protocol

#### receive(subscription:)
`Subscriber`와 `Publisher`를 연결하기 위해 `subscribe(:)` 함수를 부르고 난 뒤에 `Publisher`를 호출하는 함수
`subscriber`에게 `subscription`인스턴스를 전달한다.

<img src="https://hackmd.io/_uploads/Bk1CUmQSh.png" width="400">

`subscription`은 `subscriber`와 `Publisher`를 연결한다.
더이상 구독하지 않겠다고 선언할 수도 있다.
`subscrition.cancel()`
만약 취소를 하지 않으면 `publisher`가 완료될때까지 또는 일반적인 메모리 관리로 인해 저장된 `subscription`이 초기화 되지 않을때까지 계속 유지된다.

#### receive(_:)
`subscriber`의 첫 번째 요청이 끝나면, `publisher`가 새롭게 발행된 `element`들을  `subscriber`에게 전달하기 위해 호출하는 함수

첫 번째 요청은 `subscriber`가 Subscription protocol에 정의된 `request(_:)`를 호출하는 행위를 뜻한다.

#### receive(completion:)
`subscriber`에게 이벤트 방출(publishing)이 정상적으로 끝났는지 또는 에러로 인해 끝났음을 알려줄때 호출되는 함수

### Subscriber 구현
Combine은 `Publisher` 타입의 `operator`를 통해 아래와 같은 `subscriber`를 제공한다.

- `sink(receiveCompletion:receiveValue:)`: 종료 시그널을 받거나 매번 새로운 요소를 받았을 때 임의적인 클로저를 실행
- `assign(to:on:)`: 매번 새로 받는 값을 주어진 인스턴스의 key path로 정의되는 프로퍼티에 할당한다.

