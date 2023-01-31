# 고차함수
- 다른 함수를 전달인자로 받거나 함수실행의 결과를 함수로 반환하는 함수를 의미한다.
- `forEach`, `map`, `flatMap`, `filter`, `compactMap`, `reduce` 여러종류가 있다.


### forEach 
- for_in 구문처럼 요소의 갯수만큼 반복하게 된다.

```swift
let array = [1,2,3,4,5]
var newArray: [Int] = []

array.forEach{ newArray.append($0) }
print(newArray) // [1,2,3,4,5]
```
- array를 forEach를 사용하여 각 요소들을 반복하여 새로운 newArray에 값을 할당해주면 newArray에 값이 들어가는 것을 확인할 수 있다.
- for_in 구문과의 차이점은 요소의 갯수만큼만 반복할 수 있고 break나 continue와 같은 제어문을 사용할 수 없다.
- return만 사용가능!
[forEach공식문서](https://developer.apple.com/documentation/swift/array/foreach(_:))

### map
- 시퀀스의 요소에 대해 주어진 클로저를 매핑한 결과를 포함하는 배열로 반환

```swift
let array: [String] = ["1","2","3","4","5"]

var integerArray = array.map{ Int($0)! }
print(integerArray) // [1,2,3,4,5] Int

```
- String 배열을 고차함수 map을 이용하여 Int 배열로 반환해주었다. 이때 map은 옵셔널을 반환하므로 옵셔널 바인딩이 필요하다

### compactMap
- map과 같은 역할을 하지만 nil의 값을 제외하고 나머지 배열을 반환해준다.

```swift
let array: [String] = ["1","2","nil","4","5", "nil", "7"]

var integerArray = array.compactMap{ Int($0) }
print(integerArray) // [1,2,4,5,7] Int
```
- 중간의 nil은 제외시키고 나머지 Int 타입의 배열만을 반환해준다.

### flatMap
- 배열 안의 배열 (이중배열)을 flat하게 하나의 배열로 풀어서 반환해준다.
```swift
let array: [[Int?]] = [[1,2,3], [nil,5], [6,nil]]

var integerArray = array.flatMap{ $0 }
print(integerArray) // [Optional(1), Optional(2), Optional(3), nil, Optional(5), Optional(6), nil]
```
- map과 마찬가지로 optional 값을 반환한다.
- 일차원 배열로 반환해줄때 유용하게 사용 가능!
