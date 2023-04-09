# keychain CRUD

비밀번호를 새로 등록하고, 등록된 비밀번호와 일치하는 번호일 경우 일기장 화면으로 이동하고 일치하지 않으면 이동하지 않도록 keychain을 사용하여 구현하였다.

먼저 시작하기 전 공식문서에서 따르면 메모리에서 앱을 이동할 때 credential을 유지하는 struct을 정의해야한다.

```swift
struct Credentials {
    var username: String
    var password: String
}
```

그런 다음, keychain 접근시 발생할 수 있는 오류 열거형을 정의해야 한다.

```swift
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
```

만약 서버가 필요하다면, 서버도 같이 정의해준다.

```swift
static let server = "www.example.com"
```

### Create

```swift
func createKeychain(credentials: Credentials) throws {
    //열쇠고리만들기
    let account = credentials.username
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: account,
                                kSecValueData as String: password]
        
    //만든 열쇠고리 등록: SecItemAdd()
    let status = SecItemAdd(query as CFDictionary, nil)
        
    //status 값을 통해서 에러처리
    guard status != errSecDuplicateItem else {
        throw KeychainError.duplicateItem
    }
        
    guard status == errSecSuccess else {
        throw KeychainError.unhandledError(status: status)
    }
}
```

현재는 인터넷연결 없이 앱을 구현하여 `kSecClass`를 `kSecClassGenericPassword`로 변경하였다. 따라서 `server`도 필요 없다.

- [Adding a Password to the Keychain](https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain)

### Read

```swift
func readKeychain(account: String) throws -> Credentials {
        //열쇠고리만들기
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecAttrAccount as String: account,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
      
    // 데이터를 가져오기: SecItemCopyMatching()
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
        
    // status 값에 따라서 에러처리를 한다.
    guard status != errSecItemNotFound else {
        throw KeychainError.noPassword
    }      
    guard status == errSecSuccess else {
        throw KeychainError.unhandledError(status: status)
    }
        
    // item 타입을 Credentials 타입으로 변환
    guard let existingItem = item as? [String : Any],
          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: String.Encoding.utf8),
          let account = existingItem[kSecAttrAccount as String] as? String
    else {
        throw KeychainError.unexpectedPasswordData
    }
    let credentials = Credentials(username: account, password: password)
        
    return credentials
}
```
- [Searching for Keychain Items](https://developer.apple.com/documentation/security/keychain_services/keychain_items/searching_for_keychain_items)


### Update

```swift
func updateKeychain(credentials: Credentials) throws {
    //열쇠고리만들기
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: credentials.username]
        
    // update는 업데이트할 Attribute를 요구
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let attributes: [String: Any] = [kSecValueData as String: password]
            
    // 열쇠고리를 만들어 업데이트한다.: SecItemUpdate()
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
    // status를 가지고 에러처리를 해준다.
    guard status != errSecDuplicateItem else {
        throw KeychainError.duplicateItem
    }
    guard status != errSecItemNotFound else {
        throw KeychainError.noPassword
    }   
    guard status == errSecSuccess else {
        throw KeychainError.unhandledError(status: status)
    }
}
```
- [Updating and Deleting Keychain Items](https://developer.apple.com/documentation/security/keychain_services/keychain_items/updating_and_deleting_keychain_items)

### Delete

```swift
func deleteKeychain(account: String) throws {
      //열쇠고리 만들기
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: account]
        
    //열쇠고리를 가지고 삭제: SecItemDelete()
    let status = SecItemDelete(query as CFDictionary)
        
    // status를 가지고 에러처리를 해준다.
    guard status == errSecSuccess || status == errSecItemNotFound else {
        throw KeychainError.unhandledError(status: status)
    }
}
```

