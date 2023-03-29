# UIRefreshControl
> 스크롤 뷰의 내용 새로 고침을 시작할 수 있는 표준 컨트롤.

## Overview
UIScrollView, TableView, CollectionView 객체에 붙일 수 있는 표준 컨트롤이다. 이 컨트롤을 붙이면 내용을 새로고침할 수 있다.

<img src="https://i.imgur.com/UW9tnK0.png" width="400">

refresh 컨트롤은 UIControl의 target-action 메커니즘을 사용하여 컨텐츠를 업데이트할 때를 알려준다. 활성화 시, refresh 컨트롤는 구성 시 제공한 action method를 호출한다. action method을 추가할 때, 다음 예제 코드와 같이 valueChanged 이벤트를 수신하도록 구성한다. action method를 사용하여 컨텐츠를 업데이트하고, 완료되면 새로 고침 컨트롤의 endRefreshing() 메소드를 호출하면 된다.

```swift
func configureRefreshControl () {
   // Add the refresh control to your UIScrollView object.
   myScrollingView.refreshControl = UIRefreshControl()
   myScrollingView.refreshControl?.addTarget(self, action:
                                      #selector(handleRefreshControl),
                                      for: .valueChanged)
}
    
@objc func handleRefreshControl() {
   // Update your content…

   // Dismiss the refresh control.
   DispatchQueue.main.async {
      self.myScrollingView.refreshControl?.endRefreshing()
   }
}
```

만약 UITableViewController를 사용한다면, refreshControl 속성을 UIRefreshControl의 인스턴스에 할당한다. 그런 다음 valueChanged 이벤트에 대한 대상과 action method를 연결하여 관련 tableView의 새로 고침 동작을 관리하면 된다.

```bash=
✅ Important
UIRefreshControl은 UIUserInterfaceIdiom.mac을 사용할 때는 이용할 수 없다.
비슷한 동작을 구현하고 싶다면 
제목 "Refresh"와 키보드 단축키 Command-R으로 UIKeyCommand 개체를 만들어 컨트롤을 Refresh menu item으로 바꾸어 사용할 수 있다. 그런 다음 앱의 메뉴 시스템에 명령을 추가하면 된다.
```
**BoxOffice예제코드**

```swift=
// ViewController
override func viewDidLoad() {
    super.viewDidLoad()
        
    refreshData()
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    }
    
@objc private func refreshData() {
    updateDateToViewTitle()
    updateDateToEndPoint()
    fetchDailyBoxOfficeData()
}

....
private func fetchDailyBoxOfficeData() {
    ...
    DispatchQueue.main.async {
        self?.setupDataSource()
        self?.setupSnapshot()
        
        // refreshControl 종료 코드
        self?.refreshControl.endRefreshing()
    }
}
```
## 참고
- [UIRefreshControl](https://developer.apple.com/documentation/uikit/uirefreshcontrol)
