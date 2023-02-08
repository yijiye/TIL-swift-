# UIApplicationDelegate
> 앱의 공유된 행동을 관리하는 방법

### Declaration
`@MainActor protocol UIApplicationDelegate`

### Overview
- 앱 delegate object는 앱의 공유 동작을 관리한다. 앱 delegate는 앱의 root 객체이며, UIApplication과 함께 작동하여 시스템과의 일부 상호 작용을 관리한다. UIApplication 객체와 마찬가지로, UIKit은 앱의 실행 주기 초기에 앱 delegate object를 생성하므로 항상 존재한다.

- App delegate object는 아래와 같은 일을 처리할 수 있다.

  - 앱 central data 구조를 초기화 할 때
  - 앱 화면을 구성할 때
  - 앱 외부에서 (낮은 메모리공간, notification 다운로드 완료와 같은알림)발생하는 알림에 반응
  - 앱 자체를 대상으로 하고 앱의 scence, view, view controller 이벤트에 반응
  - Apple Push Notification 서비스와 같은 출시 시간에 필요한 서비스 등록

### Life-cycle management in iOS 버전12, 그 전버전
- iOS12와 그 전버전은 앱의 주요한 life-cycle은 관리할때 app delegate를 사용했다. 특히, 앱 위임의 방법을 사용하여 foreground에 들어가거나 배경으로 이동할 때 앱의 상태를 업데이트를 할때 주로 사용.
- Forground 앱은 현재 화면이 띄워서 사용중인 앱을 의미하고 새로운 앱이 열리면 현재 화면은 Background로 이동하게 된다.

[참고링크](https://developer.apple.com/documentation/uikit/uiapplicationdelegate)

# UISceneDelegate
> scene 안에서 일어나는 life-cycle 이벤트에 반응할때 사용하는 핵심 메서드

### Declaration
`@MainActor protocol UISceneDelegate`

### Overview
- 앱의 유저 인터페이스의 인스턴스에서 life-cycle 이벤트를 관리할때 사용한다. 화면에 영향을 주는 상태변환에 반응을 한다. (예를 들어서 화면이 foreground에 들어가서 활성화 될때, 백그라운드로 들어갈때)
- 중요한 작업을 끝내고 앱이 백그라운드로 들어갈때 조용하게 만드는 작업을 UISceneDelegate를 통해 할 수 있다.
- UISceneDelegate 객체를 직접 생성하지 말고 화면을 구성하는 데이터의 한 파트로 커스텀한 delegate class 이름을 붙여서 구체화시켜라.
- 앱의 `Info.plist 파일` 이나 앱 delegate의 `application(_:configurationForConnecting:options:)` 메소드에서 반환하는 UISceneConfiguration 객체에서 이 정보를 지정할 수 있다.

[참고링크](https://developer.apple.com/documentation/uikit/uiscenedelegate)


# Managing your app's life cycle
> 앱이 foreground 나 background에 있을 때 시스템 알림에 응답하고, 다른 중요한 시스템 관련 이벤트를 처리

### Overview
- 앱의 현재 상태는 언제든지 할 수 있는 것과 할 수 없는 것을 결정한다. 
- 예를 들어, forground App은 사용자의 관심을 끌기 때문에 CPU를 포함한 시스템 리소스보다 우선합니다. (현재 사용중인 앱이기 때문에)
- background App은 가능한 한 적은 작업을 해야 하고 가급적 아무일도 하지 않는 것이 좋다. (현재 사용하지 않는 off-screen 이기때문에) 앱이 forground에서 background로 변하면 그에 따라 동작을 조정해야 한다. (사용중인 앱 -> 새로운 앱을 켜서 상태가 바뀌는 경우)

- 앱의 상태가 변경되면 UIKit은 적절한 delegate 객체를 사용하여 알려준다.
   - iOS 13 이상에서는 UISceneDelegate 객체를 사용
   - iOS 12 및 이전 버전에서는 UIApplicationDelegate 객체를 사용
   
**Note**
- 앱에서 화면 지원이 가능하다면 iOS는 항상 iOS13과 그 후버전에서 scene delegate를 사용하고 iOS12와 전버전에서는 시스템이 app delegate를 사용한다.

### Respond to scene-based life-cylce events
- 앱이 화면을 지원한다면, UIKit은 각각 다른 life-cycle을 전달한다. 하나의 화면은 장치에서 앱의 UI running 인스턴스를 나타낸다. 유저는 각 앱의 여러 화면을 만들 수 있고 각각 보여줄수도 숨길수도 있다. 각자 다른 life-cycle을 가지고 있기 때문에 다른 상태로 실행될 수 있다.
   - 예를들어, 다른 화면이 background이거나 멈춰있을때 다른 화면은 전경에 올 수 있다.

  - #### **Important**
    - 장면 지원은 옵트인 기능(opt-in) 이다. 기본 지원을 활성화하려면, 앱이 지원하는 장면 지정에 설명된 대로 앱의 `Info.plist 파일`에 `UIApplicationSceneManifest` 키를 추가해야한다.

      - opt-in 기능 이란, 앱의 특정 기능을 사용자가 직접 활성화할 수 있도록 하는 기능이다. 기본적으로 비활성화 되어 있고, 사용자가 명시적인 조치를 통해 활성화 할 수 있다.
      - 예를들어, 앱이 푸시알림 기능을 제공할 수 있지만 이 알림을 받으려면 opt-in 해야 할 수 있음 (알림을 직접 설정하는것! 허용 또는 허용하지 않음)
      - 사용자가 알림의 종류와 빈도에 대한 제어권을 가지게 되고 개인정보보호에 도움이 된다.


#### State transition for Scenes

- 유저나 시스템이 앱에게 새로운 화면을 요청하면, UIKit은 unattached state에 그 화면을 만들어 놓는다. 
- 유저가 요청한 화면 foreground에 빠르게 움직여 화면에 나타난다. 시스템이 요청한 화면은 일반적으로 background로 이동하여 이벤트를 처리한다. (예를들어, 시스템은 위치 이벤트를 처리하기 위해 background에서 화면을 실행할 수 있다.)
- 유저가 앱의 UI를 종료할때, UIKit은 관련된 화면을 backgroun로 이동하고 최종적으로 중지 상태로 이동한다. 
- UIKit은 리소스를 회수하기 위해 background 또는 중지된 화면을 연결 해제할 수 있고 그 화면을 분리된 unattaced 상태로 되돌려 놓는다.

![](https://i.imgur.com/9cQ1WsS.png)

- 상태를 전환하는 과정

1. UIKit이 앱 화면과 연결할때, 앱의 초기 UI와 화면에 필요한 데이터를 로드한다.
2. foreground-active 상태로 바뀔 때, UI를 구성하고 유저와 상호작용할 준비를 한다.
3. foreground-active 상태를 떠날 때, 데이터를 저장하고 앱을 멈춘다.
4. background 상태로 들어갈 때, 가능한한 많은 메모리를 해제하고 앱의 스냅샷을 준비한다.
5. 화면이 해제되면 화면과 관련있는 모든 공유 데이터를 클린업한다.
6. 화면과 연관된 이벤트는 UIApplicationDelegate 객체를 이용하여 앱이 시작될때 반응해야한다.

**앱의스냅샷이란?**

> 앱이 백그라운드로 전환되었을 때 시스템에 의해 저장된 화면 스냅샷으로 앱이 다시 포그라운드로 전환되면서 앱의 UI를 빠르게 재생성할 수 있게 해준다. 즉, 앱이 백그라운드에서 실행되는 동안 메모리에 저장되는 앱의 현재 UI 상태를 캡쳐해 놓은 것을 뜻한다.

### Respond to app-based life-cycle events
> iOS 버전 12와 그 전버전에 해당

- 화면을 제공하지 않는 경우 UIApplicationDelegate 객체를 이용하여 life-cycle 이벤트를 전달한다.
- 앱 delegate는 별도의 화면에 표시되는 창을 포함하여 모든 창을 관리하고 결과적으로 앱 상태 변환은 앱의 전체적인 UI에 영향을 끼친다. (화면에 띄어지는 컨텐츠를 포함하여)
- 앱이 시작 후 시스템은 UI가 화면에 나타나는지 아닌지에 따라서 앱을 inactive 또는 background 상태로 넣는다. 
- foreground 상태가 될때, 앱은 active 상태로 자동으로 변환된다.
- 그 후, 상태는 앱이 종료될 때까지 활성과 배경 사이에서 변동한다. 

![](https://i.imgur.com/EhOE8eO.png)

- 상태를 전환하는 과정

1. 시작시 앱의 데이터 구조와 UI를 초기화한다.
2. 활성화할때, UI 구성을 마무리하고 유저와 상호작용을 준비한다.
3. 비 활성화시 데이터를 저장하고 앱을 중지한다.
4. background 상태로 들어올 때, 중요한 업무를 끝내고 가능한 많은 메모리를 해제하고 앱의 스냅샷을 준비한다.
5. 종료시에 모든 작업을 즉시 중단하고 공유된 리소스를 해제한다.

### Respond to other significant events
- life-cycle 이벤트를 관리하기 위해 앱은 아래와 같은 이벤트 리스트를 다룰 준비를 해야한다.


| event |  |
| -------- | -------- |
| Memory warnings| 앱의 메모리 사용량이 너무 높을 때 경고를 받는다. 앱이 사용하는 메모리량을 줄여야한다.[RespondingToMemoryWarnings](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle/responding_to_memory_warnings) |
|Protected data becomes available/unavailable| 유저가 기기를 잠그거나 잠그지 않을때 받는 이벤트 [applicationProtectedDataDidBecomeAvailable](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623044-applicationprotecteddatadidbecom)</br>[applicationProtectedDataWillBecomeUnavailable](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623019-applicationprotecteddatawillbeco) |
|Handoff tasks|[NSUserActivity](https://developer.apple.com/documentation/foundation/nsuseractivity) 객체가 처리되어야 할때 받는 이벤트 [application(_:didUpdate:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622963-application) |
|Time changes| 전화 통신사가 시간 업데이트를 보낼 때와 같은 몇 가지 다른 시간 변경 사항을 받는 이벤트 [applicationSignificantTimeChange](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622992-applicationsignificanttimechange)|
| Open URL| 앱이 리소스를 오픈하려고 할때 받는 이벤트[application(_:open:options:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application)|

[참고링크](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle)

