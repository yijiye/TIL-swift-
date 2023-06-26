# NSCollectionLayoutBoundarySupplementaryItem
> class
> 
> CollectionView에 headers, footer를 추가하는데 사용하는 객체

이름이 참 길다😂
`Workout` 프로젝트에서 `UICollectionViewCompositionalLayout`을 이용해 grid 화면을 구현했다.
이때, 제목을 넣고 싶었는데 `compositionalLayout`을 사용하니 UILabel을 새로 추가해서 view끼리 autoLayout을 잡는 것보다 Header를 추가하는 게 더 적합하다고 생각했다.

그래서 이 class를 적용해보았다.

## 공식문서

```
NSCollectionLayoutSupplementaryItem의 특정한 타입
이 class를 활용하여 전체 collection view또는 collection view의 section에 headers나 footers를 추가할 수 있다.
```

각각의 supplementary item은 고유한 element kind를 가지고 있다.

```swift
struct ElementKind {
    static let badge = "badge-element-kind"
    static let background = "background-element-kind"
    static let sectionHeader = "section-header-element-kind"
    static let sectionFooter = "section-footer-element-kind"
    static let layoutHeader = "layout-header-element-kind"
    static let layoutFooter = "layout-footer-element-kind"
}
```

이것을 layout에 적용하려면 section의 `boundarySupplementaryItems` 프로퍼티에 적용시키면 된다.

```swift
let section = NSCollectionLayoutSection(group: group)


let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(44))
    
let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                               elementKind: ElementKind.sectionHeader,
                                                                 alignment: .top)
let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                               elementKind: ElementKind.sectionFooter,
                                                                 alignment: .bottom)
    
section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
```

## 적용한 코드

나는 원형 버튼을 가지고 있는 `cell`을 3x3 의 그리드 화면을 구현하고 그 위에 `header`를 추가했다.

<img src="https://hackmd.io/_uploads/rJQtiMPu3.png" width="150">

</br>



```swift
workoutCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
...

private func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
    let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.boundarySupplementaryItems = [header]
        
    let layout = UICollectionViewCompositionalLayout(section: section)
        
    return layout
}

...

 func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
        return UICollectionReusableView()
    }
    let headerTitle = "오늘은 어떤 운동을 해볼까요?"
    header.prepare(text: headerTitle)
        
    return header
}
```
- 공식문서에서 `layout`을 정할 때, `section`에 추가를 하고 `cell register`와 같이 `HeaderView`도 `register` 하는 과정이 필요하다. 
- HeaderView는 `UICollectionReusableView` 타입이다.


## 참고 
- [Apple Developer - NSCollectionLayoutBoundarySupplementaryItem](https://developer.apple.com/documentation/uikit/nscollectionlayoutboundarysupplementaryitem)
- [김종권님 블로그](https://ios-development.tistory.com/946)
