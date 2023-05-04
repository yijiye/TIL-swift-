# UISwipeActionsConfiguration
> table의 row를 스와이핑 할 때 수행하는 액션의 set

유저가 tableView의 cell을 왼쪽에서 오른쪽 또는 오른쪽에서 왼쪽으로 쓸어넘길 때, 버튼을 띄워 액션을 취할 수 있다.

tableViewDelegate에서 
`tableView(_:leadingSwipeActionsConfigurationForRowAt:)`
`tableView(_:trailingSwipeActionsConfigurationForRowAt:)`를 활용할 수 있다. 앞쪽에 달고싶다면 leading, 뒤쪽에 달고싶다면 trailing을 사용하면 된다.


**예시코드**

```swift
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard let diary = myDiary,
          let title = diary[indexPath.row].title,
          let body = diary[indexPath.row].body else { return UISwipeActionsConfiguration() }
        
    let share = UIContextualAction(style: .normal, title: "공유") { [weak self] (_, _, success: @escaping (Bool) -> Void) in
        ...
        }
    share.backgroundColor = .systemTeal
        
    let delete = UIContextualAction(style: .normal, title: "삭제") { [weak self] (_, _, success: @escaping (Bool) -> Void) in
            
        success(true)
    }
    delete.backgroundColor = .systemPink
        
    return UISwipeActionsConfiguration(actions: [share, delete])
}
```


## 참고
- [UISwipeActionsConfiguration 공식문서](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
