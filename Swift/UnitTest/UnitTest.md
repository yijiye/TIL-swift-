# Unit Test
- 컴퓨터 프로그래밍에서 소스 코드의 특정 모듈이 의도된 대로 정확히 작동하는지 검증하는 절차 (모든 함수와 메소드에 대한 테스트 케이스를 작성하는 절차)
- 각 부분을 고립시켜 정확하게 동작하는지 확인하기 위함
- *모듈이란, 배포할 코드의 묶음 단위 ```import```로 표현할 수 있다.*
- 장점
   - 문제점 발견 : 프로그램을 작은 단위로 쪼개서 확인하기 때문에 빠르고 정확하게 문제점을 확인할 수 있다. 안정성이 높아진다.
   - 변경이 쉽다 : 리팩토링(Refactoring)후에 해당 모듈이 의도대로 작동하고 있음을 확인할 수 있다. => 회귀 테스트
   - 통합이 간단하다 : 상향식 (bottom-up) 테스트 방식에 유리
## FIRST 원칙 (BDD 기반)
- Fast
테스트는 빠르게 동작할 수 있어야 한다.
- Independent/Isolated
각각의 테스트는 서로 독립적이며 서로 의존해서는 안된다. 서로 영향을 주지 않아야 한다.
- Repeatable
테스트는 언제 어디서나 같은 결과가 반복되어야 한다. 통제가 어려운 부분은 테스트를 위한 객체를 만들어주는 방법도 있다.
- Self-Validating
테스트는 Bool 을 이용하여 성공/실패에 대해 스스로 검증이 가능해냐 한다. 코드 내부에서 테스트가 잘 동작했는지 판별할 수 있어야 한다.
- Timely
이상적인 테스트는 테스트하려는 실제 코드를 구현하기 직전에 구현해야 한다.

## 직접 작성해보기 (야곰닷넷)
### 테스트 파일 코드 살펴보기
```swift
import XCTest // 테스트를 만들고 실행하는 프레임워크 반드시 해주어야 함!

final class StrangeCalculatorTests: XCTestCase { // 추상클래스인 XCTest의 하위 클래스로, 테스트를 작성하기 위해 상속해야 하는 가장 기본적인 클래스

    override func setUpWithError() throws {
      /*
        setUpWithError는 각각의 테스트 케이스가 실행되기 전마다 호출되어 각 테스트가 모두 같은 상태와 조건에서 실행될 수 있도록 해줌.
        sut = 테스트할 함수명 () / setUp 구문에서 초기화를 해준다.
        */
    }

    override func tearDownWithError() throws {
        /*
        각각의 테스트가 끝난 후마다 호출되는 메서드. 보통 setUpWithError() 에서 설정한 값들을 해제할 때 사용
        sut = nil / nil을 할당해주면서 해제시켜준다.
        */
    }

    func testExample() throws {
       /*
        test 로 시작하는 메서드는 작성해야할 테스트 케이스가 되는 메서드이다. 네이밍은 무조건 test로 시작해야함.
        given, when, then 에 맞춰 작성
        */
    }

    func testPerformanceExample() throws {
      // 성능을 테스트해보기 위한 메서드. measure(block:) 메서드를 통해 성능을 측정한다.
        measure {
        
        }
    }

}
```
- 테스트코드 작성시 3가지 조건
   - given : 어떤 상황이 주어지는지
   - when : 어떤 코드를 실행하는지
   - then : test 결과를 확인하는 함수 
- 범위 내에서 경계값을 확인해보는 것이 좋다. (엣지케이스): 만약 1-45 숫자라고 하면 +- 1로 46을 확인해보는 것이 좋다.
- ```var sut: 테스트할함수명``` : sut(System Under Test), test할 타입을 명시해주는 것! 따라서 test할 함수명을 적어주면 된다.
- setUp 과 tearDown 호출 순서
- ```setUpWithError -> Test Code -> tearDownWithError 루트가 반복``` 

![](https://i.imgur.com/1IH2YWV.png)


### Code Coverage
- 실제 앱 코드에서 어느정도의 테스트가 진행되었는지 알 수 있는 툴 
    - 실제 테스트에서 어떤 코드가 실행되었는지
    - 정확성, 성능에 대해 얼마나 충분히 테스트가 이루어졌는지
    - 테스트가 포함하고 있지 않은 코드가 무엇인지
- xcode -> product -> scheme -> edit scheme 에서 확인 가능


### Do it yourself

```swift
// test 할 메서드
func countMatchingNumber(user: [Int], winner: [Int]) throws -> Int {
        guard isValidLottoNumbers(of: user) && isValidLottoNumbers(of: winner) else {
            throw LottoMachineError.invalidNumbers
        }
        
        let winNumbers = user.filter { winner.contains($0) }
        return winNumbers.count
    }
```
- user 와 winner가 둘다 true인지 확인하고 아닐 시 오류를 제대로 처리하는지 확인이 필요.
- user와 winner가 겹치는 수가 0부터 6사이인지 확인이 필요

```swift
 func test_countingMatchNumber_오류를잘인식하는지() {
        let userInput = [1,2,3,4,5,6,7]
        let winnerInput = [4,5,6,7,8,45]
        
        XCTAssertThrowsError(try sut.countMatchingNumber(user: userInput, winner: winnerInput) ) { error in XCTAssertEqual(error as! LottoMachineError, LottoMachineError.invalidNumbers)
        }
    }
    
    func test_countingMatchNumber_일치하는숫자의갯수가_0부터6개사이인지() {
        let userInput = sut.makeRandomLottoNumbersArray()
        let winnerInput = sut.makeRandomLottoNumbersArray()
        let userInputSet : Set = Set(userInput)
        let winnerInputSet: Set = Set(winnerInput)
        let intersectionSet = userInputSet.intersection(winnerInputSet)
        let result = intersectionSet.count
        
        do {
            let count = try sut.countMatchingNumber(user: userInput, winner: winnerInput)
            XCTAssertEqual(count, result)
        } catch {
        }
    }
```
- 오류를 던지는 함수이기 때문데 (throw) ```XCTAssertThrowsError```를 사용해서 해결했다. (아래 링크참고)
- 겹치는 수를 확인하기 위해 set의 intersection을 이용하여 교집합의 수를 확인하고 오류를 던지지만 오류를 해결하는 기능은 필요하지 않아 do-catch 구문을 사용하여 해결해보았다. (조금 더 간단한 방법이 있을거 같다 🤔)

[오류처리-stackoverflow](https://stackoverflow.com/questions/32860338/how-to-unit-test-throwing-functions-in-swift)



---
## writing uint tests in Swift
### Naming
- unit test를 설명하는 것은 필수적이므로 좋은 네이밍을 짓는 것은 더 빠르게 문제를 해결할 수 있게 도와준다.
- ```Tests```란 단어와 결합해서 네이밍 짓기 ex) ```StringExtensionTests```, ```ContentViewModelTests```

### 모든것에 XCTAssert를 사용하지 않기
- 많은 경우에서 ```XCTAssert```를 사용할 수 있지만 가끔 테스트를 실패했을 때 다른 아웃풋이 나올 수 있다.

```swift
func testEmptyListOfUsers() {
    let viewModel = UsersViewModel(users: ["Ed", "Edd", "Eddy"])
    XCTAssert(viewModel.users.count == 0)
    XCTAssertTrue(viewModel.users.count == 0)
    XCTAssertEqual(viewModel.users.count, 0)
}
```
- testEmptyListOfUsers 네이밍에서 볼 수 있듯이 비어있는지 확인하기 위한 함수이다 그런데 값이 (Ed, Edd, Eddy) 존재하기 때문에 테스트는 fail 을 말해준다.
- 그러나 3개의 test 가 다른 오류로 나타내준다.

![](https://i.imgur.com/jp4dDV6.png)

- 3가지 모두 잘못된 것을 확인할수는 있지만 ```XCTAssertEqual``` 을 사용했을 때 보다 정확한 오류를 인지할 수 있다.

### 설정과 분해 (Setup and Teardown)
- 다양한 테스트 메서드에 사용되는 매개변수는 클래스안에서 프로퍼티로 구현될 수 있다.
- 동일한 조건에서 테스트를 실행하기 위해 사용함 (테스트 조건을 유지하기 위해)
- ```setUp()``` : 테스트 메서드의 초기 상태를 설정할때 사용, 테스트 케이스가 실행되기 전에 한번 호출된다.
- ```tearDown()```: 클린업 할때 사용, 테스트 케이스가 실행된 후에 한번 호출된다.
1) XCTest 가 setUp 메서드를 각 테스트 메서드가 시작되기 전에 한번 호출한다. setUp() async throws -> setUpWithError() -> setUp() 
2) XCTest 가 테스트 메서드를 실행한다.


[공식문서 읽어보기- 진행 중 (1/21기준)](https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests)

---
# Unit Test (2)

- Test Double, 의존성 주입 무슨 말인지 이해가 잘 되지 않는다…URLSession 코드 설명 부분이 넘 어려웠다 🥲

## Test Double

- 테스트를 진행하기 어려운 경우 이를 대신하여 테스트를 진행할 수 있도록 만들어주는 객체

- 테스트 더블의 역할

   - 테스트 대상 코드를 격리
   - 속도 개선
   - 예측 불가능한 요소 제거
   - 특수한 상황 시뮬레이션
   - 감춰진 정보 확인
   
- 테스트 더블의 종류 : 역할을 다르지만 명확한 기준으로 구분해서 사용하는 것은 아님!

   - Dummy (가짜의) : 기능이 구현되어 있지 않음. 객체를 전달하기 위한 목적으로 사용

   - Stub (쓰다 남은 부분) : Dummuy가 실제로 동작하는 것처럼 만들어 실제코드를 대신해서 동작해주는 객체

   - Fake : Stub 보다 구체적이지만 코드의 동작을 단순화하여 구현한 객체로 실제 앱의 동작에서는 적합하지 않다.

   - Spy : Stub의 역할을 가지면서 약간의 정보를 기록하는 객체 (호출되었는지, 몇번호출되었는지 등 기록)

   - Mock : 실제 객체와 가장 비슷하게 구현된 수준의 객체, stub이 상태 기반 테스트(State Base Test)라면 mock는 행위 기반 테스트(Behavior Base Test)이다.

      - 상태 기반 테스트: 메서드를 호출하고 그 결과값과 예상값을 비교하여 동작하는 테스트
      - 행위 기반 테스트: 예상되는 행위들에 대한 시나리오를 만들어 놓고 시나리오대로 동작했는지에 대한 여부를 확인

## 의존성 주입 (Dependency Injection, DI)

- UML의 의존과 비슷한 개념 (클래스 내부의 프로퍼티로 받는 경우)
- 외부에서 객체를 생성하여 내부에 주입해주는 것
```swift
class Car {
    var wheel: Wheel

    init(wheel: Wheel) {
        self.wheel = wheel
    }
}

class Wheel {
    var weight = 10
}

let myWheel = Wheel()
let myCar = Car(wheel: myWheel) //myWheel을 만들어서 car에 주입해줌
```

- 사용하는 이유? 
   - 객체간의 결합도를 낮추기 위해
   - 리팩토링이 쉽고 테스트코드 작성이 용이
```swift
class UpDownGame {
    var randomValue: Int = 0
    var tryCount: Int = 0
    var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    ...
}
```

- URLSessionProtocol을 만들어 직접적으로 URLSession을 타입으로 만들지 않고 의존성을 주입할 수 있도록 구현
- Test Double 객체를 실제 URLSession 자리에 바꿔치기 시키면서 테스트를 진행시키기 위함 (결합도를 낮춤)

## TDD (Test-driven development 테스트 주도 개발)

- 매우 짧은 개발 사이클을 반복하는 소프트웨어 개발 프로세스 중 하나
- 요구사항을 검증하는 자동화텐 테스트 케이스 작성 -> 테스트케이스를 통과하기 위한 코드 생성 -> 표준에 맞게 리팩토링
- Unit test는 작성된 메서드에 대해서 테스트를 진행하는 반면, TDD는 반대로 테스트를 작성하면서 코드를 완성시켜나가는 방법론이다.
- 단계별로 안정성을 검사하면서 건물을 짓는다고 생각하면 됨!


- 실패하는 테스트를 작성해보고, 이 테스트를 통과하는 코드를 만들어보고, 테스트 통과를 유지하면서 구조적으로 더 나은 코드를 연구하고 수정하는 것을 반복 결과적으로 더 나은 코드를 만들기 위함

    - Red : 실패하는 테스트를 작성하는 구간
    - Green : 실패한 테스트를 통과하기 위해 최소한의 변경을 하여 테스트를 성공하는 구간
    - Refactor : 테스트의 성공을 유지하면서 코드를 더 나은 방향으로 개선해나가는 구간

- TDD의 장점

   - 더 안전한 코드를 작성할 수 있다.
   - 코드의 재사용성과 의존성에 대해 고민하여 의존성이 낮은 코드를 작성할 수 있다.
   - 유지 보수가 용이하다.
  
- TDD의 단점

   - 개발 속도 (실제 예제를 작성해보니 하나하나 다 확인을 거쳐서 시간이 오래걸리는 이유를 알 것 같다. 그치만 정확한 코드를 작성할 수 있었다.)
