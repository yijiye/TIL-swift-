
## 재귀함수와 반복문의 차이?

#### 재귀함수의 특징
- 코드길이가 짧다
- 가독성이 좋다
- 메모리가 스택에만 저장된다
- 속도가 느리다
- 메모리가 스택에 저장되므로 무한재귀함수를 돌렸을 때 스택오버플로우 오류가 뜰 수 있다 => 메모리 구조를 보면 스택의 메모리 공간은 작고 함수를 불러오는 콜스택이 누적되면서 오류가 발생하는 것이다!

> 콜스택(call stack) 이란, 함수를 호출할 때 하나씩의 스택 블록이 쌓이게 되는 것을 뜻한다. 함수 호출이 많아질 수록 스택의 메모리 공간을 많이 차지하게 된다

#### 반복문의 특징 
- 코드길이가 길어진다
- 가독성이 재귀함수보다 떨어진다
- 속도가 빠르다
- 변수가 많아진다
- 재귀함수와 달리 함수를 호출하는 것이 아니기 때문에 스택 메모리 공간을 많이 차지하지 않는다

#### 실행속도 비교해보기

```swift
func 재귀함수() {
    print("안녕하세요")
}

func 반복문() {
    for _ in 1...10 {
        print("안녕하세요")
    }
}
func checkTime() {
    let startTime = CFAbsoluteTimeGetCurrent()
    //실행할 함수 ex)재귀함수()
    let durationTime = CFAbsoluteTimeGetCurrent() - startTime
    print("경과 시간: \(durationTime)")
}
```
간단하게 print("안녕하세요") 출력하는 함수를 재귀함수와 반복문으로 만들어서 각 함수를 같은 횟수로 실행했을 때 시간을 확인했다.
시간을 확인하는 함수는 ```checkTime()```으로 구현했다.

|재귀함수 |반복문  |
| -------- | -------- | 
|<img width="265" alt="스크린샷 2022-12-30 오후 10 32 55" src="https://user-images.githubusercontent.com/114971172/210075917-fdfca6e7-f409-4d42-98f3-15586b2d2e0a.png"> |<img width="260" alt="스크린샷 2022-12-30 오후 10 33 22" src="https://user-images.githubusercontent.com/114971172/210075991-fc38ea7e-62b9-4d24-9947-6bbcc4567a37.png">|

실제로 실행속도를 비교해보니 반복문이 재귀함수보다 빠른것을 확인할 수 있었다!

![](https://i.imgur.com/jaa9Nrb.png)


## 스택과 힙은 무엇일까?
스택과 힙은 같은 메모리 영역을 가진다
스택은 높은 메모리주소부터 할당받고, 힙은 낮은 메모리주소부터 할당받음!


#### 스택의 특징
- LIFO (Last in First Out) 구조 : 먼저 생성된 변수가 가장 나중에 해제되는 구조 => 선형구조이므로 랜덤하게 값을 지정할 수 없다!
- CPU에 의해 관리되어 속도가 매우 빠르다
- 단순한 구조를 가지고 있고 메모리 크기에 대한 제한이 있다
- 지역변수와 매개변수 등이 저장되고 할당된 변수가 호출이 완료되면 사라진다 (프로그램이 자동으로 사용하는 임시 메모리 영역!)

#### 힙의 특징
- 스택보다 구조가 복잡하다 (속도 또한 느림, 스택에서 주소를 찾아서 힙에서 값을 찾아야 하기 때문에)
- 메모리 크기에 대한 제한이 없다
- 참조타입 (class, 클로저 등)
- 스택과 다르게 사용하고 난 후 메모리 해제를 해줘야함!


#### struct vs class 


| struct| class |
| ------| ------|
| 1. 값 타입 </br> 2. 메모리가 스택에 저장되고 다 사용하고 나면 자동으로 해제가 되어 메모리를 절약할 수 있다. </br> 3. 각 struct 의 전체값이 복사가 된다. </br> 4. 전체가 복사되었기 때문에 기존 인스턴스와 구분되어 저장되었고 내부값을 변경해도 영향을 주지 않는다.(아래예시코드참고) |1.  참조 타입 </br> 2. 클래스의 주소값은 스택에 저장되고 실질적인 데이터는 힙에 저장이 된다. </br> 3. 주소값이 복사되기 때문에 복사된 인스턴스를 수정하면 원래 인스턴스 데이터도 같이 변경되는 것 처럼 보여진다.(아래예시코드참고) | 

```swift
class Computer {
    var version: Int = 15
    var brand: String = "Apple"
}

let rijiComputer = Computer()
rijiComputer.brand = "samsung" // class는 주소값이 복사되므로 Computer라는 클래스의 brnad는 var변수 로 인식된다. 그렇기 때문에 변경할 수 있다.

```
```swift
struct Computer {
    var version: Int = 15
    var brand: String = "Apple"
}

let rijiComputer = Computer()
rijiComputer.brand = "samsung" // class 는 값 전체가 복사되므로 brand의 값을 변경할 수 없다. (let rijiComputer 가 Computer()를 받고있기 때문에!)

```

- 위와같은 특징때문에 class를 반드시 사용해야하는 경우가 아니라면 스택에서 메모리를 사용하고 바로 해제되는 struct 구조를 사용하는데 비용절감과 속도측면에서 장점이 있다.


[재귀함수,반복문 참고링크](https://velog.io/@wonhee010/메모리-구조-feat.-재귀-vs-반복문)
[스택,힙 참고링크](https://corykim0829.github.io/swift/Understanding-Swift-Performance/#)
