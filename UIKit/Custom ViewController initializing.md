# UIViewController 서브클래스의 custom ViewController initializing
- Custom ViewController에 이니셜라이저를 정의할때, 아래와 같은 오류가 발생하였다.

<img src="https://i.imgur.com/DX6pJsN.png" width="400">

### required init을 구현해야하는 이유
- UIViewController는 `NSCoding`을 채택하고 있다.
- NSCoding 프로토콜은 해당 클래스의 인스턴스를 인코딩하고 디코딩할 수 있도록 클래스가 구현해야 하는 두 가지 메서드를 선언한다. 이 기능은 archiving(주체 및 기타 구조가 디스크에 저장되는 곳)과 distribution(주체가 다른 주소 공간에 복사되는 곳)의 기초를 제공한다.

- NSCoding 프로토콜 정의 부분을 보면 init?(coder: NSCoder) 이니셜라이저가 있는 것을 확인할 수 있고, 이 프로토콜을 채택하는 모든 클래스는준수해야하고 그 클래스를 상속받는 자식 클래스도 동일하게 준수해야한다.

### required 키워드가 붙는 이유
- 필수생성자! 프로토콜에 정의된 이니셜라이저를 구현할때는 required 키워드를 붙여야한다. 
- 슈퍼 클래스에서 정의해둘 경우 서브 클래스가 슈퍼 클래스의 생성자를 상속받지 않는 한 서브클래스에서 반드시 구현해주어야 한다.

### required init을 호출하고 싶지 않으면?
```swift
 required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
```
- fatalError로 처리해 줄 수 있다. 그러면 앱을 종료하게 된다.

## 스토리 보드에서 구현하기
### instantiateViewController(identifier:creator:)
> 스토리보드에서 지정된 뷰 컨트롤러를 만들고 사용자 지정 초기화 코드를 사용하여 초기화하는 코드

- ViewController에 지정이니셜라이저를 정의하여 화면 전환 시 생성할 인스턴스에 이니셜라이저를 통한 주입에 활용

![](https://i.imgur.com/zUyzBdR.png)
- identifier : 스토리보드 파일의 뷰 컨트롤러를 고유하게 식별하는 문자열. 이 identifier는 뷰 컨트롤러 객체 자체의 속성이 아니다. 스토리보드는 이것을 사용하여 뷰 컨트롤러에 적합한 데이터를 찾는다.

- creator : 뷰 컨트롤러의 사용자 지정 생성 코드를 포함하는 블록. 이 블록을 사용하여 뷰 컨트롤러를 만들고, 제공된 코더 객체와 필요한 사용자 지정 정보로 초기화하고, 새로운 뷰 컨트롤러를 반환한다.

  - coder : 뷰 컨트롤러를 구성할 때 사용할 스토리보드 데이터를 포함하는 코더 객체.

- 블록에서 nil을 반환하면, 이 메서드는 기본 init(coder:) 메서드를 사용하여 뷰 컨트롤러를 만든다.

#### Return Value
- 지정된 식별자 문자열에 해당하는 뷰 컨트롤러. 뷰 컨트롤러에 주어진 식별자가 없는 경우, 이 방법은 예외를 발생시킨다.

#### Discussion
- 이 방법을 사용하여 프로그래밍 방식으로 표시할 뷰 컨트롤러 객체를 만들 수 있다. 이 메소드를 호출할 때마다, 작성한 블록을 사용하여 뷰 컨트롤러의 새 인스턴스를 만든다.
블록에서 사용자 지정 초기화 방법을 사용하여 뷰 컨트롤러를 만들고 반환할 수 있다. 사용자 지정 초기화 방법은 NSCoder 매개 변수를 수락해야 하며 실행 중 어느 시점에서 상속된 init(coder:) 메서드를 호출해야 한다. 스토리보드 상태를 초기화한 후, 뷰 컨트롤러의 사용자 지정 속성을 초기화한다.

### 소스코드
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(
            identifier: Identifier.descriptionViewController,
            creator: { creator in
                let item = self.items[indexPath.row]
                let nextViewController = DescriptionViewController(item: item, coder: creator)
                
                return nextViewController
            }
        ) else { return }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
```

## 참고
[NSCoding-공식문서](https://developer.apple.com/documentation/foundation/nscoding)
[instantiateViewController-공식문서](https://developer.apple.com/documentation/uikit/uistoryboard/3213989-instantiateviewcontroller)
[dev_jane블로그](https://velog.io/@dev_jane/UIViewController-서브클래스의-custom-initializer-만들기required-initializer-initcoder-must-be-provided-by-subclass-of-UIViewController)
