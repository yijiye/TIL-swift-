# CoreData Transformable

coreData에 저장하는 Entity의 attribute는 기본 타입과 따로 지정해주는 타입이 올 수 있다. 기본 타입의 경우 특별히 신경쓸건 없지만 따로 지정해주는 타입 즉, `transformable`은 따로 구현해주어야 하는 필수구현이 몇가지 있다. 
이것들을 한번 알아보자!

<img src="https://i.imgur.com/XbZpfo7.png" width="600">

### NSObject
> 대부분의 Objective-C 클래스 계층의 루트 클래스

가장 먼저, transformable 타입은 CoreData에 저장될 수 있는 객체로 따로 관리해야한다. 그리고 그 객체는 NSObject를 상속받는다. 이를 통해 객체를 식별할 수 있다.

```swift
final class Movie: NSObject {
    var audienceAccumulation: String?
    var audienceChange: String?
    ...
}
```
### NSSecureCoding

transformable 타입은 transformer를 통해 변환되는데, 이때 NSSecureCoding을 채택한 객체만 오도록 제한을 둔다. (자세한건 뒤에 설명!) 이렇게 제한을 두는 용도의 protocol로, 다른 타입의 객체가 올 수 없어 데이터 보완을 강화할 수 있다.

```swift
extension Movie: NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    ...
}
```

### required convenience init?(coder: NSCoder)

저장된 데이터를 불러오기 위해 `NSCoder`를 사용하여 decoding 한다.
따라서 저장된 객체를 불러올 때 호출된다. 

```swift
required convenience init?(coder: NSCoder) {
        self.init()
        self.audienceAccumulation = coder.decodeObject(forKey: "audienceAccumulation") as? String
        self.audienceChange = coder.decodeObject(forKey: "audienceChange") as? String
    ...
}
```

### func encode(with coder: NSCoder) 

데이터를 저장하기 위해 `NSCoder`를 사용하여 encoding 한다.
따라서 데이터를 저장할 때 호출된다.

```swift
func encode(with coder: NSCoder) {
        coder.encode(audienceAccumulation, forKey: "audienceAccumulation")
        coder.encode(audienceChange, forKey: "audienceChange")
    ...
}
```

### Transformer

위에서 언급했듯이, transformable 타입은 CoreData에 저장되려면 transformer를 통해 변환되어 인코딩, 디코딩 과정을 거쳐 데이터를 저장 및 가져오기를 할 수 있게 된다. 이때 지정해주어야 하는 transformer는 아래와 같이 구현할 수 있다.


```swift
final class MovieAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        [Movies.self]
    }
    
    static func register() {
        let className = String(describing: MovieAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = MovieAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
```

- `NSSecureUnarchiveFromDataTransformer`: 
CoreData에서 기본적으로 저장 가능한 타입 외에, 사용자 정의 타입을 저장하고자 할 때 디코딩, 인코딩이 가능하게 하기 위해 사용된다.

- `allowedTopLevelClasses`: 
이 프로퍼티에 저장된 타입은 디코딩, 인코딩이 가능하게(transformable) 된다.
`NSSecureUnarchiveFromDataTransformer`의 `allowedTopLevelClasses`에 지정된 타입은 `NSSecureCoding`을 채택한 타입만 허용되도록 해 보안을 강화할 수 있다.

- `register()`:
attribute에 적용된 transformer는 코어 데이터의 persistentContainer가 초기화되기 전에 앱에 먼저 등록이 되어야한다.
따라서 AppDelegate에서 다음과 같이 등록했다. 
(가장 먼저 등록해주지 않으면 오류가 발생하므로 메서드 상단에 구현해주어야 한다.)

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         MovieAttributeTransformer.register()
         ...
     }
}
```

---

## 참고
- [AppleDevelopment-NSSecureCoding](https://developer.apple.com/documentation/foundation/nssecurecoding/)
- [AppleDevelopment-NSCoding](https://developer.apple.com/documentation/foundation/nscoding/) 
- [AppleDevelopment-NSSecureUnarchiveFromDataTransformer](https://developer.apple.com/documentation/foundation/nssecureunarchivefromdatatransformer/)
