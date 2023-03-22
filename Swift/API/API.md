# API
> Application Programming Interface
> 어떤 프로그램이 제공하는 기능을 사용할 수 있게 만든 매개체 

- 애플리케이션에서 사용할 수 있도록 OS나 프로그래밍 언어가 제공하는 기능을 제어할 수 있게 만든 인터페이스
- 인터페이스란? 상호 간의 소통을 위해 만들어진 물리적 매개체나 프로토콜을 의미한다.

### API의 역할
클라이언트 - 서버 간(애플리케이션 - 기기) 원활히 통신할 수 있도록 즉, 데이터를 주고받을 수 있도록 중간 매개체 역할을 한다.
(이때 클라이언트는 프론트엔드, 서버는 백엔드를 뜻함)

<img src="https://i.imgur.com/FXKN3j4.png" width="400">

#### 쇼핑 어플에서 사용자가 원하는 정보를 요청하는 경우 예시

<img src="https://i.imgur.com/gu8zoc4.png" width="300">

- 사용자가 원하는 정보를 클릭  
- 클릭하면 클라이언트가 서버에게 원하는 정보를 request(요청) 하게 됨 
- 서버가 json 방식으로 response (응답)한다.


### REST API
> Representational State Transfer, 네트워크 아키텍쳐 스타일
> REST는 HTTP를 잘 활용하기 위한 원칙, REST API는 이 원칙을 준수해 만든 API이다.

- `URL`로 자원을 표현, 자원의 상태에 대한 정의는 `HTTP Method(GET, POST, PUT, DELETE)로 표현`하는 것이 REST의 규칙
- REST의 4가지 속성
   - 서버에 있는 모든 resource(리소스)는 각 리소스당 클라이언트가 바로 접근할 수 있는 고유 URL이 존재
   - 클라이언트가 request(요청)할 때 마다 정보를 주기 때문에 서버에서 session 정보를 보관할 필요가 없다. 
   - HTTP 메소드를 사용해야 한다. (위의 규칙대로)
   - 서비스 내에 하나의 리소스가 주변에 연관된 리소스들과 연결되어 표현이 되어야 한다.



#### REST의 구성 요소
> Resource, method, message 로 구성되어 있음

- REST에서 자원에 접근할 때 URI로 접근 한다. (Resource의 위치를 나타내는 식별자)
- Method는 HTTP의 메소드를 의미 
- Messaage는 HTTP header, body, 응답상태코드로 구성되어 있음


#### Endpoint
> method(GET, POST, DELETE등)는 같은 URL들에 대해서도 다른 요청을 하게끔 구별해주는 항목

----
## 참고 (API)
- https://bentist.tistory.com/37
- https://brunch.co.kr/@hyoi0303/25
- https://float.tistory.com/136
- https://velog.io/@kho5420/Web-API-그리고-EndPoint
- https://dydrlaks.medium.com/rest-api-3e424716bab

