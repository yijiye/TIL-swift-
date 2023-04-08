# UserDefaults
> 런타임시 앱에서 사용되는 유저의 기본 데이터베이스에 대한 인터페이스
> key-value로 값을 저장한다.
> 애플리케이션이 종료되어도 값이 저장되어 있다.
> 기본 정보를 캐싱한다.

## Overview
이 클래스는 기본 설정 시스템과 상호 작용하기 위한 프로그래밍 인터페이스를 제공한다. **기본 설정 시스템을 사용하면 앱이 사용자의 기호에 맞게 동작하도록 커스터마이징 할 수 있다.** (측정 단위나 재생속도 등을 지정할 수 있음) 앱은 이런 기호를 사용자 기본 설정 데이터베이스에 일련의 매개변수에 값을 할당하여 저장한다.

**런타임시 UserDefaults 객체를 사용하여 사용자의 기본 설정 데이트베이스에서 앱이 사용하는 기본 설정을 읽는다.** 이 UserDefaults는 정보를 **캐시**하여 불필요한 데이터베이스 접근을 막는다. 기본값을 설정하면 프로세스 내에서 **동기적**으로 변경되며, 지속적인 저장소와 다른 프로세스에 대해 **비동기적**으로 변경된다.

```bash
Important
환경 설정 하위 시스템에 직접 액세스 하지 않기!
환경 설정 속성 목록 파일을 수정하면 변경사항이 손실되거나 변경사항 반영시 지연이 발생하여 앱 충돌이 일어날 수 있다.
```
교육 기관의 관리되는 장치를 제외하고, 사용자의 기본값은 단일 장치에 로컬로 저장되며 백업 및 복원을 위해 지속된다. 사용자의 연결된 장치에서 환경 설정 및 기타 데이터를 동기화하려면, 대신 `NSUbiquitousKeyValueStore`를 사용할 수 있다.

## Storing Default Objects
UserDefaults 클래스는 floats, Doubles, Int, Bool, URLs과 같은 기본 타입에 대한 메서드를 제공한다.
기본 객체는 프로퍼티여야 하며 **NSData, NSString, NSNumber, NSDate, NSArray, NSDictionary 의 인스턴스여야 한다. (다른 유형을 저장하려면 NSData의 인스턴스를 만들기 위해 아카이브 해야함.)**

**UserDefaults 에서 반환된 값은 변경할 수 없다.** 즉, 값을 설정할 때 가변 개체를 사용하더라도 가져오는`string(forkey:)` 메서드를 사용하여 나중에 검색된 문자열을 변경할 수 없다. 가변 문자열을 기본값으로 설정하고 나중에 해당 문자열을 수정하면 `set(_:forKey:)`를 다시 호출하지 않는 한 기본값은 수정된 문자열이 반영되지 않는다.

## Persisting File References 파일 참조 유지하기 
파일 URL은 파일 시스템에서의 위치를 지정한다. `set(:forKey:)` 메서드를 사용하여 특정 파일의 위치를 저장한다.
사용자가 파일을 이동시키면 앱은 다음번 실행에서 해당 파일을 찾을 수 없다.
파일 시스템 식별자를 사용하여 파일 참조를 저장하려면 `bookmarkData(options:includingResourceValuesForKeys:relativeTo:)` 메서드를 사용하여 NSURL bookmark data를 생성하고 `set(:forKey:)` 메서드를 사용하여 유지할 수 있다. 그런 다음 user defaults에 저장된 bookmark data를 파일 URL로 해석하려면 `URLByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:` 를 사용할 수 있다.

## Responding to Defaults Changes
기본 설정 변경에 대한 업데이트를 알리기 위해 key-value observing을 사용할 수 있다.
로컬 기본 설정 데이터베이스의 업데이트를 알리기 위해 `didChangeNotification`에 등록할 수 있다.

## Using Defaults in Managed Environments
관리 환경을 지원하는 경우, UserDefaults를 사용하여 관리자가 사용자를 위해 설정한 기본값이 무엇인지 알 수 있다.
교육기관에서 관리되는 장치에서 실행되는 앱은 사용자의 다른 장치에서 자신의 다른 인스턴스와 데이터 공유를 위해 iCloud key-value 저장소를 사용할 수 있다.

## Sandbox Considerations
샌드박스화 된 앱은 다른 앱의 환경설정에서 다른 액세스 또는 수정을 할 수 없다.

**예외**
- macOS, iOS의 앱 확장
- macOS와 같은 애플리케이션 그룹에 있는 다른앱 

`addSuite(named:)` 메서드를 사용하여 제 3자 앱 도메인을 추가하더라도 앱이 해당 앱의 환경 설정에 액세스 할 수 없다.

## Thread Safety
UserDefaults 클래스는 스레드 세이프 하다.


## 소스코드
Userdefaults를 사용하여 비밀번호를 저장하고 저장된 비밀번호와 일치하면 일기장 화면으로 이동하고, 비밀번호와 일치하지 않으면 화면 이동이 되지 않도록 구현하였다.

```swift
class LogInViewController: UIViewController {
    
    @IBOutlet weak var pwTextField: UITextField!
    var diaryViewController: DiaryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "diary") as? DiaryViewController
    }
    
    @IBAction func tapLogInButton(_ sender: Any) {
        
        if pwTextField.text == "" {
            let message = "입력된 비밀번호가 없습니다."
            presentAlert(message: message)
            return
        }
        
        guard let diaryViewController = diaryViewController,
              let password = UserDefaults.standard.string(forKey: "password")
        else {
            let message = "등록된 비밀번호가 없습니다."
            presentAlert(message: message)
            return
        }
        
        if  pwTextField.text == password {
            diaryViewController.modalPresentationStyle = .fullScreen
            present(diaryViewController, animated: true)
        } else {
            let message = "비밀번호가 틀렸습니다."
            presentAlert(message: message)
        }
    }
    
    @IBAction func addNewPassword(_ sender: Any) {
        UserDefaults.standard.set(pwTextField.text, forKey: "password")
    }
    
    @IBAction func deletePassword(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "password")
        let message = "비밀번호가 삭제되었습니다."
        presentAlert(message: message)
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

```

---

## 참고
- [공식문서-UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults#2926903)
