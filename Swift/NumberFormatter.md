# NumberFormatter
> 숫자 값을 텍스트 표현으로 변환하거나 텍스트 표현을 숫자 값으로 변환해주는 formatter

<img src ="https://i.imgur.com/oIW9GPT.png" width ="400">

- NumberFormatter의 인스턴스는 `NSNumber` 객체를 포함하는 셀의 텍스트 representation 을 포맷하고 숫자 값의 텍스트 표현을 `NSNumber` 객체로 변환합니다.
- Representationdms Int, Float, Double 을 포함하고 Float 과 Double은 특정 소수점 위치로 포맷될 수 있다.
- 또한 NumberFormatter객체는 숫자 값이 수용할 수 있는 범위를 적용할 수 있다.

##  usesSignificantDigits

```swift
var numberFormatter = NumberFormatter()
numberFormatter.usesSignificantDigits = true
numberFormatter.minimumSignificantDigits = 4

numberFormatter.string(from: 123) // 123.0
numberFormatter.string(from: 123.45) // 123.45
numberFormatter.string(from: 100.23) // 100.23
numberFormatter.string(from: 1.2300) // 1.230
numberFormatter.string(from: 0.000123) // 0.0001230

numberFormatter.maximumSignificantDigits = 4

numberFormatter.string(from: 12345) // 12340
numberFormatter.string(from: 123.456) // 123.5
numberFormatter.string(from: 100.234) // 100.2
numberFormatter.string(from: 1.230) // 1.23
numberFormatter.string(from: 0.00012345) // 0.0001234
```
- `useSignificantDigits` 유효 숫자 자릿수를 사용하는 기능이다. `true`면 유효숫자 자릿수를 제한하고 `false`면 기본 소수점 표현 방식을 사용한다.
- minimumSignificantDigits (default는 1)
- maximumSignificnatDigits (default는 6) : 1보다 작은 은 무시됨


## minimumIntergerDigits
- Int 표현을 할때, 최소한으로 표시할 자릿수를 제한할 때 사용
- dafault는 0이고, 만약 2라고 설정한다면 1은 01로 표시된다.
- Int를 같은 길이의 표현으로 사용하고자 할때 유용하다.

## maximumIntergerDigits
- Int 표현을 할때, 최대한으로 표시할 자릿수를 나타낼 때 사용
- default는 42이고, 만약 3으로 설정한다면 12345 는 345로 표시된다.

## mininumFractionDigits
- 최소한으로 표현할 소수점의 자릿수를 나타낼 때 사용, default는 0이다

```swift
var numberFormatter = NumberFormatter()
numberFormatter.minimumFractionDigits = 0 // default
numberFormatter.string(from: 123.456) // 123

//소수점 5번째 자리까지 표현하기
numberFormatter.minimumFractionDigits = 5
numberFormatter.string(from: 123.456) // 123.45600 
numberFormatter.string(from: 123.456789) // 123.45679 6번째에서 반올림
```

## maximumFractionDigits
- 최대한으로 표현할 소수점의 자릿수를 나타낼때 사용, default는 0이다.

```swift
var numberFormatter = NumberFormatter()

numberFormatter.maximumFractionDigits = 0 // default
numberFormatter.string(from: 123.456) // 123

// 소수점 최대 세 자릿수 까지만 표현하기
numberFormatter.maximumFractionDigits = 3
numberFormatter.string(from: 123.456789) // 123.457
numberFormatter.string(from: 0.03456) // 0.035
```

[🍎공식문서]https://developer.apple.com/documentation/foundation/numberformatter
