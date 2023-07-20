# Week2
## 1. 앱이 시작할 때 main.c 에 있는 UIApplicationMain 함수에 의해서 생성되는 객체는 무엇인가?

UIApplication 객체가 생성됩니다.
앱이 시작되면 UIApplicationMain() 메서드가 호출되고 
싱글톤인 UIApplication 객체가 생성됩니다. 그리고 나서 shared 클래스의 메소드가 호출되고 객체에 접근합니다.
즉, 앱을 시작하면 UIApplicationMain()이 shared app 인스턴스를 생성합니다.

## 2. @Main에 대해서 설명하시오.
프로그램의 시작점을 나타냅니다. 
UIKit에서는 AppDelegate 클래스에 붙게되고 swiftUI의 경우 SwiftUIApp 구조체에 붙게됩니다. 

### 왜 앞에 @를 붙였을까요?
그건 UIKit 프레임워크에 존재하기에 메인 함수를 사용하는걸 내포하고 있다고 생각합니다.

### @UIApplicationMain과의 차이점은 무엇이 있나요?
@main 은 타입 기반의 프로그램 entry point 이고, top-level 코드를 대체할 수 있다.
   - top-level 코드란, 0개 이상의 명령문, 선언 및 표현식으로 구성됩니다. 기본적으로 소스 파일의 Top-Level Code에서 선언된 변수, 상수 및 그 외 선언은 동일 모듈의 일부인 모든 소스파일의 코드에서 엑세스 할 수 있다고 합니다. (출처: [그린블로그](https://green1229.tistory.com/265))

@UIApplicationMain은 클래스에서만 사용이 가능하다.

### @main을 사용하는 장점에는 무엇이 있을까요?
@main을 사용하면 기존 @UIApplicationMain을 사용할때보다 타입 기반의 코드에서 더 알맞은 앱 진입점을 표현해줄 수 있으며 타입 메서드인 static func main()을 통해 확장 및 기본 클래스로 제공되며 사용할 수 있는 장점을 가지게 됩니다.

## 3. 앱이 foreground에 있을 때와 background에 있을 때 어떤 제약사항이 있나요
- Foreground mode는 메모리 및 기타 시스템 리소스에 높은 우선순위를 가지며 시스템은 이러한 리소스를 사용할 수 있도록 필요에 따라 background 앱을 종료합니다.
- Background mode는 가능한 적은 메모리공간을 사용해야함(시스템 리소스 해제, 메모리에서 해제 후 데이터를 디스크에 작성)

## 4. 상태 변화에 따라 다른 동작을 처리하기 위한 앱델리게이트 메서드들을 설명하시오.
- application(_:didFinishLaunching:) : 앱이 처음 시작될 때 실행 -> ios 13이후로 사용안함
- applicationWillResignActive: 앱이 active 에서 inactive로 이동될 때 실행 
- applicationDidEnterBackground: 앱이 background 상태일 때 실행 
- applicationWillEnterForeground: 앱이 background에서 foreground로 이동 될때 실행 (아직 foreground에서 실행중이진 않음)
- applicationDidBecomeActive: 앱이 active상태가 되어 실행 중일 때
- applicationWillTerminate: 앱이 종료될 때 실행

## 5. 앱이 In-Active 상태가 되는 시나리오를 설명하시오.
- not running : 앱이 실행되지 않았거나 완전히 종료되었을때 나타나는 상태
- in-active : 앱이 실행되면서 포어그라운드에 진입했지만 어떠한 이벤트도 받지 않는 상태
- active : 앱이 실행중이며 포어그라운드에서 이벤트를 받고 있는 상태
- background : 앱이 백그라운드에 있으며 앱으로 전환되었거나 홈버튼을 눌러 밖으로 나갔을 때의 상태
- suspended : 백그라운드에서 특별한 작업이 없을 경우 전환되는 상태

앱을 실행하고 있다가 갑자기 전화가 오거나 문자가 와서 문자를 눌러 문자 앱으로 넘어갈때, 또는 카카오톡 알림이 와서 알림을 눌러 그 앱으로 넘어갈 때가 있음

## 6. scene delegate에 대해 설명하시오.
iOS 13버전 이후 생겨났으며 UI 생명주기에 관한 이벤트를 처리하기 위한 객체입니다.
화면 상태에 관한 이벤트를 처리하는 객체입니다. 즉 앱이 백그라운드로 가거나 포어그라운드로 오거나 등 이럴 때 특정한 이벤트를 처리할 수 있습니다.
생겨나게 된 배경은 iPad의 화면 분할 때문입니다.
하나의 scene에서 두개의 화면을 보여주기위함
