# Double
> Floating-Point Numbers : 64-bit 를 대표한다.

## nan
> not a number 숫자가 존재하지 않는다

```swift
let x = 1.21
// x > Double.nan == false
// x < Double.nan == false
// x == Double.nan == false
```
- 1.21 이라는 숫자를 .nan 을 사용하여 비교하고자 하면 모두 false가 반환된다. 그 이유는 nan은 숫자가 존재하지 않기때문에 비교자체가 불가능하다.
- 따라서 nan을 비교하기 위해서는 아래와 같이 표현할 수 있다.

```swift
let y = x + Double.nan
print(y == Double.nan)
// Prints "false"
print(y.isNaN)
// Prints "true"
```
- bool 타입인 isNaN을 사용하여 비교가능하다!



## 참고
[nan공식문서](https://developer.apple.com/documentation/swift/floatingpoint/nan) </br>

