# UICollectionDiffableDataSource
> 데이터를 관리하고 collectionView를 위한 셀을 제공하는 데 사용하는 객체.

## Overview
컬렉션 뷰의 데이터와 UI에 대한 업데이트를 관리하는 데 필요한 동작을 제공한다.
collectionView에 data를 채우기 위한 스텝은 아래와 같다.
  1. collectionView에 diffableDataSource를 연결하기
  2. collectionView 구성을 위한 cell provider 구현하기
  3. data의 현재 상태 생성하기
  4. UI에 data 보여주기
 
먼저 `init(collectionView:cellProvider:)` 이니셜라이저를 이용하여 diffableDataSource를 만들어(**step#1**) 해당 데이터 소스와 연결하고 싶은 collectionView와 UI에 데이터를 표시하기 위해 각 cell을 구성하는 cell provider를 전달해야한다.(**step#2**)

**공식문서코드**
```swift
dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView) {
    (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) -> UICollectionViewCell? in
    // Configure and return cell.
}
```

**BoxOffice코드**
```swift
final class DailyBoxOfficeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOffice.BoxOfficeResult.Movie>
    private var movieDataSource: DataSource?
    
    .....
     func setupDataSource() {
        movieDataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyBoxOfficeCollectionViewCell.reuseIdentifier,
                for: indexPath) as? DailyBoxOfficeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: itemIdentifier)
            
            return cell
        }
    }
```
그런 다음, 데이터의 현재 상태를 생성하고 스냅샷을 구성하고 적용하여 UI에 데이터를 표시한다.(**step#3, #4**)

```bash
✅ Important 
diffableDataSource로 구성한 후에 collectionView에 있는 dataSource를 변경하지 말기
처음 구성한 후에 collectionView에 새로운 데이터 소스가 필요하다면 새로운 collectionView와 diffableDataSourcef를 만들고 구성해라
```

## NSDiffableDataSourceSnapshot
> 특정 시점의 뷰에서 데이터 상태의 표현.

### Overview
DiffableDataSource는 collectionView(또는 tableView)에 데이터를 제공하기 위해 `snapshot`을 사용한다.
`snapshot`은 view에 보여지는 데이터의 초기 상태를 구현하고, 데이터의 변화를 반영한다.
`snapshot`의 데이터는 개발자가 결정한 순서대로 표시하려는 section과 item으로 구성되어 있으며 section과 item을 추가, 삭제 또는 이동하여 표시할 것을 구성한다.

```bash
✅ Important 
section과 item은 Hashable 프로토콜을 준수하는 identifier가 필요한다. Int, String 또는 UUID와 같은 빌트인 타입이거나 struct, enum 값타입을 활용할 수 있다.
만약 class를 사용하고 싶다면 NSObject의 서브클래스여야 한다.
```
`snapshot`을 사용하여 view에 데이터를 띄워주는 과정은 아래와 같다.
  1. `snapshot`을 만들고 표시하려는 데이터의 상태로 채우기
  2. UI에 변화를 반영하기 위해 `snapshot`을 적용하기

`snapshot`을 만들고 구현하는 방법은 아래와 같다.
 - 빈 `snapshot`을 만들고 section과 item을 추가하기
 - diffableDataSource의 snapshot() 메서드를 호출하여 현재 `snapshot`을 만들고 띄워주고 싶은 데이터의 새로운 상태를 반영하여 `snapshot`을 수정하기

비어있는 `snapshot`을 만들고 3개의 item을 가지고 있는 하나의 section으로 채우는 예시. 그리고 그 코드를 `snapshot`에 적용하고 이전 상태와 새로운 상태 사이를 UI에 업데이트 하도록 구현한 예시는 아래와 같다.

**공식문서코드**
```swift
// Create a snapshot.
var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()        

// Populate the snapshot.
snapshot.appendSections([0])
snapshot.appendItems([UUID(), UUID(), UUID()])

// Apply the snapshot.
dataSource.apply(snapshot, animatingDifferences: true)
```
**BoxOffice코드**
```swift
// snapshot data의 section에 해당하는 부분을 enum으로 구현
fileprivate enum Section: Hashable {
    case main
}

.....

func setupSnapshot() {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DailyBoxOffice.BoxOfficeResult.Movie>
    
    // snapshot()을 호출하여 현재의 스냅샷을 구현
    var snapshot = Snapshot()
    
    // 스냅샷에 데이터를 붙여 업데이트
    snapshot.appendSections([.main])
    if let dailyBoxOffice = self.dailyBoxOffice {
            snapshot.appendItems(dailyBoxOffice.boxOfficeResult.boxOfficeList, toSection: .main)
        }
    
    // 스냅샷에 적용
    movieDataSource?.apply(snapshot, animatingDifferences: true)
}
```

**UI화면에 띄우기 위해 GCD 메인스레드에 처리**
```swift
private func fetchDailyBoxOfficeData() {
    guard let endPoint = boxOfficeEndPoint else { return }
        
    networkManager.request(endPoint: endPoint, returnType: DailyBoxOffice.self) { [weak self] in
        switch $0 {
        case .failure(let error):
            print(error)
        case .success(let result):
            self?.dailyBoxOffice = result
                
            DispatchQueue.main.async {
                self?.setupDataSource()
                self?.setupSnapshot()
            }
        }
    }
}
```
### Bridging
NSDiffableDataSourceSnapshotReference 객체에서 이 유형으로 연결할 수 있다.
```swift
let snapshot = snapshotReference as NSDiffableDataSourceSnapshot<Int, UUID>
```

## 참고
- [UICollectionViewDiffabledatasource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
- [NSDiffabledatasourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot#3561976)

