## 불필요한 String 사용 줄이기
- 불필요한 String 사용을 줄이기 위해 조건문을 걸어주었고 LLDB로 바이트 수를 확인해보았다.

- LLDB에서 breakpoint를 찍어서 앱을 실행하고 멈춘 후 `maximumLengthOfBytes(using:)` 를 이용하여 확인

<img src="https://i.imgur.com/7udqOoZ.png" width="500">

### 관련 메서드
- [maximumLengthOfBytes(using:)](https://developer.apple.com/documentation/foundation/nsstring/1411611-maximumlengthofbytes)는 StringEncoding을 사용하여 문자열의 최대 바이트 길이를 계산하는 메서드이다.
- [lengthOfBytes(using:)](https://developer.apple.com/documentation/foundation/nsstring/1410710-lengthofbytes)는 StringEncoding을 사용하여 문자열의 실제 바이트 길이를 계산하는 메서드이다.

#### 차이점은?
```swift
let string = "Hello World!"
```
- String을 두가지 메서드를 이용해서 찍어보면 둘다 12로 같은 값이 나오는 것을 확인할 수 있다. 그러나 문자열의 실제 바이트 길이와 최대 바이트 길이가 다를 수 있다. 예를 들어 문자열이 긴 경우에는 바이트 길이가 최대 바이트 길이보다 클 수 있기 때문에, 문자열의 바이트 길이를 계산할때는 `lengthOfBytes(using:)` 메서드를 사용해야 한다.
- `UTF-8` 인코딩은 영어문자는 1바이트, 한글은 3바이트를 사용하기 때문에 문자열의 바이트 길이가 최대 바이트 길이보다 클 수 있다.
- `Unicode`는 `UTF-16` 을 사용하여 인코등하고 각 문자에 대해 2-4바이트를 사용한다. `UTF-8`과 마찬가지로 문자열의 길이가 길어질수록 바이트 길이도 커질 수 있다.
