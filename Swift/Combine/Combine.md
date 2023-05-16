# Combine
> Framework
> 이벤트 처리 operators를 결합하여 비동기적인 이벤트 처리를 customize할 수 있다.

## Overview
Combine 프레임워크는 시간에 따라 값을 처리하기 위한 선언적 Swift API를 제공한다.
이 값들은 여러 종류의 비동기 이벤트를 나타낼 수 있다. Combine은 값을 시간에 따라 변화할 수 있는 publisher를 선언하고, 이러한 값을 publisher로 부터 받아오는 subscriber를 선언한다.

- publisher 프로토콜은 시간에 따라 값을 전달할 수 있는 타입을 선언한다. publisher는 상위 publisher로 부터 받은 값을 처리하고 다시 게시하는 연산자를 가지고 있다.
- publisher chain 끝에 위치한 subscriber는 요소를 받을 때마다 작업을 수행한다. publisher는 subscriber가 명시적으로 요청할 때만 값을 발행한다. 이로인해 subscriber 코드는 연결된 publisher로부터 이벤트를 받는 속도를 제어할 수 있다.

Timer, NotificationCenter, URLSession과 같은 여러 Foundation 타입들은 publisher를 통해 기능을 제공한다. Combine 또한 key-value Observing을 준수하는 특정 프로퍼티에 대한 내장 publisher도 제공한다.

여러 publisher의 출력을 결합하고 상호작용을 조정할 수 있다. 예를들어, Textfield의 publisher로부터 업데이트를 위한 subscribe나 URL 요청을 수행할 수 있는 text를 사용하기 위한 subscribe를 할 수 있다. 그런 다음 다른 Publisher를 사용하여 응답을 처리하고 앱을 업데이트하는데 사용할 수 있다.

Combine을 채택함으로써 코드를 일기 쉽고 유지보수하기 쉽게 만들 수 있으며, 이벤트 처리코드를 중앙집중화하고 중첩된 클로저와 규칙 기반 콜백과 같은 문제가 있는 기술을 제거할 수 있다.

## Publisher 
> protocol
> 시간에 따라 일련의 값을 부칠 수 있는 타입을 선언하다.

### Overview

Publisher는 하나 이상의 subscriber 인스턴스에 요소를 전달한다. Subscriber의 input 및 Failure 연관 타입은 publisher에서 선언한 output 및 failure 타입과 일치해야한다. Publisher는 `receive(subscriber:)` 메서드를 구현하고 subscriber를 받아들일 수 있다. 그 후, publisher는 subscriber에 대해 다음 메서드를 호출할 수 있다.
- `receive(subscription:)`
구독 요청을 확인하고 subscription 인스턴스를 반환한다. subscriber는 이 구독을 사용하여 publisher로부터 요소를 요청하고 게시를 취소할 수 있다.
- `receive(_:)`
Publisher로부터 하나의 요소를 구독자에게 전달한다.
- `receive(completion:)`
구독이 정상적으로 종료되었거나 오류로 종료되었음을 subscriber에게 알린다.

모든 publisher는 하위 subscriber가 올바르게 동작하기 위해 이 계약을 준수해야한다.
Publisher에 대한 extension은 복잡한 이벤트 처리 chain을 만들기 위해 조합하는 다양한 연산자를 정의한다. 각 연산자는 Publisher protocol을 구현하는 타입을 반환한다. 이러한 타입 대부분은 Publishers 열거형에 확장으로 존재한다. 예를 들어, `map(_:)` 연산자는 `Publishers.Map`의 인스턴스를 반환한다.

> Tip
> Combine publisher는 Swift 표준 라이브러리의 AsyncSequence와 유사하지만 별도로 구분되는 역할을 한다.
> Publisher와 AsyncSequence는 모두 시간에 따라 요소를 생성한다. 그러나 Combine의 pull은 subscriber를 사용하여 publisher에 요소를 요청하는 반면, Swift AsyncSequence는 for-await-in 구문을 사용하여 AsyncSequence에서 발행된 요소를 반복한다.
> 두 API 모두 요소를 매핑하거나 필터링하는 등 시퀀스를 수정하기 위한 메서드를 제공하지만, Combine만이 `debounce(for:scheduler:options:)` 및 `throttle(for:scheduler:latest:)` 와 같은 시간 기반 작업 및 `merge(with:)` 및 `combineLatest(::)`와 같은 결합 작업을 제공한다.
> 이 두 접근 방식을 연결하기 위해 property values는 publisher의 요소를 AsyncSequence로 노출시켜 subscriber를 첨부하는 대신 for-await-in을 사용하여 요소를 반복할 수 있도록 한다.


### Creating Your Own Publishers

Combine 프레임워크에서 제공하는 여러 타입 중 하나를 사용하여 직접 publisher 프로토콜을 구현하는 대신, 다음과 같은 방법으로 자체 publisher를 만들 수 있다.

- `PassthroughSubject` 와 같은 subject의 구체적은 하위클래스를 사용하여 `send(_:)` 메서드를 호출하여 필요할 때 값을 발행한다.
- `CurrentValueSubject`를 사용하여 subject의 기본 값을 업데이트할 때마다 값을 발행한다.
- `@Published` 를 사용하여 사용자 정의 타입 중 하나의 프로퍼티에 추가한다. 이렇게 함으로써 해당 프로퍼티는 값이 변경될 때마다 이벤트를 발생시키는 Publisher를 획득한다.


## Subscriber
> Protocol
> publisher로 부터 input을 받을 수 있는 타입을 선언하는 프로토콜

Subscriber 인스턴스는 Publisher로부터 요소를 받고 관계의 변경을 나타내는 라이프사이클 이벤트도 받는다. 
publisher와 subscriber를 연결하려면 publisher의 `subscribe(:)` 메서드를 호출한다. 이 호출 후 publisher는 subscriber의 `receive(subscription:)`를 호출하고 이를 통해 subscriber는 subscription 인스턴스를 얻게된다. 이를 사용하여 publisher로 부터 요소를 요청하고 구독을 선택적으로 취소할 수 있다. subscriber가 초기 요구를 하면 publisher는 새로 발행된 요소를 전달하기 위해 `receive(:)`(비동기적으로 수행될 수 있음)를 호출한다. publisher가 발행을 중지하면, `Subscribers.Completion` 타입의 매개변수를 사용하여 `receive(completion:)`를 호출하여 발행이 정상적으로 완료되었는지 또는 오류로 완료되었는지를 나타낸다.
Combine은 다음과 같은 subscriber를 publisher 타입에 연산자로 제공한다.
- `sink(receiveCompletion:receiveValue:)` 는 completion 신호를 받거나 새로운요소를 받을 때마다 임의의 클로저를 실행한다.
- `assign(to:on:)`은 받은 각 값을 주어진 인스턴스의 키 경로로 식별된 프로퍼티에 할당한다.


## 참고
- [Combine 공식문서](https://developer.apple.com/documentation/combine)
- [Publisher 공식문서](https://developer.apple.com/documentation/combine/publisher)
- [Subscriber 공식문서](https://developer.apple.com/documentation/combine/subscriber)
