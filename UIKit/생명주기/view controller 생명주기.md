# View 생명주기
- 이해하기 쉬운 네이밍이면서 동시에 말하는데 헷갈리게 만든 생명주기 🔥

![](https://i.imgur.com/PzJXKlE.png)

- 쉽게 정리해보면 뷰가 로드되고, 나타날 것이라는 신호를 주고 화면에 나타나고, 사라질 신호를 주고 화면에서 사라지는 단계로 이루어진다.

### ViewDidLoad
> Called after the controller's view is loaded into memory.
> 메모리에 controller의 view가 올라온 후 호출된다.

- 화면이 처음 만들어질 때 한번만 실행되며 시스템에 의해 자동으로 호출된다.
- 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용된다.

**Navigation controller를 이용하여 화면 전환을 할때 왜 root view는 viewDidLoad가 한번만 호출되는데 두번째 화면은 이동할때 마다 호출이 될까? (자료구조와 연관!)**

![](https://i.imgur.com/qvNEOrZ.png)

- navigation controller는 stack 구조를 가지고 있다! 스택구조는 먼저 들어온 데이터가 아래에 쌓이고(push) 나중에 들어온 데이터부터 꺼내는 (pop) 구조를 가지고 있다.
- 스택에서 pop되는 데이터는 메모리가 쌓이지 않는다!! 
- root view가 가장 먼저 들어온 데이터가 되고 그 위로 새로운 view들이 쌓여서 view hierarchy가 쌓이는데, 스택의 구조이니까 나중에 쌓인 view가 pop 되면서 메모리가 사라지는 거고 다시 불러오면 메모리에 올라오니까 다시 viewDidLoad가 호출된다.

**loadView ?**
- 컨트롤러가 관리하는 뷰를 만드는 역할을 한다.
- loadView가 뷰를 만들어서 메모리에 올리면 ```viewDidLoad```가 호출!

### ViewWillAppear
> Notifies the view controller that its view is about to be added to a view hierarchy.
> 뷰 계층에 뷰가 더해지기 직전에 신호가 전달된다.

- 뷰가 나타나기 직전에 호출된다.
- 따라서 화면간 이동이 있는 경우라면 화면이 바뀌면서 변화가 나타나므로 이미 화면을 넘겼을 때 변화가 업데이트 되어있다.
- status bar의 스타일이나 방향을 바꿀때 적용할 수 있다.

### ViewDidAppear
> Notifies the view controller that its view was added to a view hierarchy.
> 뷰 계층에 뷰가 더해지고 나서 신호가 전달된다.

- 뷰가 나타나고 나서 호출되므로 화면이 변하고 변화가 업데이트 된다.
- WillAppear와 비교했을 때 딜레이가 있는 것 처럼 보인다.

### ViewWillDisappear
> Notifies the view controller that its view is about to be removed from a view hierarchy.
> 뷰 계층에서 사라질 때 신호가 전달된다.

- 뷰가 실제로 사라지기 전에 신호가 전달된다.
- 그래서 화면이 바뀌면서 색도 같이 변하는 것을 확인할 수 있었다.

### ViewDidDisappear
> Notifies the view controller that its view was removed from a view hierarchy.
> 뷰 계층에서 뷰가 사라지고 난 후 신호가 전달된다.

- 뷰가 이미 사라지고 나서 신호가 전달된다.

---

## 참고

[공식문서](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621477-viewdiddisappear)
[공식문서](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
[ZeddiOS-티스토리](https://zeddios.tistory.com/43)
[ZeddiOS-티스토리](https://zeddios.tistory.com/44)
