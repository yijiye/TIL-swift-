# URLSession
> HTTP와 HTTPS 기반의 요청을 처리하기 위한 클래스 

<img src="https://i.imgur.com/ZEsgi0t.png" width="400">

- URLSession은 요청을 받고 보내는 역할을 하는 객체로 URLSessionConfiguration을 통해 만들 수 있다.
- URLSession의 task를 만들 수 있는 3가지 유형이 있다.
   - `URLSessionDataTask`
   서버에서 메모리로 데이터를 검색하기 위해 GET 요청에 이 작업을 사용할 수 있다.
   - `URLSessionUploadTask`
   이 작업을 사용하여 POST 또는 PUT 방법을 통해 디스크에서 웹 서비스로 파일을 업로드할 수 있다.
   - `URLSessionDownloadTask`
   이 작업을 사용하여 원격 서비스에서 임시 파일 위치로 파일을 다운로드할 수 있다.

## URL의 요청 메서드
- 디폴트 메서드는 GET으로 설정되어있다. 
- 만약 POST, DELETE 등 다른 Method를 사용하고 싶으면 URLRequest를 사용해서 httpMethod를 지정해주면 된다.

### 예시코드
```swift
func request<element: Decodable>(method: RequestType, url: Requestable, body: Data?, returnType: element.Type, completion: @escaping (Any) -> Void) {
        
        guard let url = URL(string: url.url) else {
            completion(NetworkError.invalidURL)
            return
        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method.description
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
```

- url을 사용하면 request의 매개변수의 method가 있든 없든 GET으로 지정되어있다. (method를 설정해주는 코드가 따로 없어서 무용지물임!)
- 그런데, 다른 메서드를 사용하고 싶다면 주석처리한 부분처럼 request를 사용하여 `httpMethod` 값에 접근하여 바꿔줄 수 있다.
- 그리고 난 후, request를 task의 `dataTask(with: request)`에 넣어주면 원하는 메서드로 설정할 수 있다.

### Apple 공식문서 살펴보기
```swift
func dataTask(with request: URLRequest) -> URLSessionDataTask

func dataTask(with url: URL) -> URLSessionDataTask
```
- dataTask 메서드는 매개변수에 따라 2가지로 나뉜다.
- 공식문서에 따르면 request를 사용하면 메서드를 적용할 수 있다.

```bash
In addition, for HTTP and HTTPS requests, URLRequest includes the HTTP method (GET, POST, and so on) and the HTTP headers.
```

## URLComponents & URLQueryItem

<img src="https://i.imgur.com/FiUFhbf.png" width="400">

<br/>

- http://
Resource(자원)에 접근하기 위한 프로토콜
- Domain 주소
Host/ Domain을 나타냄
- :80 
기본적인 포트는 80으로 생략 가능
- Query Paramether
key와 value로 되어있으며 여러개를 사용할 때 & 기호를 사용한다.

URL의 components를 구성할 때 QueryItem을 이용해서 URL을 만들 수 있다.
```swift
// 1️⃣ URLComponents 이니셜라이저로 baseURL을 먼저 생성한다. 
var urlComponents = URLComponents(string: "https://~~~/api/products")

// 2️⃣ URLQueryItem 이니셜라이저로 query 스트링을 만든다.
let key = URLQueryItem(name: "key", value: "11111")
let itemsPerPage = URLQueryItem(name: "items_per_page", value: "10")

// 3️⃣ baseURL의 queryItems 프로퍼티(배열)에 위에서 만든 파리미터를 set한다.
urlComponents?.queryItems = [pageNo, itemsPerPage]

let url = urlComponents.url 
// 완성된 URL객체 https://~~~/api/products?key=11111&items_per_page=10

```

----
## 참고 (URL)
- https://www.kodeco.com/3244963-urlsession-tutorial-getting-started
- [공식문서-dataTask](https://developer.apple.com/documentation/foundation/urlsession/1407613-datatask)
- https://velog.io/@yeahg_dev/URLRequest-만드는-방법-feat.-HTTP

