# CoreData NSFetchRequest
> Generic Class
> persistent store에서 사용되는 데이터의 검색기준에 대한 설명

## Overview
`NSFetchRequest`는 영구저장소에 저장되는 managed 객체 그룹을 나누고 모으기 위한 기준을 수집한다. fetch request는 entity 설명이나 이름을 반드시포함해야한다.

- `predicate` : 원하는 값을 필터해서 선별해주는 프로퍼티
- `NSSortDescriptor` : sort 해주는 배열. 예를들어서 오름차순, 내림차순 등 순서대로 나타내줄 수 있다.
- `fetchLimit` : request가 반환하는 최대 수. 예를들어 10개로 지정해두면 한번에 10개의 데이터만 반환한다.
- `affectedStores` : request가 접근해야하는 데이터 저장소 확인
- `resultType` : fetch가 managed objects인지 단순 객체 ID인지 확인
- `includesSubentities`, `includePropertyValue`, `returnObjectsAsFaults` : 객체가 그들의 프로퍼티에 완전히 populated되어있는지 여부 확인
- `propertiesToFetch.resultType` : fetch 하기 위한 프로퍼티가 무엇인지 확인
- `fetchOffset` : fetch를 시작할 offset 지정. 예를들어 10이라고 지정한다면 10번째 데이터부터 fetch를 시작한다.
- `includesPendingChanges` : 저장되지 않은 변화가 포함되어 있는지 확인

`Core Data Snippets`에 설명된것 처럼 주어진 함수를 만족시키는 속성 값과 프로퍼티 값을 가져올 수도 있다.
`NSFetchRequest` 객체와 `fetch(:)`, `count(for:)` 메서드를 같이 사용할 수 있다.

관리 객체 모델에서 `fetch` 요청을 미리 정의하는 경우가 많다. `NSManagedObjectModel`은 이름으로 저장된 `fetch`요청을 검색하는 API를 제공한다. 저장된 `fetch` 요청은 변수 대체를 위한 placeholder를 포함할 수 있으므로 나중에 완료하기 위한 template 역할을 한다. 따라서 fetch request template을 가져오면 런타임에 대체되는 변수로 쿼리를 미리 정의할 수 있다.

## pagination 구현
CoreData를 꺼내올때 10개씩 fetch 하고 스크롤이 바닥에 닿으면 다음 10개를 가져오도록 구현했다.

- CoreData fetch

```swift
func readTenPiecesOfData() -> [GyroEntity]? {
    guard let context = context else { return nil }
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: GyroEntity.key)
    request.fetchOffset = currentOffset
    currentOffset += 10
    request.fetchLimit = 10
        
    do {
        let data = try context.fetch(request)
        return data as? [GyroEntity]
    } catch {
        return nil
    }
}
```
`fetchOffset` 을 `currentOffset` 전역변수로 두고 꺼내올 때마다 `currentOffset`을 +10을 해주었다.
이 과정에 없으니 항상 같은 자리에서 fetch가 되는 문제가 있었다.
그리고 `fetchLimit`을 10으로 주어 10개씩만 꺼내지도록 정의했다.

- ViewModel

```swift
@Published var isNoMoreData: Bool = false
...
func readAll() {
    guard let data = CoreDataManager.shared.readTenPiecesOfData() else { return }
    isNoMoreData = data.isEmpty
    gyroData.append(contentsOf: data)
}
```
    
`isNoMoreData`라는 `@Published` 프로퍼티를 만들어 데이터가 더이상 없는 경우를 생각하였다. 
`data.isEmpty`인 경우 `isNoMoreData`가 성립된다.

- ViewController

```swift
private var isPaging: Bool = false
private var isNoMoreData: Bool = false
...
private func bind() 
    viewModel.$gyroData
        .receive(on: DispatchQueue.main)
        .sink { [weak self] data in
            self?.createSnapshot(data)
            self?.isPaging = false
            self?.configureLoadingStatus()
        }
        .store(in: &cancellables)
    viewModel.$isNoMoreData
        .sink { [weak self] bool in
            self?.isNoMoreData = bool
        }
        .store(in: &cancellables)
}
```

실제 데이터를 불러와서 스냅샷을 만들고 `isPaging` 변수를 생성해서 페이지네이션을 확인하는 bool 타입을 정의했다. 그리고 `isNoMoreData`를 구독하여 VC에 값을 입력해주고 이 bind 메서드를 `viewDidLoad`에서 호출하였다.

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if gyroDataTableView.contentOffset.y > (gyroDataTableView.contentSize.height - gyroDataTableView.bounds.size.height) {
        if !isNoMoreData && !isPaging {
            requestMorePage()
        }
    }
}
    
private func requestMorePage() {
    isPaging = true
    configureLoadingStatus()
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        self?.viewModel.readAll()
    }
}
    
private func configureLoadingStatus() {
    loadingIndicatorView.isHidden = !isPaging
        
    if isPaging {
        loadingIndicatorView.startAnimating()
    } else {
        loadingIndicatorView.stopAnimating()
    }
}
```
`UITableViewDelegate`의 메서드인 `scrollViewDidScroll`을 활용하여 스크롤이 바닥에 닿는 지점을 찾아 닿을 때, `requestMorePage()` 메서드를 실행하였다. 
이 메서드는 메인 스레드에서 뷰모델의 `readAll()` 메서드를 호출하고 아까 `fetchLimit`과 `fetchOffset`을 설정해준대로 호출이 된다.
그리고 1.5초의 delay 동안 로딩뷰가 보여지도록 설정하였다.

## 참고
- [Apple Developer - NSFetchRequest](https://developer.apple.com/documentation/coredata/nsfetchrequest)
- [chillog.page](https://chillog.page/149)
