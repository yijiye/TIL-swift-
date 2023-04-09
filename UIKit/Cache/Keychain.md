# Keychain

## Keychain Services
> API Collection
> 사용자를 대신하여 소량의 데이터를 안전하게 저장

### Overview
사용자의 비밀번호, 신용카드 번호, 저장해야한 정보등 간단한 데이터를 안전하게 저장할 수 있다. 또한 사용자가 필요로 하지만 알지 못하는 아이템들도 저장할 수 있다.

<img src="https://i.imgur.com/xbSZlrS.png" width="400">


암호화를 시키는 (점선기준) 단계는 애플에서 해주고 개발자는 그 전에 Data와 그걸 확인하는 Attribute를 만들어 주면 된다!

CRUD (Create, Read, Update, Delete)는 공식문서에서 모두 확인할 수 있다.

- [내가 정리한 CRUD 바로가기](https://github.com/yijiye/TIL-swift-/blob/main/UIKit/Cache/KeychainCRUD.md)

---

## Storing Keys in the Keychain
> 키체인에 암호화 키를 저장하고 액세스 할 수 있다.

### Overview
키체인 서비스 API의 기능을 사용하여 키체인 항목을 추가, 검색, 삭제 또는 수정할 수 있다.

### Create a Query Dictionary
키를 직접 만드는 경우, 키체인에 저장하여 사용할 수 있다. 이를 하기 위해 query dictionary를 만들면 된다.

```swift
let key = <# a key #>
let tag = "com.example.keys.mykey".data(using: .utf8)!
let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                               kSecAttrApplicationTag as String: tag,
                               kSecValueRef as String: key]
```
이 query dictionary는 `kSecClassKey` 값을 사용한다. (인증서와 비밀번호와는 다르게) 또한 나중에 검색할 때 키를 다른 키와 구별할 수 있는 응용 프로그램 태그를 적용한다.

### Store the Item
`SecItemAdd` 메서드를 사용하여 아이템을 저장할 수 있다.

```swift
let status = SecItemAdd(addquery as CFDictionary, nil)
guard status == errSecSuccess else { throw <# an error #> }
```

### Retrieve the Item
키를 얻고 싶다면 같은 application 태그를 사용하는 또 다른 query dictionary를 만들어라.

```swift
let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                               kSecAttrApplicationTag as String: tag,
                               kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                               kSecReturnRef as String: true]
```
위의 새로운 dictionary는 `kSecAttrKeyTypeRSA` 타입의 키여야 한다는 것을 나타낸다. `Asymmetric Key Pair`를 생성하는 예제와 위에서 사용된 태그를 가져야 한다는 것 또한 나타낸다.
마지막 줄에서 키 참조를 반환해야 하는 것을 나타낸다.

```bash
Note
query를 추가하려면 Refine the Search 를 참고
```
`SecItemCopyMatching` 메서드와 함께 이 query 를 사용하여 검색을 실행하고 제공하는 빈 참조를 채운다.

```swift
var item: CFTypeRef?
let status = SecItemCopyMatching(query as CFDictionary, &item)
guard status == errSecSuccess else { throw <# an error #> }
let key = item as! SecKey
```
상태 결과에 표시된 대로 호출이 성공하면, 반환된 키 참조를 사용하여 암호화 작업을 수행할 수 있다.
Objective-C에서는 이런 식으로 검색하는 키를 마친 후, 메모리를 해제해야 한다. 그러나 스위프트에서는 시스템이 객체의 메모리를 관리한다.

### Refine the Search
위의 예제에서는 다른 키 특성으로 검색을 제한하지 않고, 태그와 유형만 일치하면 검색이 성공적으로 반환된다. 따라서 모든 키에 대해 고유한 태그를 사용하지 않는 경우 키를 찾을 수 없게 된다. 왜냐하면 일치하는 첫 번째 키만 반환되기 때문이다. 이를 해결하기 위해 다음과 같은 방법이 있다.

- 검색 범위를 넓힌다.
`kSecMatchLimit` 값을 `kSecMatchLimitAll`로 설정하여 쿼리 딕셔너리에 `kSecMatchLimit` 항목을 추가하면 `SecItemCopyMatching(::)`은 단일 키 참조 대신 키 참조 배열을 생성한다. 이 배열을 검사하여 관심 있는 키를 찾을 수 있다.
- 검색 범위를 좁힌다.
키 크기나 키 클래스와 같이 키를 구별하는 다른 속성이 있는 경우 검색을 실행하기 전에 쿼리 딕셔너리에 해당 항목을 추가한다.
- 처음부터 태그 재사용을 피한다.
특정 태그와 유형(또는 다른 구별 특성)으로 키를 추가하기 전에, 해당 특성을 가진 기존 키체인에서 키를 읽는다. 잠재적인 중복이 발견되면 원래 키를 재사용하고 새로운 키를 만들지 않거나, 다른 태그를 사용하여 새로운 키를 만들거나, 새로운 키를 추가하기 전에 `SecItemDelete(_:)` 함수를 사용하여 이전 키를 삭제할 수 있다.

----

## 참고
- [공식문서-Keychain services](https://developer.apple.com/documentation/security/keychain_services)
- [공식문서-Storing Keys in the Keychain](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain)

