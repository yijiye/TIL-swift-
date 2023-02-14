# JSON
> Javascript Object Notation, 데이터를 교환하기 위한 형식

- 메모리 상에 0과 1로 존재하는 객체를 하드디스크에 저장하고 다시 불러오거나 다른 시스템으로 전달할 때, 약속된 표준의 0과 1로 변환하는 형식
- JSON은 사람도 읽을 수 있고, 컴퓨터도 읽을 수 있다 (문자열로 표현)
- 기본적으로 키와 값으로 이루어진 딕셔너리 타입이다
- 저장되고 전송되는 Data 타입을 사용
- 만약, JSON 상태로 하드디스크에 저장되어 있다가 같은 맥에서 불러오는 경우 저장되기 전 상태와 같은 상태의 0과 1로 불려온다

## 표현
- {} 객체 (딕셔너리)
- [] 배열
- "" 문자열
- 문자열 외 : 숫자
- [{}] : 배열 안에 객체가 있는 경우로 여러 객체가 담긴 배열을 의미


## JSONDecoder
> JSON 객체에서 데이터 유형의 인스턴스를 디코딩 하는 객체

- 디코딩 : 사람의 언어로 변환하는 과정/ 인코딩의 반대

### Codable
> 변환할 수 있는 protocol

```swift
typealias Codable = Decodable + Encodable
```
- `Codable`을 타입이나 제네릭으로 사용할 때, 두 protocol이 준수하는 타입은 서로 일치한다.

#### Decodable
- External representation -> itself 로 decoding

#### Encodable
- itself -> External representation 으로 encoding

#### JSON 예시
```swift
struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

let json = """
{
    "name": "Durian",
    "points": 600,
    "description": "A fruit with a distinctive scent."
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let product = try decoder.decode(GroceryProduct.self, from: json)

print(product.name) // Prints "Durian"
```

## Using JSON with Custom type

- 다른 앱, 서비스 및 파일에서 보내거나 받는 JSON 데이터는 다양한 모양과 구조로 제공될 수 있다.

```swift
struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}
```
- `GroceryProduct` 라는 데이터 타입 구현

### 다른 JSON 형식에서 해당 유형의 인스턴스를 구성하는 방법

**1. Read Data from Arrays**
- swift의 표현형 시스템을 사용하여 동일하게 구조화된 객체의 컬렉션을 수동으로 반복하지 않기
- 값으로 배열을 사용하여 JSON으로 작업하는 방법은 아래와 같다.

```swift
[
    {
        "name": "Banana",
        "points": 200,
        "description": "A banana grown in Ecuador."
    }
]
```

**2. Change Key Name**
- 이름에 관계없이 JSON의 data 를 custom type으로 mapping 하는 방법
```swift
{
    "product_name": "Banana",
    "product_cost": 200,
    "description": "A banana grown in Ecuador."
}

```
- JSON의 product_name -> GroceryProduct name으로 변환
- 이때 API 가이드라인을 따라 네이밍을 한다.

**3. Access Nested Data**
- 코드 내에서 필요하지 않는 JSON 데이터, 구조 무시하는 방법
- 중첩 타입을 사용하여 필요없는 부분은 skip 하고 원한느 부분만 사용할 수 있다.

```swift
[
    {
        "name": "Home Town Market",
        "aisles": [
            {
                "name": "Produce",
                "shelves": [
                    {
                        "name": "Discount Produce",
                        "product": {
                            "name": "Banana",
                            "points": 200,
                            "description": "A banana that's perfectly ripe."
                        }
                    }
                ]
            }
        ]
    }
]
```

**4. Merge Data at Different Depths**
- `Encodable` 및 `Decodable`에서 프로토콜 요구 사항의 사용자 지정 구현을 작성하여 JSON 구조의 다른 depths 에서 데이터를 결합하거나 분리하는 방법
```swift
{
    "Banana": {
        "points": 200,
        "description": "A banana grown in Ecuador."
    }
}
```

## 참고
[Using JSON with Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types)
[JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder)
[Codable](https://developer.apple.com/documentation/swift/codable)

