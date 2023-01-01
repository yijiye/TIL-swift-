# Optional 
### 1. Optional 바인딩

> 가장 기본적인 (?) 옵셔널값을 추출하는 방법으로 옵셔널은 값이 있을 수도 있고 없을 수도 있기 때문에 그 값을 안전하게 추출하기 위해 사용된다.


```swift
let numberWord: String? = "one"
if let num = numberWord {
    print("\(num)")
}
```
numberWord 라는 옵셔널 값이 있는데 그 값에는 one 이란 String 값이 있다. 만약 값이 있다면 num 을 출력=> one 출력이 된다.

### 2. nil 병합 연산자


> ?? 두개로 표현하고 a ?? b 라고 가정하면, a 의 값이 없다면 b 로 넘어오게 된다. 
> 순차적으로 값이 있는지를 확인하고 값이 없다면 default로 설정되어 있는 값이 출력된다.


```swift
let gift = [1: "아이폰", 2: "맥북", 3: "에어팟", 4: "애플워치"]
let defaultgift = "갤럭시"

let one = gift[1] ?? gift [6] ?? defaultgift // 1 값이 있으므로 아이폰 출력

let two = gift[6] ?? gift [5] ?? defaultgift // 6도 없고 5도 없으므로 갤럭시 출력

let three = gift[5] ?? gift[3] ?? defaultgift // 5는 없어서 다음으로 넘어가고 3은 있기 때문에 에어팟 출력
```
### 3. Optional 체이닝
> Optional binding 을 반복적으로 사용하는 것을 뜻함.


```swift=
struct Machine {
    var name: String?
    var brand: Brand?
    var function: Function?
}

struct Brand {
    var name: String?
}

struct Function {
    var batttery: Int?
    var version: Int?
    
}

var rijiPhone : Machine = Machine()
//rijiPhone.function = Function(batttery: 100, version: 16)
let rijiPhoneBattery: Int? = rijiPhone.function?.version

```

- 프로퍼티 값을 옵셔널로 갖고 있는 구조체 3개를 만들었다.
- rijiPhone 이라는 Machine 구조체를 갖는 인스턴스를 생성했다.
- Machine -> Funcion -> Version 의 값에 접근을 시도했다.
- 모두 옵셔널이므로 ?를 사용하여 표현했다.
- 현재는 모든 값이 정해져있지 않기 때문에 ```nil```을 반환한다.
- 그러나 // 주석으로 처리한 줄 처럼 값을 입력해준다면 function에 값이 있으니 바인딩 가능하고 version의 값인 16이 출력되게 된다!


<span style="color:blue">순차적으로 옵셔널 바인딩을 할때 하나라도 값이 없다면 nil을 반환하게 된다. 만약 function의 값이 없었다면 version에 값이 있다해도 nil이 반환된다.</span>

### 4. 강제추출

> 값이 있는지 없는지 확인하지 않고 무조건 값이 있다고 가정하며 강제로 추출하는 방법으로 ! 로 표현한다


```swift
var num1: Int? = 1
var num2: Int = num1!
print(num1, num2) // print Optional(1), 1
```

- 1이라는 값이 들어있는 num1 을 num2 에서 강제추출 하였더니 출력 결과 optional (1) 값이 아닌 1 값이 바로 출력되는 것을 확인 할 수 있다.
- 그러나 nil 일때는 오류가 발생하는 문제가 있다.
- 이처럼 강제추출은 되도록 사용하지 않는 것이 좋다.
---

### 🔗 참고
[옵셔널공식문서](https://developer.apple.com/documentation/swift/optional)
[옵셔널체이닝 공식문서](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html)
