# fmod(_:_:)

00:00:000 분, 초, 밀리초 포맷으로 실시간을 띄워주기 위해 fmod()를 활용하여 계산식을 구현하였다.
이 메서드의 기능은 첫번째 인자를 두번째 인자로 나눈 값의 나머지를 반환해준다. 

<img src="https://i.imgur.com/1hxxk0d.png" width="400">

<br/>

- 예시 코드

```swift
let result = fmod(50.5, 1.7) // 50.5/1.7 = 29 + 나머지, 50.5-49.3(29x1.7) = 1.2
print(result)

/*
 x < y : x 값이 반환
 x >= y : x/y, 몫을 뺀 나머지 (나눠지지 않는 값을 반환) 

예시 ===> 50.5 / 1.7 = 몫(29) + 나머지(1.2)
 */

let timeInterval = 57900.05 // 초
/*
 57900.05 초를 시, 분, 초, 밀리초로 환산하는 계산식
 */

let hour = (Int)(fmod((timeInterval/60/60), 12)) // 1시간 = 3600 초

/*
 시간 12로 하면 => 4시
 시간 24로 하면 => 16시
 */

let minute = (Int)(fmod((timeInterval/60), 60)) // 1400초 = 23분
let second = (Int)(fmod(timeInterval, 60)) // 20초

let milliSecond = (Int)((timeInterval - floor(timeInterval))*1000) // 050

```

[공식문서](https://developer.apple.com/documentation/accelerate/3804649-fmod)
