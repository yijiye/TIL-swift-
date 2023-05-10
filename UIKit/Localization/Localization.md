# Localization 
> 다양한 언어와 지역을 지원함으로써, 앱의 시장을 확장시켜라

## Overview

현지화는 앱을 여러 언어와 지역으로 번역하고 조정하는 과정이다. 다양한 언어를 구사하고 다른 App Store 지역에서 다운로드하는 사용자에게 액세스를 제공하기 위해 앱을 현지화하여 확장시킬 수 있다.

첫 번째, 언어와 지역에 맞게 문자열을 자동으로 포맷하고 번역하는 API로 코드를 `internationalize`하기
두 번째, 번역의 정확성을 높이기 위해 언어 복수 규칙에 따라 복수 명사와 동사를 포함하는 콘텐츠에 대한 지원을 추가하기

## Translate and adapte your app
Xcode 에서 현지화는 개발자가 지원하는 특정 언어와 지역을 위한 리소스를 특정한다.

- 포함시키고 싶은 언어와 지역의 리소스를 선택하고 프로젝트에 추가
- user-facing 텍스트를 번역하고 특정 문화와 지역에 맞게 자원을 조정하는`localizer`에 파일을 보내고 localization을 Export
- Xcode에서 localized file을 import하고 앱 테스트 하기

앱의 localized 버전을 출시할 때, 앱을 제공하는 특정 지역에 대해 App Store Connect에서 App Store 정보를 현지화할 수도 있다.

---

## WWDC 

### bundle, locale
- iOS13에서 사용자가 시스템 언어와 독립적으로 앱 언어를 설정할 수 있게됨
- 표준 foundation API를 통해 가능하며 코드에서 앱의 언어를 수동으로 설정하면 안된다.
- Locale API는 사용자의 언어 및 지역 설정을 가져오는데는 유용하나 앱 번들이 지원하는 언어와 상관없이 사용자가 선호하는 언어 목록을 반환한다.
- 현재 실행중인 앱의 언어를 가져오려면 bundle API를 사용할 수 있다.
- `bundle.main.preferredLocalizations` 은 사용자가 선호하는 언어와 앱 번들이 지원하는 언어를 모두 고려하여 사용자 선호에 따라 정렬된 앱 번들이 지원하는 언어 목록을 반환한다.
- 다른 설정을 지원하는 목록이 있으면 `Bundle.preferredLocalizations(from:)` 클래스 메서드를 사용하고 이렇게 하면 서버의 세 번째 언어도 고려된다.
- 

#### summary
- 앱 언어 설정을 통해 사용자는 앱의 언어를 선택할 수 있다.
- 설정으로 하는 것은 사용자가 앱의 언어를 전환하는데 가장 좋은 방법이다.
- restoration 을 사용하여 해당 언어가 사용자에게 적용되도록 한다.
- 사용자 지정 또는 서버 측 리소스 로딩을 하는 경우, bundle 또는 locale API를 사용하고 있는지 확인해라

### Xcode localization
- 문자열 추출 프로세스 재설계하여 성능이 개선되었으며 인터페이스 빌더가 더 많을수록 더 큰 효과를 얻는다.
- genstrings나 ibtool을 직접 호출하는 대신 xcodebuild, exportlocalizations, importlocalizations를 사용하여 모든 문자열 파일을 만드는 것이 작업 흐름을 가속화하고 간소화하는데 유용하다.
- NSStringDeviceSpecificRuleType 규칙이 새로 도입되었고, 이는 장치별 문자열에 대한 규칙이다.
- Asset도 localization이 가능하다. Localization 버튼을 클릭하여 asset에 속성을 추가하면 Xcode localization 카탈로그를 내보낼 수 있다.

#### summary
- NSStringDeviceSpecificRuleType 규칙
- Xcode에서 localization을 설정하는 방법
- Asset도 localization이 가능

### UITest
- 앱이 하나 이상의 언어를 지원하는 경우 전체 언어별 문제를 테스트해야하는데 이를 용이하게 할 수 있다.
- Accessibility Identifier 은 고유하고, 안정되고, 어떤 language에서도 테스트 할 수 있다고 보장 할 수 있다.

## 참고
- [Localization 공식문서](https://developer.apple.com/documentation/xcode/localization)
- [Creating Great Localized Experiences with Xcode 11](https://developer.apple.com/videos/play/wwdc2019/403/)
- [WWDC 요약 github](https://github.com/mashup-ios/WWDC/blob/master/Jinha/WWDC2019/Creating-Great-Localized-Experiences-with-Xcode11.md) 
- [Xcode에서 지역화하는 방법](https://delmasong.hashnode.dev/localization-in-ios)
