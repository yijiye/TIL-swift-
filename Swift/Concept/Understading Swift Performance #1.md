# Understanding Swift Performance

swift의 추상화 매커니즘 성능 영향을 이해하는 가장 좋은 방법은 기본 구현을 이해하는 것이다.

## 추상화 매커니즘을 선택할 때, 고려해야하는 요소 3가지

<img src="https://i.imgur.com/lhpiR9Y.png" width="400">
<br/>
</br>

- 인스턴스가 스택에 할당되는지, 힙에 할당되는지
- 참조 카운팅이 얼만큼 발생하는지
- 정적 dispatch 인지, 동적 dispatch 인지

이런 요소들을 고려하여 효율적은 코드를 작성하면 활용하지 않는 runtime, dynamism 비용을 지불하지 않아도 된다.

### Allocation
swift는 사용자를 대신하여 자동으로 메모리 할당 및 할당 해제한다.
- Stack의 구조
  - 끝으로 push하고 끝에서 pop한다.
  - 끝에서만 추가하고 제거할 수 있어 스택 끝에 포인터를 유지하여 스택을 구현하거나 푸시 및 팝을 구현할 수 있다.
  - 함수를 호출할 때, 공간을 만들기 위해 스택포인터를 약간 감소시키는 것만으로 메모리 할당 가능
  - 함수실행이 끝나면 스택 포인터를 함수 호출하기 전의 위치로 다시 증가시켜 메모리 할당해제
  - 스택 할당은 속도가 빠르다.

- Heap의 구조
   - 동적 lifetime으로 메모리를 할당 (스택은 불가능)
   - 힙에 메모리를 할당하려면 적절한 크기의 사용되지 않는 공간을 찾아야 한다.
   - 작업이 끝난 뒤 할당해제하려면 해당 메모리를 적절한 위치에 다시 삽입해야한다.
   - 여러 스레드가 동시에 힙에 메모리를 할당할 수 있음 => 이것을 관리하는데 많은 비용이 든다. (스택은 스레드별로 구성되므로 신경쓰지 않아도 된다
   
<img src="https://i.imgur.com/fRWscrY.png" width="400">
<br/>
</br>

struct은 stack영역에 있고, `point1` 과 `point2`는 값을 복사하였으므로 서로 독립적인 인스턴스이다.
그래서 위처럼 `point2.x`에 5라는 값을 할당하면 `point2.x`의 값만 바뀌고 `point1.x`의 값은 변하지 않는다.
이것을 `value sementic` 이라고 한다.

<img src="https://i.imgur.com/WI5juf0.png" width="400">
<br/>
</br>

class의 경우 heap 영역만 사용하는 것은 절대 아니다. stack 영역에는 주소값이 올라와 있고, heap 영역에 실제값이 올라와 있다.

`point1`의 인스턴스를 생성할 때, swift는 `heap`을 `lock` 하고 해당 자료구조에서 적절한 크기의 사용되지 않은 메모리 블록을 검색한다.
그런 다음 x:0, y:0 인 메모리를 초기화하고 힙의 해당 메모리에 대한 메모리 주소로 `point1` 참조를 초기화한다.

<img src="https://i.imgur.com/YhZNnwH.png" width="400">
<br/>
</br>

`point2`에 `point1`을 할당할 때, struct과 다르게 참조를 복사한다.
따라서` point1`과 `point2`는 실제 힙에 있는 동일한 `point` 인스턴스를 참조한다.
즉, `point2.x`에 5라는 값을 할당하면, `point1.x`, `point2.x`의 값이 모두 5가 된다. 이것을 `Reference sementic`이라고 한다.

<img src="https://i.imgur.com/uaLAhyz.png" width="400">
<br/>
</br>

`point1`, `point2`를 사용하면 힙을 lock한 뒤 사용하지 않는 블록을 적절한 위치로 돌려놓으면서 메모리 할당을 해제한다.
그런 다음 stack에 있는 주소값을 pop한다.

<img src="https://i.imgur.com/2ZtbUlH.png" width="400">
<br/>
</br>

class를 사용하면 struct보다 많은 비용이 든다. 추상화에 class의 특성이 필요하지 않는 한 struct을 사용하는 것이 좋다.

#### 실제 코드에서 개선해보기 

<img src="https://i.imgur.com/pNeWdyA.png" width="400">
<br/>
</br>

- String은 값 타입이지만, 실제로 힙에 간접적으로 해당 문자의 내용을 저장한다. 일정 크기를 넘어서면 힙 영역에 올려놓고 주소값을 스택에 저장해서 사용한다.
그러나 매직리터럴처럼 사용하면(코드에 박아버리면) 힙 영역을 사용하지는 않는다.
따라서 makeBalloon 함수를 호출할 때마다 힙 할당이 발생한다.

<img src="https://i.imgur.com/ZKOtIsE.png" width="400">
<br/>
</br>

`Attribute`라는 구조체를 만들어 string을 대체. 구조체는 swift 일급 클래스이므로 dictionary에서 키로 사용할 수 있다.
- `Hashable`준수 필요

### Reference Counting
Swift는 힙의 모든 인스턴스에 대한 RC를 유지한다. RC가 0이 되면 해당 메모리를 해제하는 것이 안전하다.

<img src="https://i.imgur.com/anHDBrd.png" width="400">
<br/>
</br>

`point1 `인스턴스를 생성하면서 `RC=1` 증가
`point2` 인스턴스도 마찬가지로 `RC=1`을 증가시켜 총 `RC=2`가 됨.
`point1` 사용이 끝나면 `RC=1`감소.
`point2` 사용이 끝나면 `RC=1`감소하여 총 `RC=0`이 되므로 안전하게 메모리 할당해제

반면, 구조체의 경우 heap영역을 사용하지 않으므로 RC와 관련이 없다.

그러나, 구조체 안의 프로퍼티로 class나 heap영역을 사용하는 것이 있다면?

<img src="https://i.imgur.com/2x0BASS.png" width="400">
<br/>
</br>
- `string` 타입인 `text`, `UIFont class`인 `font`는 RC가 필요하다.

<img src="https://i.imgur.com/rzQBD1a.png" width="400">
<br/>
</br>

`label1` 인스턴스를 초기화하면 `text`, `font`가 힙영역을 가르키며 RC가 증가한다.
마찬가지로 `label2`인스턴스를 생성하면서 RC가 증가한다.

<img src="https://i.imgur.com/y7yJv8v.png" width="400">
<br/>
</br>
<img src="https://i.imgur.com/MfxHKpD.png" width="400">
<br/>
</br>
<img src="https://i.imgur.com/blXmcKb.png" width="400">
<br/>
</br>

결론적으로, RC를 고려해야하는 class보다 struct을 사용하는 것이 좋지만, struct안에 참조가 포함되어 있는 경우 (참조가 두개 이상인 경우) 클래스보다 RC 오버헤드가 더 많이 들게 되는 문제가 있다. 이럴경우는 class를 사용하는 것이 적절하다.

#### 실제 코드에서 개선해보기 
**수정 전**
<img src="https://i.imgur.com/8U40sPQ.png" width="400">

- uuid: String -> uuid: UUID
- mimeType: String -> enum MimeType

**수정 후**
<img src="https://i.imgur.com/zPSNUkh.png" width="400">

### Method Dispatch
런타임에 메서드를 호출할 때 swift는 올바른 implementation을 실행해야 한다.

#### Static Dispatch
컴파일 타임에 실행할 implementation을 결정할 수 있는 경우를 정적 디스패치하고 한다.
 - 런타임에 올바른 implementation으로 바로 이동할 수 있다.

#### Dynamic Dispatch
어떤 implementation로 이동할지 직접 컴파일 시간에 결정할 수 없다.
런타임에 실제 구현을 찾은 다음 바로 실행한다.
동적 디스패치 자체는 정적 디스패치보다 비용이 많이 들지는 않고, 참조 카운팅 및 힙 할당과 같은 스레드 동기화 오버헤드는 없다.
 - 컴파일러는 정적 디스패치에 대해 인라이닝, 최적화를 수행할 수 있지만 동적 디스패치는 컴파일러의 가시성을 차단하므로 최적화 할 수 없다.


#### 다형성과 연관
<img src="https://i.imgur.com/fRAAqJI.png" width="400">

- `Drawable` super class를 상속받고 있는 여러 class가 존재.

<img src="https://i.imgur.com/CEVyRdR.png" width="400">

- `Point`, `Line`이 모두 클래스이기 때문에 이러한 것들의 배열을 만들 수 있고 배열에 참조로 저장하기 때문에 크기가 모두 동일하다.
- 그리고 각각에 대해 draw를 호출할 것이다.
- d.draw는 `Point`가 될수도 있고, `Line`이 될수도 있는 문제가 생긴다.
- 복잡한 과정을 통해 어떤 draw가 불릴지 결정하는 것 대신 `final` 키워드를 사용하여 성능 최적화를 할 수 있다.


---
## 참고
- [WWDC](https://developer.apple.com/videos/play/wwdc2016/416/)
- [velog.io/@ictechgy](https://velog.io/@ictechgy/UnderstandingSwiftPerformance#understanding-swift-performance)



