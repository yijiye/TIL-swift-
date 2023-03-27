# Cache, URLCache, NSCache

## 캐시란 무엇이고 어떤 역할일까?
- 데이터나 값을 미리 복사해 놓는 임시 장소
- 원래 데이터를 접근하는 시간이 오래 걸리는 경우나 값을 다시 계산하는 시간을 절약하고 싶은 경우 사용한다.
- CPU <-> RAM <-> Hard Disk
   - CPU : 중앙처리장치, 연산을 처리하는 곳
   - RAM : 주기억장치 , 휘발성, 속도가 빠름
   - Hard Disk : 보조기억장치, 비휘발성, 속도가 느림
- CPU 성능이 좋아도, RAM hard disk에서 데이터를 못가져와서 CPU가 놀게된다. 이를 방지하기 위해 캐시의 개념이 도입되었음.


## 캐시의 구분
### 위치에 따른 구분

- 클라이언트 측 캐시(Client-side Cache) : 클라이언트의 local에 저장할 수 있는 캐시
- 서버 측 캐시(Server-side Cache) : 여러 클라이언트의 요청에 대해 저장할 수 있는 캐시

### 저장 대상에 따른 구분

- 메모리 캐시
- 디스크 캐시
- 네트워크 캐시

### 업데이트 방식에 따른 구분
- Write-Through : 데이터베이스에 변경사항을 반영한 후, 캐시를 업데이트합니다.
- Write-Back : 변경사항을 먼저 캐시에 업데이트하고, 일정 시간이 지나면 변경사항을 데이터베이스에 업데이트합니다.


## 캐시의 저장 위치
- 메모리, 디스크, 네트워크


|메모리 캐싱|디스크 캐싱|
|:--:|:--:|
|애플리케이션이 종료되어 메모리에서 해제되면 사라진다.(휘발성)|애플리케이션을 종료해도 사라지지 않는다.(비휘발성)|
|디스크 캐싱에 비해 메모리가 작다|메모리 캐싱에 비해 메모리가 크다|
|CPU의 L1 cache 저장|HDD에 저장되며 접근하는 시간을 개선하기 위한 RAM에 저장하는 기법도 있다|
|속도가 빠르다|메모리 캐싱에 비해 상대적으로 느리다|

### 네트워크 캐시
- 네트워크 캐시는 인터넷에서 자주 사용되며 원격 서버에서 가져온 데이터를 로컬에 저장하여 성능을 개선한다.

## 캐시를 구현할 때 고려해야 하는 캐시 운용 정책에는 어떤것들이 있을까?

- 적중률과 성능 : 적절한 캐시 크기를 설정하고, 자주 사용되는 데이터를 우선으로 저장하여 적중률이 높인다.
- 만료 정책 : 데이터의 유효기간을 설정하여 오래된 데이터를 자동으로 삭제한다.
- 캐시 제거 정책 : 캐시가 너무 많은 메모리나 디스크를 사용하면 다른 작업에 영향을 끼칠 수 있어 일정 기간이나 메모리/ 디스크 사용량에 따라 캐시를 제거한다.
- 캐시 검증 정책 : 원본 데이터가 변경되면 캐시도 업데이트 되어야 하므로 캐시를 주기적으로 업데이트 한다.
- 동시성 제어 : 여러 사용자가 동시에 캐시를 업데이트 하면 충돌이 발생할 수 있으므로, 동시성 제어 방법을 구축해야한다.
- 실패 처리 : 캐시에 데이터가 없거나 오류가 발생할 경우, 오류 처리 방법을 고려해야한다.

### URLCache기본 캐시 정책

|이름|기능|
|:--:|:--:|
|case allowed|URLCache제한 없이 보관 이 가능합니다.|
|case allowedInMemoryOnly|저장 URLCache이 허용됩니다. 그러나 스토리지는 메모리로만 제한되어야 합니다.|
|case notAllowed|URLCache메모리나 디스크에 저장하는 것은 어떤 방식으로도 허용되지 않습니다.|

- Reference: [URLCache.StoragePolicy](https://developer.apple.com/documentation/foundation/urlcache/storagepolicy)

### URLRequest 기본 캐시 정책

```bash
typealias URLRequest.CachePolicy = NSURLRequest.CachePolicy
```

|이름|기능|
|:--:|:--:|
|case useProtocolCachePolicy|특정 URL 로드 요청에 대해 프로토콜 구현에 정의된 캐싱 로직을 사용해야한다.|
|case reloadIgnoringLocalCacheData|URL 로드는 원본 소스에서만 로드 되어야 한다.|
|case reloadIgnoringLocalAndRemoteCacheData|local 캐시 데이터를 무시하고 프로토콜이 허용하는 한 프록시와 다른 중간 매개체가 캐시를 무시하도록 한다.|
|case returnCacheDataElseLoad|캐시 데이터를 사용하고 데이터가 없는 경우에만 원본소스에서 로드한다.|
|case returnCacheDataDontLoad|사용 기간이나 만료 날짜에 관계없이 기존 캐시 데이터를 사용하고 캐시된 데이터가 없으면 실패합니다.|
|case reloadRevalidatingCacheData|유효성을 검사할 수 있는 경우 캐시 데이터를 사용하고 그렇지 않은 경우에는 origin에서 load한다.|

- Reference: [URLRequest.CachePolicy](https://developer.apple.com/documentation/foundation/urlrequest/cachepolicy)
- Reference: [NSURLRequest.CachePolicy](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy)


## NSCache와 URLCache의 차이점

- NSCache : 자원이 부족할 때 퇴거될 수 있는 일시적인 키-값 쌍을 일시적으로 저장하는 데 사용하는 변경 가능한 컬렉션.
- URLCache : URL 요청을 캐시된 응답 객체에 매핑하는 객체.

| NSCache | URLCache |
| :---: | :---: |
| 메모리 캐싱 | 메모리 캐싱 </br> 디스크 캐싱 |
| 데이터의 크기에 비례하는 크기를 할당 (공식문서에서 찾아봐야함) | 메모리/디스크 내 크기를 정의할 수 있음 |


### NSCache 공식문서
> 자원이 부족할 때 퇴거될 수 있는 일시적인 키-값 쌍을 일시적으로 저장하는 데 사용하는 변경 가능한 컬렉션.

- 캐시가 시스템 메모리를 너무 많이 사용하지 않도록 하는 다양한 자동 퇴거 정책을 통합한다. 다른 응용 프로그램에서 메모리가 필요한 경우, 이러한 정책은 캐시에서 일부 항목을 제거하여 메모리 공간을 최소화한다.
- 캐시를 직접 잠그지 않고도 다른 스레드에서 캐시의 항목을 추가, 제거 및 쿼리할 수 있다.
- NSMutableDictionary 객체와 달리, 캐시는 그 안에 들어간 키 객체를 복사하지 않는다.

일반적으로 NSCache 객체를 사용하여 생성 비용이 많이 드는 일시적인 데이터로 객체를 일시적으로 저장한다. 이러한 객체를 재사용하면 가치를 다시 계산할 필요가 없기 때문에 성능 이점을 제공할 수 있다. 그러나, 객체는 응용 프로그램에 중요하지 않으며 메모리가 빡빡하면 폐기될 수 있다. 폐기되면, 그들의 가치는 필요할 때 다시 계산되어야 한다.
사용하지 않을 때 폐기할 수 있는 하위 구성 요소가 있는 개체는 `NSDiscardableContent` 프로토콜을 채택하여 캐시 퇴거 동작을 개선할 수 있다. 기본적으로, 캐시의 `NSDiscardableContent` 객체는 콘텐츠가 삭제되면 자동으로 제거되지만, 이 자동 제거 정책은 변경될 수 있다. `NSDiscardableContent `객체를 캐시에 넣으면, 캐시는 제거 시 `discardContentIfPossible()`을 호출한다.

[공식문서-NSCache](https://developer.apple.com/documentation/foundation/nscache)
