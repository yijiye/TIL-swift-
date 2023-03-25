# Network에 의존하지 않는 테스트
- URL을 통해 서버에서 직접 data fectching을 하는 경우 `Network` 와 같은 외부 의존성을 가진 객체를 테스트 하기 어려운 경우가 존재한다.
- 만약 Network에 문제가 생기거나 인터넷 연결이 되지 않는 경우 `Test Double`을 이용하여 테스트를 진행할 수 있다.

## Test Double

```bash
Double
1. [중성형 명사] 영화 스턴트맨, 대역자.
2. [중성형 명사] 구별할 수 없을 정도로 닮은 사람.
3. [중성형 명사] 음악 (17-18세기의) 변주곡의 일종.
```
- 네트워크를 하는 객체를 네트워킹 하는 척하는 객체로 바꾸어 테스트를 진행 할 수 있다.

## URLSessionProtocol
- 이 방법은 iOS13 부터 URLSessionDataTask의 init 생성자가 사용되지 않기 때문에 앞으로 사용이 어려워진다. 따라서 나는 URLProtocol 방법으로 구현해보았다. 
- 자세한 내용은 [이 블로그](https://sujinnaljin.medium.com/swift-mock-을-이용한-network-unit-test-하기-a69570defb41)를 참고할 수 있다.

## URLProtocol 
- URLProtocol을 사용해 네트워크 요청을 가로채는 방법이다.

### Networking 과정
<img src="https://i.imgur.com/S3SBVbk.png" width="400">

- URLRequest를 준비
- URLSession Task를 생성하여 `URLSession.shared.dataTask`로 서버와 연결
- Response를 파싱
- View에 업데이트

### URLProtocol을 사용하는 방법

<img src="https://i.imgur.com/KqduQRo.png" width="400">

- URLProtocol은 URL loading system에 대한 확장성을 가지도록 고안되었다.
- URLProtocol을 프로토콜별 URL 데이터의 로딩을 처리하는 추상(abstract) 클래스이다.
- URLProtocol을 URLSession에 의존성을 주입하는 것이 필요하다.
- URLProtocol 소스 코드

```swift
import Foundation

class MockURLProtocol: URLProtocol {
  // request를 받아서 mock response(HTTPURLResponse, Data?)를 넘겨주는 클로저 생성
  static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
  
  // 매개변수로 받는 request를 처리할 수 있는 프로토콜 타입인지 검사하는 함수
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  // Request를 canonical(표준)버전으로 반환하는데,
  // 거의 매개변수로 받은 request를 그래도 반환
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  // test case별로 mock response를 생성하고,
  // URLProtocolClient로 해당 response를 보내는 부분
  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      fatalError()
    }
    
    // request를 매개변수로 전달하여 handler를 호출하고, 반환되는 response와 data, error를 저장
    let (response, data, error) = handler(request)
    
    // 저장한 error를 client에게 전달
    if let error = error {
      client?.urlProtocol(self, didFailWithError: error)
    }
    
    // 저장한 response를 client에게 전달
    if let response = response {
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    // 저장한 data를 client에게 전달
    if let data = data {
      client?.urlProtocol(self, didLoad: data)
    }
    
    // request가 완료되었음을 알린다
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override func stopLoading() {
    // request가 취소되거나 완료되었을 때 호출되는 부분
  }
}
```
- `request`요청을 시작하면 해당 request를 처리할 수 있는 등록되어 있는 프로토콜 클래스가 있는지 검사하고, 있다면 해당 클래스에게 부여한다.
- 여기서 network layer를 가로챌 수 있다.
- URLProtocol을 extension 하여 mock클래스를 생성하고 유닛테스트에 필요한 메서드를 재정의하면 된다.
```swift
import XCTest
@testable import BoxOffice
final class NetworkManagerTest: XCTestCase {
    var sut: NetworkManager!
    var expectation: XCTestExpectation!
    var boxOfficeEndPoint: BoxOfficeEndPoint!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut = NetworkManager(urlSession: urlSession)
        
        boxOfficeEndPoint = BoxOfficeEndPoint.DailyBoxOffice(tagetDate: "20230320", httpMethod: .get)
        
        expectation = expectation(description: "Expectation")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
```
- URLSession에 `URLSession.shared.dataTask(with: urlRequest)` 가 전달되면 실제 서버와 통신을 하게 되지만, `setUpWithError()` 안에서 `urlSession`에 의존성을 주입하면 데이터 통신이 되지 않고 가로채어 테스트가 된다.



## 참고
[공식문서-URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
[WWDC](https://developer.apple.com/videos/play/wwdc2018/417/?time=450)
[leeyoungwoozz-velog](https://velog.io/@leeyoungwoozz/iOS-네트워크에-의존하지-않는-Test)
[how-to-mock-urlsession-using-urlprotocol](https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a)
