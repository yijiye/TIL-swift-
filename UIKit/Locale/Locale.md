# Locale
> 프레젠테이션을 위한 데이터 포맷에 사용하기 위한 언어적, 문화적, 기술적 관습에 대한 정보.

## Overview
locale은 언어적, 문화적, 기술적 관습과 표준에 대한 정보를 요약한다. locale로 캡슐화된 정보의 예로는 숫자의 소수 구분 기호에 사용되는 기호와 날짜와 시간에 대한 서식 규칙이 있다.

앱은 locale을 사용하여 사용자의 관습과 선호도에 따라 정보를 제공, 포맷 및 해석한다. 데이터 포맷 API는 일반적으로 locale에 적합한 방식으로 데이터를 제시하기 위해 locale을 사용한다.

en-US와 같은 공통 식별자 또는 구성 요소를 지정하여 locale을 만들 수 있다.

## 활용하기
현재 지역에 맞는 Locale을 설정하여 날짜를 변환시켜주도록 구현하였다.

```swift
final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() { }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    
    func convertToFomattedDate(of date: Double) -> String? {
        let date = Date(timeIntervalSince1970: date)
        
        return dateFormatter.string(from: date)
    }
}
```
- Locale의 identifier에 Locale.current.identifier를 설정하면 현재 지역에 맞는 locale이 설정된다.
- 화면에 보여질 dateFormat은 정형화시키지 않고 dateStyle = .long으로 맞춰주어 대한민국 기준, 2023년 4월 28일 로 나타나도록 구현하였다.

### dateStyle 표현
- case none
- case short : 11/23/37
- case medium : Nov 23, 1937
- case long : November 23, 1937
- case full : Tuesday, April 12, 1952 AD

## 참고
- [Locale 공식문서](https://developer.apple.com/documentation/tvml/locale/)
- [Locale 공식문서2](https://developer.apple.com/documentation/foundation/locale)
- [dateStyle 공식문서](https://developer.apple.com/documentation/foundation/dateformatter/1415411-datestyle/)
