# Notification 
> 알림 센터를 통해 등록된 모든 관찰자엑 브로드캐스트되는 정보 컨테이너

```swift
let center: NotificationCenter = NotificationCenter.default // center를 디폴트로 정의해준다. (중앙센터 느낌)


class SoccerPlayer {
    var clubName: Notification.Name
    
    init(clubName: Notification.Name) {
        self.clubName = clubName
    }
    
    func playSoccer() {
        center.post(name: clubName, object: nil) // 축구선수가 축구를 하면 센터에 전달함
    }
}

class FanOfSoccer {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func cheerup(_ name: Notification.Name) {
        
        center.addObserver(self,
                           selector: #selector(didReceiveBroadcast), // 방송이 시작되면 실행되는 메서드
                           name: name,
                           object: nil)
    } // self(내가) select(방송이시작되면) name을 응원한다는 의미로 해석!
    @objc func didReceiveBroadcast(_ notification: Notification) {
        print("\(name) 은(는) \(notification.name) 팀 응원 시작")
    }
    // 2번째 방법 센터에 응원을 시작하는 것을 알림 (?)
    //        center.addObserver(forName: name, object: nil, queue: .main) { noti in print("\(self.name) 은(는) \(noti.name) 응원 시작")}
    //    }
    
    func noCheerup(_ name: Notification.Name) {
        center.removeObserver(self, name: name, object: nil)
    }
}


let kaneNotificationName = Notification.Name("토트넘")
let mbappeNotificationName = Notification.Name("PSG")

let kane: SoccerPlayer = SoccerPlayer(clubName: kaneNotificationName)
let mbappe: SoccerPlayer = SoccerPlayer(clubName: mbappeNotificationName)

let riji: FanOfSoccer = FanOfSoccer(name: "리지")
let gamst: FanOfSoccer = FanOfSoccer(name: "감스트")

riji.cheerup(kaneNotificationName)
gamst.cheerup(mbappeNotificationName)

kane.playSoccer()
mbappe.playSoccer()
```

출력 예시

![](https://i.imgur.com/QfO9gZe.png)

- Notification (일대다 개념, 축구선수 - 중앙센터 - 축구팬)
- 축구선수들이 경기시작을 중앙센터에 알리고 중앙센터에서 축구팬들에게 경기 시작을 알려주면 축구팬들이 경기 응원을 시작하는 동기적 형태로 진행
- 노티피케이션을 발송하면 노티피케이션 센터에서 메세지를 전달한 옵저버의 처리가 끝날때 까지 대기한다. (동기적 흐름, 순차적으로 진행) 
- 비동기적으로 사용하려면 NotificationQueue(2번째 방법..?) 를 사용하면 된다.
- 일대일이 아닌 일대다 개념이기 때문에 복잡하고 얽힐 수 있는 문제가 있다.


### Notification 활용
- 이름과 연락처를 입력하여 등록하면 등록된 정보에 이름과 연락처가 업데이트된다.


#### <각각의 버튼을 눌러 변화를 업데이트한 경우>

```swift 
 @IBAction func hitRegisterButton(_ sender: Any) {
        guard let name = nameTextField.text, let phoneNumber = phoneNumberTextField.text else {
            return
        }
        registrantList.append(Registrant(name: name, phoneNumber: phoneNumber))
 }
// 입력한 textField.text를 Label.text로 직접 넣어주어 변화를 업데이트
  @IBAction func hitCheckButton(_ sender: Any) {
           nameLabel.text = nameTextField.text
           phoneNumberLabel.text = phoneNumberTextField.text
       }
```

#### < 버튼이 눌렸을 때 NotificationCenter에 알림을 post 하고 그 변화를 관찰하여 값이 업데이트 되도록 Notification을 이용한 경우>

**1. NotificationCenter 정의** 

```swift
center: NotificationCenter = NotificationCenter.default
```
- 알림을 확인하고 알려주는 중앙센터를 우선 만들어 준다.

**2. 알림을 post 하는 객체**
```swift
   @IBAction func hitRegisterButton(_ sender: Any) {
        guard let name = nameTextField.text, let phoneNumber = phoneNumberTextField.text else {
            return
        }
        registrantList.append(Registrant(name: name, phoneNumber: phoneNumber))
        let enrolledRegistrant = [NotificationKey.name: name,  NotificationKey.phoneNumber: phoneNumber]
    
        /*
         name: Notification.Name으로 알림을 식별
         object: 특정 sender의 알림을 받고싶을 때 설정, nil을 해놓으면 모든 알림을 받을 수 있다.
         userInfo: notification과 관련된 값, 변화한 값을 전달
         */
        NotificationCenter.default.post(name: Notification.Name.regist, object: nil, userInfo: enrolledRegistrant)
        
    }
```
- 등록버튼이 눌리면 이름하고 연락처의 값이 변하게 되니깐 이 변화를 post해야 한다.
- name에 들어가는 Notification.Name 은 전달하고자 하는 알림의 이름으로 이 이름을 통해알림을 식별한다. 편의를 위해 Notification.Name을 미리 정의해주면 좋다.

```swift
extension Notification.Name {
    static let regist = Notification.Name("regist")
}
```
- (자세히는 아직 잘 모르겠지만..) 인스턴스 생성 없이 regist를 바로 가져다 쓰기 위해서 static으로 해주었고 그걸 변화를 알리는 객체와 그 변화를 관찰하는 객체가 사용할 수 있게끔 해주었다.
- 근데 여기서도 값을 받아오기 위해 Notification과 관련된 인스턴스를 열거형으로 정의해주었다. (꼭 해야하는건지는 모르겠는데 해서 사용하면 편하게 쓸수는 있는것 같다)

```swift
enum NotificationKey {
    case name
    case phoneNumber
}
```
- 따라서 ```enrolledRegistrant```의 타입은 ```let enrolledRegistrant: [NotificationKey : String]``` 가 된다.

**3. 변화를 관찰하고 업데이트 하는 객체** 

버튼이 눌려서 변화를 알리면 그 변화를 관찰하고 실행하는 객체가 있다.
```swift
 func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayRegistrantLabel(_:)), name: Notification.Name.regist, object: nil)
    }
```
- 관찰자이기 때문에 ```addObserver``` 로 관찰자임을 정의한다. 
- 직접 selector안에 들어오는 메서드를 사용하여 관찰한다
- name에 들어오는 Notification.Name을 통해 관찰하고자 하는 알림을 식별한다. post한 알림과 같은 이름을 사용하면 된다.
 
**selector 메서드**
```swift
   @objc func displayRegistrantLabel(_ notification: Notification) {
        guard let name = notification.userInfo?[NotificationKey.name] as? String else {
            return
        }
        guard let phoneNumber = notification.userInfo?[NotificationKey.phoneNumber] as? String else {
            return
        }
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phoneNumber
        
    }
```
- userInfo? : 내가 제일 이해가 안되는 부분이기도 한 userInfo 이다. 먼저 userInfo의 타입을 옵션키를 눌러서 확인해보면 아래와 같이 뜬다.
![](https://i.imgur.com/AMrcQtv.png)
```swift
func controlTextDidChange(_ notification: Notification) 
{
    if let fieldEditor = notification.userInfo?["NSFieldEditor"] as? NSText,
        let postingObject = notification.object as? NSControl
    {
        // work with the field editor and posting object
    }
}
```
- 그리고 이러한 예문이 나온다...! 이걸 보고 내가 이해한 내용은 userInfo의 타입은 딕셔너리이기 때문에 옵셔널로 확인이 된다. 그럼 이 옵셔널을 바인딩하여 값을 확인할 수 있고 예문처럼 값을 하나씩 있는지 확인하고 타입이 맞는지도 확인하는 과정이 필요하다.

```swift
let enrolledRegistrant = [NotificationKey.name: name,  NotificationKey.phoneNumber: phoneNumber]
```
- 아까 위에서 userInfo에 넣어준 타입은 Notification과 관련된 인스턴스를 담고 있는 열거형을 만들어주고 거기서 값을 가져왔기 때문에 위와 같은 형태로 표현이 된다. 
- 결국 Label.text에 값이 들어오려면 String 타입이어야 하기 때문에 옵셔널 바인딩을 하면서 String 타입인지 as? 로 확인하는 과정이 필요하다고 이해를 했다.
- 그렇게 확인이 끝나면 아까 알림을 받은 name을 nameLabel.text로 직접 업데이트를 해주겠다고 알려주면 된다. (전화번호도 마찬가지)

**4. viewDidLoad()에서 실행**
- 위와같이 복잡한 과정을 거친 후 (센터를 만들고, 관찰대상이 변화를 센터에 알려주고, 관찰자가 센터를 통해 그 변화를 감지하여 업데이트하는 과정) 실행하는 구문은 ```viewDidLoad()``` 에서 실행시켜주면 된다.
```self.register()```

## 참고
[notification](https://velog.io/@leeyoungwoozz/iOSSwift-Notification-Center-KVO)
[Notification-전체설명](https://leeari95.tistory.com/49)
[Notification-데이터보내기](https://fomaios.tistory.com/entry/Notification으로-데이터-보내기Pass-data-using-Notification)
[Notification](https://silver-g-0114.tistory.com/106)

