# CoreMotion
> Framework
> Accelerometer (가속도계), Gyroscope(자이로스코프), Pedometer(보수계) 및 환경 관련 이벤트

## Overview
iOS 디바이스의 하드웨어로부터 환경 관련 데이터와 모션을 리포트해준다.
이 프레임워크를 사용하여 앱에서 사용할 수 있는 하드웨어 관련 데이터에 접근할 수 있다. 예를 들어서 게임앱은 가속도계, 자이로스코프를 사용할 수 있다.
이 프레임 워크의 많은 서비스들은 하드웨어에 의해 기록되는 raw 데이터와 이런 값들의 processed한 버전 둘다 접근할 수 있다.
또환 processed한 가속도계 값은 중력으로 인한 가속도가 아닌 사용자로 인한 가속도만 반영합니다. 

```bash=
Important

iOS 10 이후부터 Info.plist 파일에 NSMotionUsageDescription을 추가해야한다.
```

# CMMotionManager 
> Class
> motion 서비스를 관리하고 시작하는 객체

## Overview
디바이스의 온보드 센서에 의해 감지되는 움직임을 리포트하는 서비스를 사용하기 위한 객체이다.
- Accelerometer data 
- Gyroscope data 
- Magnetometer data
- Device-motion data

처리된 장치 모션 데이터는 장치의 자세, 회전 속도, 보정된 자기장, 중력 방향 및 사용자가 장치에 부여하는 가속도를 제공한다.

```bash
Important

CMMotionManager는 1개만 만들어야한다.
여러개의 객체를 만드는 경우 가속도와 자이로스코프로 부터 받는 데이터 값에 영향을 끼칠 수 있다.
```

지정된 업데이트 간격으로 실시간 센서 데이터를 수신하거나, 센서가 데이터를 수집하고 나중에 검색할 수 있도록 저장할 수 있다. 이 두 가지 접근 방식을 모두 사용하여 더 이상 데이터가 필요하지 않을 때 적절한 중지 방법(`stopAccelerometerUpdates()`, `stopGyroUpdates()`, `stopMagnetometerUpdates()` 및 `stopDeviceMotionUpdates()`)을 호출하면 된다.

## Handling Motion Updates at Specified Intervals
특정 간격으로 모션 데이터를 수신하기 위해, 앱은 OperationQueue와 이러한 업데이트를 처리하기 위한 특정 유형의 블록 핸들러를 사용하는 "Start" 방법을 호출한다. 모션 데이터는 블록 핸들러로 전달된다. 업데이트 빈도는 "Interval" 속성의 값에 의해 결정된다.

- Accelerometer: `accelerometerUpdateInterval`로 인터벌 설정을 하고, `startAccelerometerUpdates(to:withHandler:)`로 시작한다.
- Gyroscope: `gyroUpdateInterval`, `startGyroUpdates(to:withHandler:)`
- Magnetometer: `magetometerUpdateInterval`, `startMagnetometerUpdates(to:withHandler:)`
- Device motion: `deviceMotionUpdateInterval`, `startDeviceMotionUpdates(using:)`


### 소스코드

```swift
@objc private func measureAcc(timer: Timer) {
    if motionManager.isAccelerometerAvailable {
        motionManager.accelerometerUpdateInterval = 0.1
        acceleroDataPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] accelerometer, time in
                self?.accelerometerSubject.send((accelerometer, time))
            }
            .store(in: &cancellables)
    }
}
...
private func acceleroDataPublisher() -> Future<([ThreeAxisValue], Double), Error> {
    return Future<([ThreeAxisValue], Double), Error> { promise in
            
        let timeout: TimeInterval = 60
        var accelerometerData: [ThreeAxisValue] = []
        var elapsedTime: TimeInterval = 0
            
        self.motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            if let error = error {
                promise(.failure(error))
            } else if let data = data {
                    
                let accX = data.acceleration.x
                let accY = data.acceleration.y
                let accZ = data.acceleration.z
                let accData = ThreeAxisValue(valueX: accX, valueY: accY, valueZ: accZ)
                accelerometerData.append(accData)
                self?.isProcessingSubject.send(true)
                elapsedTime += 0.1
                    
                if self?.isStopButtonTapped == true {
               self?.motionManager.stopAccelerometerUpdates()
                    self?.isProcessingSubject.send(false)
                    promise(.success((accelerometerData, elapsedTime)))
                    self?.isStopButtonTapped = false
                }
                    
                if elapsedTime >= timeout {
                    self?.motionManager.stopAccelerometerUpdates()
                    self?.timer?.invalidate()
                    self?.isProcessingSubject.send(false)
                    promise(.success((accelerometerData, elapsedTime)))
                }
            }
        }
    }
}
```

나는 Combine을 활용해서 Handler처리를 Future로 했다. 만약 성공하면 값과 측정한 시간을 보내 그 값을 사용했다.


## 참고
- [Apple Developer - CMMotionManager](https://developer.apple.com/documentation/coremotion/cmmotionmanager/)
