# TableViewDiffableDataSource
> tableView를 위해 cell을 제공하고 data를 관리하기 위해 사용하는 객체

```swift
@preconcurrency @MainActor class UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject where SectionIdentifierType : Hashable, SectionIdentifierType : Sendable, ItemIdentifierType : Hashable, ItemIdentifierType : Sendable
```

`DiffableDataSource`는 테이블 뷰의 데이터와 UI의 업데이트를 관리하는데 필요한 것들을 제공한다. 이것은 `UITableViewDataSource` 프로토콜을 준수하고 있어 프로토콜 메소드를 사용할 수 있다.
데이터와 함께 테이블 뷰를 구성하기 위해서
1. 테이블뷰에 `DiffableDataSource`를 연결시킨다.

```swift
 private var dataSource: UITableViewDiffableDataSource<Section, Plan>?
```

이때 DataSource가 받을 수 있는 타입은 `Hashable`해야한다.

2. 테이블 뷰 cell을 구성하기 위해 cell provider를 이행한다.

3. 데이터의 현재 상태를 만든다.

4. UI에 데이터를 보여준다.

테이블 뷰에 `DiffableDataSource`를 연결할 때, `init(tableView:cellProvider:)`를 사용한다. 데이터 소스와 연결하고 싶은 tableView에 전달한다. 또한 UI에서 데이터를 표시하는 방법을 결정하기 위해 각 셀을 구성하는 cell provider를 pass한다.

```swift
dataSource = UITableViewDiffableDataSource<Int, UUID>(tableView: tableView) {
    (tableView: UITableView, indexPath: IndexPath, itemIdentifier: UUID) -> UITableViewCell? in
    // configure and return cell
}
```

```swift
private func configureTableView() {
    dataSource = UITableViewDiffableDataSource<Section, Plan>(tableView: tableView) { [unowned self] _, indexPath, _ in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PlanTableViewCell else { return UITableViewCell() }
            
        let plan = viewModel.read(at: indexPath)
        cell.configureCell(with: plan)
            
        return cell
    }
}
```

그리고 snaphot를 적용시켜 UI에 data를 표시하고 data의 현재 상태를 생성한다.

```bash=
Important

diffable data source 와 tableView를 구성한 후에 tableView에서 dataSource를 바꾸면 안된다.
만약 테이블 뷰가 초기에 구성한 후에 새로운 데이터소스가 필요하다면 새로운 테이블뷰와 diffable 데이터 소스를 새로 만들어야 한다.
```

# NSDiffableDataSourceSnapshot
> 정각에 특정 포인트에 있는 view에서 data의 상태를 표현해주는 객체

```swift
@preconcurrency struct NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType : Hashable, SectionIdentifierType : Sendable, ItemIdentifierType : Hashable, ItemIdentifierType : Sendable
```

Diffable Data Source는 스냅샷을 활용하여 collectionView나 tableView의 데이터를 제공한다. 뷰에 보여지는 데이터의 초기 상태를 스냅샷을 활용하여 셋업하고 뷰에 보여지는 데이터의 변화를 반영하기 위해 스냅샷을 사용한다.
즉, **데이터의 초기상태와 변화한 상태를 스냅샷으로 관리한다.**

스냅샷은 section과 item으로 구성되어있다. 추가하고 삭제하고 이동시키는 것들을 할 수 있다.

```bash=
Important
유니크한 Identifier를 갖기 위해 section과 item은 Hashable 프로토콜을 준수해야한다.
```

스냅샷을 사용하여 뷰에서 데이터를 보여주기 위해
1. 보여지길 원하는 데이터의 상태와 함께 스냅샷을 만든다.
2. UI에서 변화를 반영하기 위해 스냅샷을 적용한다.
    - 스냅샷은 아래 방법중 하나로 구성할 수 있다.
       - 빈 스냅샷을 만들고 거기에 아이템이랑 섹션을 추가
       - diffable data source의 `snapshot()` 메서드를 호출하여 현재 스냅샷을 얻고 새로운 상태를 반영시킴

첫 번째 방법을 사용한다면, 이와같은 과정을 거칠 수 있다.
```swift 
// Create a snapshot.
var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()        

// Populate the snapshot.
snapshot.appendSections([0])
snapshot.appendItems([UUID(), UUID(), UUID()])

// Apply the snapshot.
dataSource.apply(snapshot, animatingDifferences: true)
```

```swift
 private func createSnapshot(_ plans: [Plan]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Plan>()
        
    snapshot.appendSections([.main])
    snapshot.appendItems(plans)
    dataSource?.apply(snapshot, animatingDifferences: true)
}
```


## 참고
- [Apple Developer - UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
- [Apple Developer - NSDiffableDataSourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot)
