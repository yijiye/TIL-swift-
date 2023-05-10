# Core Location
> Framework
> 장치의 방향과 지리적 위치 획득

## Overview
CoreLocation은 근처 iBeacon 장치와 연관된 위치나, 방향, 고도, 지리적 장소에 대한 서비스를 제공한다. 이 프레임워크은 장치에서 사용가능한 모든 components (Wi-Fi, GPS, Bluetooth, magnetometer, barometer, cellular hardware)를 사용하여 데이터를 얻는다.

`CLLocationManager` class 인스턴스를 사용하여 Core Location 서비스의 시작과 종료를 나타낼 수 있다. 이 매니저는 아래 장소와 연관된 활동을 지원한다.

- 표준, 특정 위치 업데이트
정확성의 정도에 따른 현재 위치의 크고 작은 변화를 추적한다.
- 지역 모니터링
사용자가 지역을 떠나거나 들어올 때, 위치 이벤트를 만들어 모니터링한다.
- Beacon ranging 
근처 비컨에 위치하고 감지한다.
     - Beacon이란, 특정 위치의 정보를 전달하기 위해 사용되는 장치
- 나침반
온 보드 나침반으로 부터 변화를 감지하고 보고한다.

iOS에서 앱을 실행할 때, 위치 정보를 제공하는지 알림을 띄울 수 있다. 이 알림을 띄우기 위해 info 파일에서 설정을 해주어야 하는데,
`Privacy - Location When in Use Usage Description` 을 선택하여 원하는 String을 Value에 입력해주면 된다.
만약 `Privacy`를 찾을 수 없다면 + 버튼을 눌러 새로 추가해주면 된다.

**예시 코드**
```swift 
// viewDidLoad에 setUpLocation을 호출하고 그 안에서 위치 기반 정보 동의 알림을 띄우도록 한다.
 override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpLocation()
 }
...

// setUpLocation
private func setUpLocation() {
        // delegate를 설정하는 부분은 main 스레드 있도록 권장 (공식문서) 왜냐하면, 주로 UI와 관련된 작업을 하기 때문
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.delegate = self
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // startUpdatingLocation()은 위치 업데이트를 시작하는 비동기 메서드이므로 백그라운드에서 실행해야함. 따라서 global().async가 적절
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
```

`self?.locationManager.startUpdatingLocation()`를 `DispatchQueue.global().async {}` 로 묶어준 이유는 처음에 없이 하였을 때, 이와 같이 에러가 발생하였다.

<img src="https://hackmd.io/_uploads/B1P16O_4h.png" width="400">


그 이유에 이 메서드는 비동기처리 메서드로 백그라운드 스레드에서 실행되어야 한다. main에서 실행되면 해당 작업이 main 스레드를 방해하여 앱이 느려지거나 동작하지 않을 수 있다.
따라서 백그라운드 스레드에서 처리하도록 `DispatchQueue.global().async{ }`로 묶어주었다.

또한 delegate를 설정해주는 부분은 아래 delegate 공식문서에서 알 수 있듯이 main 스레드에서 하도록 되어있어 참고하였다.

## CLLocationManagerDelegate
> Protocol
> location 매니저 객체와 연관된 이번테를 받기 위해 사용하는 메서드

### Overview
이 프로토콜은 앱에게 위치 기반의 이벤트를 보고하기 위한 delegate의 메서드를 호출한다.
예를 들어, 현재 위치를 사용하여 지도에서 사용자의 위치를 업데이트하거나 사용자의 현재 위치와 관련된 검색 결과를 반환할 수 있다.

```bash
Important

항상 위치 기반 데이터를 전달받을 때 잠재적 실패를 핸들링 할 수 있는 메서드를 이행해야한다.
```

Core Location은 `CLLocationManager`를 초기화한 스레드에서 런루프의 delegate 객체의 메소드를 호출한다. 그 스레드 자체에는 앱의 메인 스레드에 있는 것과 같은 활성 실행 루프가 있어야 한다.

### locationManager(_:didUpdateLocations: )
> Instance Method
> 새로운 위치 데이터를 사용할 수 있다고 delegate객체에 알려준다.

```swift
optional func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
)
```
- Locations
위치 데이터를 포함하는 CLLocation 객체의 배열. 이 배열은 항상 현재 위치를 나타내는 적어도 하나의 객체를 포함한다. 업데이트가 연기되었거나 전달되기 전에 여러 위치가 도착한 경우, 배열에는 추가 항목이 포함될 수 있다. 배열의 물체는 발생한 순서대로 구성되어 있다. 따라서, 가장 최근의 위치 업데이트는 배열의 끝에 있다.


### locationManager(_:didFailWithError: )
> InstanceMethod
> location 매니저가 location value를 얻을 수 없는 경우 delegate객체에 알려준다.

location 매니저는 위치 또는 heading 데이터를 가져오려고 할 때 이 방법을 호출한다. 위치를 즉시 검색할 수 없는 경우, `CLError.Code.locationUnknown` 오류를 보고하고 계속 시도한다. 그러한 상황에서, 개발자는 단순히 오류를 무시하고 새로운 이벤트를 기다릴 수 있다. 인근 자기장의 강한 간섭으로 인해 heading을 결정할 수 없다면, 이 방법은 `CLError.Code.headingFailure`를 반환한다.

## Requesting authorization to use location services

앱을 사용할 때, 사용자에게 위치 정보 제공을 동의하는지 알림을 띄우고 상황에 맞게 처리할 수 있다. (프라이버시에 민감하기 때문에 동의를 구해야 한다!)

**예제 코드**
```swift
func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { 
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:  // Location services are available.
        enableLocationFeatures()
        break
        
    case .restricted, .denied:  // Location services currently unavailable.
        disableLocationFeatures()
        break
        
    case .notDetermined:        // Authorization not determined yet.
       manager.requestWhenInUseAuthorization()
        break
        
    default:
        break
    }
}
```

**직접 구현해보기**
```swift
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default:
            AlertManager.shared.showAlert(target: self,
                                          title: "위치 정보 권한 필요",
                                          message: "이 기능을 사용하려면 위치 권한이 필요합니다. 변경하시겠습니까?",
                                          defaultTitle: "아니오",
                                          destructiveTitle: "네",
                                          destructiveHandler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            })
        }
    }
```

나는 동의를 하면 위치 정보를 받아서 날씨 API를 통해 데이터를 가져올 수 있게 했는데 허용 안함을 누르는 경우 어떻게 처리를 하면 좋을지 고민이 되었다.

아직 완벽하게 해결되진 않았지만, 위치 정보가 필요하기 때문에 권한 설정을 하라는 알림을 띄우고 변경을 원하는 경우 설정 앱을 열도록`destructiveHandler`에 코드를 작성하였다. 완벽하지 않은 이유는 시뮬레이터로 하다보니 설정앱에서 Diary 앱이 만들어지지 않아 권한 설정을 하지 못했다 그래서 테스트를 못해봤다 😂


또한 이미 viewDidAppear에서 호출하는 메서드 안에서 허용시 위치 정보를 업데이트 하라는 코드를 작성하였기 때문에, 허용되는 case의 경우 break만 호출하였다.

```swift
private func setUpLocation() {
  ...
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
```

## 참고
- [Core Loacation 공식문서](https://developer.apple.com/documentation/corelocation)
- [CLLocationManagerDelegate 공식문서](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate)
- [Requesting authorization to use location services](https://developer.apple.com/documentation/corelocation/requesting_authorization_to_use_location_services)
- [crazydeer-tistory](https://crazydeer.tistory.com/m/entry/iOS-Swift-GPS-받고-위도-경도-받아서-날씨-API-데이터-받기)

