# Fetching Website Data into Memory
> URL session으로 부터 data task를 만들어 메모리에 직접 데이터 전달 받기

## Overview
- 원격 서버와의 상호작용을 하기 위해 `URLSessionDataTask`를 이용하여 메모리에 데이터를 받을 수 있다. (짧은시간)
- `URLSessionDownloadTask`는 file system에 직접 데이터를 저장할 수 있다. (대용량)
- data task는 web service endpoint (endpoint란, 네트워크 시스템에 연결하는 물리적 디바이스)를 calling 할 때 사용할 수 있다.
- URL 세션 인스턴스를 사용하여 작업을 만든다.
    - 요구 사항이 간단하다면, URLSession 클래스의 공유 인스턴스를 사용
    - delegate callbacks를 통해 transfer와 상호작용 하려면 session을 새로 만들어야 함 (URLSession Configuraion, URLSession Delegate)
    - 세션을 재사용하여 여러 작업을 만들 수 있으므로, 필요한 각 고유한 구성에 대해 세션을 만들고 속성으로 저장할 수 있음.
    - 세션을 만들면 `dataTask()` method 중 하나를 사용하여 data task를 만들 수 있고 `resume()`으로 호출한다.
```bash=
Note
필요 이상의 세션을 만들지 않도록 주의하기
```

## Receive Results with a Completion Handler
> completion handler를 사용하여 data task를 만들어 data를 전달받는 방법

<img src="https://i.imgur.com/UPaYyZj.png" width="500">

- 이 작업은 서버의 응답, 데이터 및 가능한 오류를 completion handler블록에 전달한다.
- completion handler로 data task를 만들기 위해 `dataTask(with:)` 를 호출한다.
   - error 파라미터가 nil 인 것을 입증하기 (그렇지 않으면 transport error가 발생한다.)
   - response 파라미터를 확인하여 상태 코드가 성공을 나타내고 MIME 유형이 예상 값인지 확인하기 (server error, exit 관리)
   - 필요하면 data 인스턴스 사용하기

- URLSession class의 공유 인스턴스를 활용하여 completion handler에 결과 전달하고 data task를 만드는 방법
- 서버를 받을 때 비동기적으로 받는게 좋아서 completion handler를 사용  -> UI업데이트랑 동시에 하기 위해. 동시에 작업을 처리하기 위해 비동기적으로 처리한다.

**Creating a completion handler to receive data-loading results**
```swift
func startLoad() {
    let url = URL(string: "https://www.example.com/")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            self.handleClientError(error)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            self.handleServerError(response)
            return
        }
        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
            let data = data,
            let string = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.webView.loadHTMLString(string, baseURL: url)
            }
        }
    }
    task.resume()
}
```
- 위의 확인해야하는 3가지를 확인한 후, handler가 data를 string으로 convert한다.

```bash
Important
completion handler는 작업을 만드는 것과 다른 GCD에서 호출된다. 따라서, 웹뷰 업데이트와 같이 데이터나 오류를 사용하여 UI를 업데이트하는 모든 작업은 여기에 표시된 것처럼 주 대기열에 명시적으로 배치되어야 한다.
```

## Receive Transfer Details and Results with a Delegate
> 더 높은 수준의 접근을 위해 delegate를 사용하는 방법

<img src="https://i.imgur.com/NqEOy8E.png" width="500">
- 이 방식을 사용하면 전송이 완료되거나 오류로 실패할 때까지 데이터의 일부가 URLSessionDataDelegate의 `urlSession(_:dataTask:didReceive:)` 메소드에 제공된다. Delegate 또한 transfer가 진행됨에 따라 다른 종류의 이벤트를 받는다.
- Delegate 접근을 사용할 때, own URLSession 인스턴스를 만드는 것이 필요하다. (공유 인스턴스를 사용하는 것 대신)
- 아래와 같이 만들 수 있음!

```swift
private lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.waitsForConnectivity = true
    return URLSession(configuration: configuration,
                      delegate: self, delegateQueue: nil)
}()
```
1. 클래스가 하나 이상의 delegate 프로토콜 (URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate 및 URLSessionDownloadDelegate)을 구현한다고 선언하기
2. 그런 다음 이니셜라이저 `init(configuration:delegate:delegateQueue:)`로 URL 세션 인스턴스를 만들기
3. 이 이니셜라이저와 함께 사용되는 구성 인스턴스를 사용자 정의할 수 있다.예를 들어, `waitsForConnectivity`를 true로 설정하는 것이 좋다. 그렇게 하면, 세션은 필요한 연결을 사용할 수 없는 경우 즉시 실패하지 않고 적절한 연결을 기다린다.

### URL session data task의 delegate 사용
> 데이터 작업을 시작하고 deleate callback을 사용하여 수신된 데이터와 오류를 처리하는` startLoad()` 메서드를 사용하는 방법

- 이 목록은 세 가지 delegate callback을 구현한다.
    - `urlSession(_:dataTask:didReceive:completionHandler:)` : 성공적인 HTTP 상태 코드를 가졌는지 MIME type이 text/html or text/plain 인지 검증 (그렇지 않으면 cancel됨)
    - `urlSession(_:dataTask:didReceive:)` : task에 의해 받은 Data 인스턴스를 receivedData라는 buffer에 추가해야함.
    - `urlSession(_:task:didCompleteWithError:)` : 먼저 전송 수준 오류가 발생했는지 확인. 오류가 없으면, receivedData 버퍼를 문자열로 변환하고 webView의 내용으로 설정하려고 시도한다.

```swift
var receivedData: Data?

func startLoad() {
    loadButton.isEnabled = false
    let url = URL(string: "https://www.example.com/")!
    receivedData = Data()
    let task = session.dataTask(with: url)
    task.resume()
}

// delegate methods

func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode),
        let mimeType = response.mimeType,
        mimeType == "text/html" else {
        completionHandler(.cancel)
        return
    }
    completionHandler(.allow)
}

func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    self.receivedData?.append(data)
}

func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    DispatchQueue.main.async {
        self.loadButton.isEnabled = true
        if let error = error {
            handleClientError(error)
        } else if let receivedData = self.receivedData,
            let string = String(data: receivedData, encoding: .utf8) {
            self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
        }
    }
}
```

----
## 참고
[공식문서](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory#2919376)
[예제코드](https://github.com/yijiye/TIL-swift-/tree/main/UIKit/URLSession%20예제코드/urlTest)

----

