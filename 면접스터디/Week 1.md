# 면접스터디 Week 1

# Bounds와 Frame의 차이를 설명하시오
- Bounds는 자기 자신의 위치와 크기를 나타내고 Frame은 슈퍼뷰를 기준으로 한 위치와 크기를 나타낸다.

## Bounds를 실제 사용하는 예시는 무엇이 있나요?
- ScrollView의 위치를 나타낼 때 Bounds를 사용할 수 있습니다. ScrollView의 contentOffset이 바로 bounds를 설정하는 값입니다.
- View를 회전한 후 View의 실제 크기를 알고 싶을 때 사용할 수 있습니다.

## Frame을 사용하는 예시는 무엇이 있나요?
- 단순히 View의 위치나 크기를 설정할 때 (오토레이아웃을 잡을 때)


---

# 실제 디바이스가 없을 경우 개발 환경에서 할 수 있는 것과 없는 것을 설명하시오
실제 디바이스가 없는 경우 시뮬레이터로 앱을 돌려볼 수 있는데 거의 기본적인 기능은 다 확인할 수 있습니다.

## 할 수 있는 것
- 화면에 그려지는 UI를 확인
- 화면 회전
- 글씨 크기 조정
- 알람과 같은 소리 확인 (맥이나 맥북으로 연결되어 소리가 남)
- 키보드 입력
- Accessibility
- 지역화 기능 (위치 받아오기)
- API 통신

## 할 수 없는 것

### 하드웨어 
- 진동
- 모션 (가속도계, 자이스코프 등)
- 오디오 및 비디오 입력 (카메라 마이크)
- GPS 센서
- 기압계
- 주변광 센서
- 전화기능
- 터치로 줌인 줌아웃 하는 기능
- Face ID (직접 얼굴 인식은 안되지만 인식됨, 안됨 처리는 가능)

### API 
- Apple의 푸시 알림 받기, 알림 보내기
- 개인 정보 보호 알림 지원안함
- Handoff 기능 불가

### 지원하지 않는 프레임워크
- 외부 악세서리
- IOSurface
- Media Player
- Message UI
- UIVideoEditorController class

- [참고링크](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/iOS_Simulator_Guide/TestingontheiOSSimulator/TestingontheiOSSimulator.html)

---

# 앱의 컨텐츠나 데이터 자체를 저장/ 보관하는 특별한 객체를 무엇이라고 하는가?

데이터베이스라고 합니다.
데이터베이스는 앱에 저장하는 로컬DB와 외부에 따로 백업하는 Remote DB가 있습니다. 

iOS에서 주로 사용되는 데이터베이스로는 UserDefaults가 있고 프레임워크로는 CoreData가 있다.
주로 CoreData 프레임 워크를 사용하여 데이터를 저장한 경험이 있다.
Remote DB로는 Firebase Storage를 사용해보았는데 이는 구글에서 지원하는 데이터베이스로 알고있다.

## CoreData에 대해 알고있는대로 설명해주세요.

CoreData는 프레임워크로 SQLite나 XML과 같은 종류로 저장되고 관리됩니다.
크게 CoreData의 클래스로 Entity를 정의하고 Entity를 구성하는 attribute로 이루어져 있습니다. 또한 Entity 끼리 관계를 정의하는 Relationship 기능이 있습니다.

그리고 CoreData를 구현할 때 관리자 역할을 하는 context가 있습니다.

## CoreData Lightweight migration에 대해 설명해주세요.

CoreData를 사용하다보면 새로운 attribute가 추가되는 등 기존에 있는 거에 추가되는 경우가 발생하는데 이를 위해 migration 기능이 제공됩니다. 주로 버전관리를 위해 사용하는 것으로 알고있습니다.

---

# 앱 화면의 콘텐츠를 표시하는 로직과 관리를 담당하는 객체를 무엇이라고 하는가?

UIViewController 입니다.
UIViewController는 iOS에서 가장 중요한 요소 중 하나라 생각합니다. ViewController는 뷰의 유저 상호작용에 응답하고, 데이터 변화에 응답하는 등 view와 model 사이에서 관리하는 역할을 합니다.


## 아키텍쳐 질문
Swift 언어는 MVC 아키텍쳐에 맞춰져 있다고 생각하며, UIViewController는 model과 view 사이에 관리하는 역할로 있습니다. 그러나 사용하다보면 ViewController의 로직 역할이 많아져 비대해지는 문제가 있고 이를 해결하고자 MVP, MVVM 아키텍쳐가 도입되었습니다. 
MVP는 Presenter가 도입되었고 MVVM은 viewModel이 도입되어 두가지 모두 공통적으로 viewController의 비즈니스 로직을 담당하는 기능을 하고 있습니다.

----
# App thinning에 대해 설명하시오

앱 시닝이란 앱이 디바이스에 설치될 때, 앱 스토어와 운영체제가 디바이스의 특성에 맞게 설치되도록 하는 설치 최적화 기술을 말합니다.
앱 시닝은 슬라이싱, 비트코드, 주문형리소스가 있습니다.

- 슬라이싱은 앱이 지원하는 여러 디바이스에 대해 각각 조각 번들을 생성하고 해당 디바이스에 가장 적합한 조각을 전달하는 기술
- 비트코드는 기계어로 번역되기 이전 단계의 중간 표현을 의미합니다. 비트코드를 사용하면 필요한 경우에 따라 재컴파일하여 앱 바이너리를 생성하기 때문에 이 과정에서 최적화를 할 수 있습니다.
- 주문형 리소스는 필요할 때 다운로드 받는다는 것을 말합니다. 사용자가 필요할 때 다운받으면 됩니다.
