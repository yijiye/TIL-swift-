# NSCache 
> 자원이 부족할 때 퇴거될 수 있는 일시적인 키-값 쌍을 일시적으로 저장하는 데 사용하는 변경 가능한 컬렉션.

- 캐시가 시스템 메모리를 너무 많이 사용하지 않도록 하는 다양한 자동 퇴거 정책을 통합한다. 다른 응용 프로그램에서 메모리가 필요한 경우, 이러한 정책은 캐시에서 일부 항목을 제거하여 메모리 공간을 최소화한다.
- 캐시를 직접 잠그지 않고도 다른 스레드에서 캐시의 항목을 추가, 제거 및 쿼리할 수 있다.
- NSMutableDictionary 객체와 달리, 캐시는 그 안에 들어간 키 객체를 복사하지 않는다.

일반적으로 NSCache 객체를 사용하여 생성 비용이 많이 드는 일시적인 데이터로 객체를 일시적으로 저장한다. 이러한 객체를 재사용하면 가치를 다시 계산할 필요가 없기 때문에 성능 이점을 제공할 수 있다. 그러나, 객체는 응용 프로그램에 중요하지 않으며 메모리가 빡빡하면 폐기될 수 있다. 폐기되면, 그들의 가치는 필요할 때 다시 계산되어야 한다.
사용하지 않을 때 폐기할 수 있는 하위 구성 요소가 있는 개체는 `NSDiscardableContent` 프로토콜을 채택하여 캐시 퇴거 동작을 개선할 수 있다. 기본적으로, 캐시의 `NSDiscardableContent` 객체는 콘텐츠가 삭제되면 자동으로 제거되지만, 이 자동 제거 정책은 변경될 수 있다. `NSDiscardableContent `객체를 캐시에 넣으면, 캐시는 제거 시 `discardContentIfPossible()`을 호출한다.

[공식문서-NSCache](https://developer.apple.com/documentation/foundation/nscache)

# URLCache
> URL 요청을 캐시된 응답 객체에 매핑하는 객체.

URLCache 클래스는 `NSURLRequest` 객체를 `CachedURLResponse` 객체에 매핑하여 URL 로드 요청에 대한 응답 캐싱을 구현한다.
인메모리 및 온디스크 캐시를 제공하며, 인메모리 및 온디스크 부분의 크기를 조작할 수 있다. 캐시 데이터가 지속적으로 저장되는 경로를 제어할 수도 있다.
- iOS에서 온디스크 캐시는 시스템이 디스크 공간이 부족할 때 제거될 수 있지만, 앱이 실행되지 않을 때만 제거될 수 있다.

## Thread Safety
iOS 8 이상과 macOS 10.10 이상에서 URLCache는 Thread Safe하다.

URLCache 인스턴스 메서드는 동시에 여러 실행 context에서 안전하게 호출할 수 있지만, `cachedResponse(for:)` 및 `storeCachedResponse(_:for:)`와 같은 메서드는 동일한 요청에 대한 응답을 읽거나 쓰려고 할 때 경쟁 조건을 가지고 있다는 점에 유의해야한다.

URLCache의 서브클래스는 스레드로부터 안전한 방식으로 재정의된 메소드를 구현해야 한다.

## Subclassing Notes
URLCache 클래스는 있는 그대로 사용되지만, 특정 요구 사항이 있을 때 서브클래스할 수 있다. 예를 들어, 캐시된 응답을 선별하거나 보안 또는 기타 이유로 저장 메커니즘을 다시 구현할 수 있다.

이 클래스의 메서드를 재정의할 때, task 매개 변수를 사용하는 메서드는 그렇지 않은 메서드보다 시스템에서 우선이 된다.(선호된다.) 따라서, 다음과 같이 하위 분류할 때 task 기반 메서드를 재정의해야한다.

- Storing responses in the cache 
Override the task-based`storeCachedResponse(_:for:)`, instead of or in addition to the request-based `storeCachedResponse(_:for:)`.

- Getting responses from the cache 
Override `getCachedResponse(for:completionHandler:)`, instead of or in addition to `cachedResponse(for:)`.

- Removing cached responses 
Override the task-based `removeCachedResponse(for:)`, instead of or in addition to the request-based `removeCachedResponse(for:)`.

[공식문서-URLCache](https://developer.apple.com/documentation/foundation/urlcache)

## 소스코드
NSCache, URLCache 구현

```swift
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var fetchFirstImageButton: UIButton!
    @IBOutlet weak var secondImgaView: UIImageView!
    @IBOutlet weak var fetchSecondImageButton: UIButton!
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var resetCacheButton: UIButton!
    
    let networkManager = NetworkManager()
    let firstImageURL = "https://wallpaperaccess.com/download/europe-4k-1369012"
    let secondImageURL = "https://wallpaperaccess.com/download/europe-4k-1318341"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fetchFirstImageButtonTapped(_ sender: UIButton) {
                fetchImage(from: firstImageURL, imageView: firstImageView)
//        downloadImage(from: firstImageURL, imageView: firstImageView)
        
    }
    
    @IBAction func fetchSecondImageButtonTapped(_ sender: UIButton) {
                fetchImage(from: secondImageURL, imageView: secondImgaView)
//        downloadImage(from: secondImageURL, imageView: secondImgaView)
    }
    
    @IBAction func resetImageButtonTapped(_ sender: UIButton) {
        firstImageView.image = nil
        secondImgaView.image = nil
        print("이미지를 초기화합니다.")
    }
    
    @IBAction func resetCachedImageButtonTapped(_ sender: UIButton) {
                ImageCacheManager.shared.remove()
//        URLCache.shared.removeAllCachedResponses()
        print("캐시된 이미지 삭제")
    }
    
    //MARK: NSCache
    private func fetchImage(from imageURL: String, imageView: UIImageView) {
        
        networkManager.loadImage(from: imageURL) { result in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
    //MARK: URLCache
    private func downloadImage(from imageURL: String, imageView: UIImageView) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url)
        
        networkManager.loadURLCachedImage(from: request) { result in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let data):
                
                DispatchQueue.main.async {
                    let cachedImage = UIImage(data: data)
                    imageView.image = cachedImage
                }
                return
            }
        }
    }
}
```
### NSCache에서 @escaping closure의 실행순서
- MARK로 표시해놓은 대로, NetworkManager의 `loadURLCachedImage` 메서드가 실행되면 아래와 같은 순서로 진행된다.
   - task를 생성
   - task 내부 함수가 실행되는 것이 아니라 `URLCache.shared.getCachedResponse`가 실행되면서 `cachedResponse`를 검사하고 있다면 completion에 cachedResponse.data를 전달해서 보낸다.
   - 만약 비어있다면 `task.resume()` 을 실행하여 다시 위로 올라가서 task 내부가 실행된다.
   - data, response를 검사하는 과정에서 `URLCache.shared.storCachedResponse`가 실행되면서 받아온 데이터를 캐싱하고 그 data를 completion에 전달해서 보낸다.

```swift
import Foundation
import UIKit

struct NetworkManager {
    func loadImage(from imageURL: String, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
        guard let url = URL(string: imageURL) else { return }
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if error != nil {
                completion(.failure(.unknown))
                return
            }
            
            if let data = data {
                guard let result = UIImage(data: data) else {
                    completion(.failure(.decode))
                    return
                }
                
                ImageCacheManager.shared.setObject(image: result, urlString: imageURL)
                print("새로운 이미지를 받아왔습니다.")
                completion(.success(result))
            }
            
        }
        
        if let cachedImage = ImageCacheManager.shared.cachedImage(urlString: imageURL) {
            print("캐시된 이미지 불러오기")
            completion(.success(cachedImage))
        } else {
            task.resume()
        }
    }
    
    func loadURLCachedImage(from imageURL: URLRequest, completion: @escaping ((Result<(Data), NetworkError>) -> Void)) {
        
        // MARK: task 생성
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            // MARK: task resume이 되면서 실행
            if error != nil {
                completion(.failure(.unknown))
                return
            }
            
            guard response is HTTPURLResponse else {
                completion(.failure(.response))
                return
            }
            
            if let data = data,
               let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: imageURL)
                print("새로 저장")
                completion(.success(data))
            }
        }
        
        // MARK: task 생성 후 실행되는 코드
        URLCache.shared.getCachedResponse(for: task) { cachedResponse in
            if let cachedResponse = cachedResponse {
                print("캐시된 데이터가 있습니다.")
                completion(.success(cachedResponse.data))
            } else {
                task.resume()
            }
        }
    }
}

enum NetworkError: LocalizedError {
    case unknown
    case decode
    case response
    
    var description: String {
        switch self{
        case .unknown:
            return "Unknown Error"
        case .decode:
            return "Decode Error"
        case .response:
            return "Response Error"
        }
    }
} 
```

```swift
import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    private let storage = NSCache<NSString, UIImage>()
    
    func cachedImage(urlString: String) -> UIImage? {
        let cachedKey = NSString(string: urlString)
        if let cachedImage = storage.object(forKey: cachedKey) {
            return cachedImage
        }
        return nil
    }
    
    func setObject(image: UIImage, urlString: String) {
        let forKey = NSString(string: urlString)
        storage.setObject(image, forKey: forKey)
    }
    
    func remove() {
        storage.removeAllObjects()
    }
}
```

