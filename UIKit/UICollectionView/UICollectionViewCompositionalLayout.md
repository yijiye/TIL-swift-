# UICollectionViewCompositionalLayout
> 적응력이 높고 유연한 시각적 배열로 항목을 결합할 수 있는 레이아웃 객체.
> iOS 13.0+

- 어떤 레이아웃이든 만들 수 있다.
- 레이아웃을 뚜렷한 시각적 group으로 나누는 하나 이상의 section으로 구성된다.
- 각 section은 보여주고 싶은 가장 작은 데이터 단위인 개별 항목 group으로 구성되어 있다.
- group은 수평 행, 수직 열 또는 사용자 지정 배열로 항목을 배치할 수 있다.

<img src="https://i.imgur.com/iLjoCPL.png" width="300">


## 구성
> layout > section > group > items(가장작은단위)로 구성되어 있다.

```swift
func createBasicListLayout() -> UICollectionViewLayout { 
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                  
                                         heightDimension: .fractionalHeight(1.0))    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)  
  
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                          
                                          heightDimension: .absolute(44))    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,                                                   
                                                     subitems: [item])  
  
    let section = NSCollectionLayoutSection(group: group)    

    let layout = UICollectionViewCompositionalLayout(section: section)    
    return layout
}
```

## 크기
- items, group, section 각 요소들의 size를 정하고 지정하면 layout이 완성된다.

<img src="https://i.imgur.com/d3HK2lW.png" width="300">

각 요소의 size를 정하는 방법은 3가지가 존재한다.

- `fractionalWidth` & `fractionalHeight`: 컨테이너와의 너비, 높이 비율
- `absolute`: 포인트값으로 지정
- `estimated`: 후에 content의 크기가 바뀌어 크기가 정확하지 않을 때는 estimate 값을 활용

```swift
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                     heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)
```
items은 group안에 존재하기 때문에 group과의 비율로 나타내게 된다. 위의 코드로 보면 width는 group대비 20%, 높이는 100%로 설정되었다고 보면 된다.

## 참고
- [CompositionalLayoyt](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
- [sopt_official](https://velog.io/@sopt_official/iOS1)

