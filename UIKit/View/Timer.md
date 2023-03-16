# Timer
- 실시간으로 시간을 측정하기 위해 timer 기능을 구현해보았다. (그런데 사실 timer는 real-time mechanism은 아님)
- [공식문서](https://developer.apple.com/documentation/foundation/timer)에 따르면 timer는 특정 시간 간격이 경과한 후 발사되는 타이머는 대상 객체에 지정된 메시지를 보낸다.

<img src="https://i.imgur.com/ck584Ga.png" width="400">

- 타이머는 Run loops와 함께 작동한다. Run loops는 타이머에 대한 강한 참조를 유지하므로 실행 루프에 추가한 후 타이머에 대한 강한 참조를 유지할 필요가 없습니다.
- **타이머는 real-time mechanism이 아니다.** 만약 타이머가 메세지를 보내는 시간이 long Run loops callout 동안 또는 Run loops가 타이머를 모니터링하지 않는 모드에 있는 동안 발생하는 경우, 타이머는 다음에 런 루프가 타이머를 확인할 때까지 작동하지 않는다. 그렇기 때문에 **실제시간과 오차가 있을 수 있다**

### 반복 vs 1회성 타이머
- 1회성 타이머는 1회만 메시지를 보내고 자동으로 종료된다.
- 반복 타이머는 정해진 시간만큼 반복되며 이 때문에 실제시간과 오차가 있을 수 있다. 만약 예정된 시간에 보내도록 설정되어 있으면 실제 시간이 달라도 예정된 시간에 메세지를 보냄!

### 타이머의 오차범위 허용 (Tolerance)
- 타이머의 오차범위를 허용하여 애플리케이션의 전력 사용등 긍정적인 영향을 줄 수 있다. default는 0이지만 일반적으로 반복 타이머에 대해 허용 오차를 간격의 최소 10%로 설정한다.

### scheduling 타이머 in Run Loops
- 하나의 타이머는 하나의 run loop에만 등록할 수 있다.
- 크게 3가지 방법으로 타이머를 만들 수 있다.
   - `scheduledTimer(timeInterval:invocation:repeats:)`
`scheduledTimer(timeInterval:target:selector:userInfo:repeats:) `클래스 메서드를 사용하여 타이머를 만들고 기본 모드에서 현재 실행 루프에서 예약하기
   - `init(timeInterval:invocation:repeats:)` 또는 `init(timeInterval:target:selector:userInfo:repeats:)` 클래스 메서드를 사용하여 실행 루프에서 예약하지 않고 타이머 객체를 만들기 (만든 후, 해당 RunLoop 객체의 `add(_:forMode:)` 메서드를 호출하여 수동으로 실행 루프에 타이머를 추가해야함)
   - 타이머를 할당하고 `init(fireAt:interval:target:selector:userInfo:repeats:)` 메서드를 사용하여 초기화하기 (만든 후, 해당 RunLoop 객체의 `add(_:forMode:)` 메서드를 호출하여 수동으로 실행 루프에 타이머를 추가해야함)

- run loop에 스케쥴링된 타이머는 해제시키기 전까지 계속해서 반복한다. (반복타이머의 경우) 따라서 run loop에서 해제하려면 `invalidate()`를 해주면 된다.

```swift
// 1번 방법을 활용하여 구현
private var timer: Timer?


private func setUpTimer() {
    self.timer = Timer.scheduledTimer(
        timeInterval: 0.001, 
        target: self, 
        selector: #selector(timeUp), 
        userInfo: nil, 
        repeats: true
      )
}
    
@objc private func timeUp() {
    if isOpen == true {
        taskTime += 0.001
    }
    let timeInterval = taskTime
    let minute = (Int)(fmod((timeInterval/60), 60))
    let second = (Int)(fmod(timeInterval, 60))
    let milliSecond = (Int)((timeInterval - floor(timeInterval))*1000)
        
    let minuteLabel = String(format: "%02d", minute)
    let secondLabel = String(format: "%02d", second)
    let milliSecondLabel = String(format: "%03d", milliSecond)
    taskTimerLabel.text = " 업무시간 - \(minuteLabel) : \(secondLabel) : \(milliSecondLabel)"
}
```

- ViewController 에 timer 변수 생성
- Timer.scheduledTimer() 메서드를 활용
   - timeInterval : 측정할 시간 간격
   - target : self
   - selector : 수행할 @objc method 추가
   - userInfo : nil 할당
   - repeats : true (1회성으로 사용하려면 false 부여)

- 메서드를 추가하여 viewDidLoad()에 띄워주면 화면에서 실시간으로 측정할 수 있다.

## 참고
[공식문서](https://developer.apple.com/documentation/foundation/timer) </br>
[unclean.tistory](https://unclean.tistory.com/27)

