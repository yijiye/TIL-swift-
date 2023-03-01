# Modern cell configuration
- 기존에는 TableView를 구성할때, UITableViewCell안에 있는 Label, detailTextLabel, imageViewiOS에 접근하여 속성을 변경할 수 있었는데, iOS 14 부터 configuration을 이용하도록 변경되었다.

<img src="https://i.imgur.com/uIUlrNO.png" width="400">

## configuration 활용
- cell에 defaultContentConfiguration()을 요청
- text, secondaryText, image를 설정하여 원하는 조건을 줌
- cell의 contentConfiguration에 첫번째 변수로 생성한 content를 넣어준다.

```swift
var customConfiguration = cell.defaultContentConfiguration()
        
    customConfiguration.text = items[indexPath.row].name
        customConfiguration.textProperties.font = UIFont.systemFont(ofSize: 25)
        
        
    customConfiguration.image = resizedItemImage
        
    cell.contentConfiguration = customConfiguration
```

## customTableViewCell vs prototype
- customTableViewCell의 경우 오토레이아웃을 적용할 수 있고, IBOutlet 요소에 직접 접근할 수 있다. modern cell configuration 사용이 필요하지 않다.
- prototype인 오토레이아웃을 적용할 수 없고, cell에 올라가 있는 label, image 등 값에 직접 접근해야 한다. 그러나 이는 iOS 버전 14부터 사라져 modern cell configuration 을 사용해야한다.
## 참고
[WWDC](https://www.wwdcnotes.com/notes/wwdc20/10027/)
[zedd 블로그](https://zeddios.tistory.com/1205)
