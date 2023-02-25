# Delegate의 역할
- 쥬스메이커 과제를 할때, 화면간 데이터 공유 방법으로 delegate를 배웠다. 만국박람회에서도 화면간 데이터 공유가 필요하여 delegate를 적용해보려고 했다! 근데...delegate protocol을 채택하는 쪽이 데이터를 전달받는 쪽이고 데이터를 전달하는 쪽은 protocol 채택 없이 변수 생성을 하면 된다고 알고 있었다. 근데 그대로 진행했을 때 제대로 작동하지 않았다. 그 이유는 바로 delegate가 크게 두가지 역할을 하기 때문이다.


- delegate는 화면간 데이터 전달에 사용되고 크게 두가지 역할을 한다.
     - **데이터 공급(...DataSource)** 
     - **이벤트 처리(...Delegate)**


<img src="https://i.imgur.com/iGcSetU.png
" width="500">


- TableView는 TableViewDataSource와 TableViewDelegate protocol을 채택할 수 있고 준수한다.
- TableView는 dataSource에게 전달받고자 하는 데이터를 물어본다

   - TableView(사장): Section, row가 몇개야? 
   - Datasource(비서) : Section, row에 대한 정보를 제공

- TableView는 Delegate에게 전달하고자 하는 데이터를 알려준다

  - TableView(사장): cell이 눌렸어!
  - Datasource(비서) : cell이 눌렸을 때, 이벤트 제공

- 정리해보자면, 데이터가 필요한 사장이 비서에게 데이터를 요청해서 받는것은 `datasource`이고 사장이 변경된 데이터를 비서에게 알려줘서 위임을 주는 것은 `delegate`이다.
- 
- `delegate`는 주로 이벤트를 처리할때 사용하는 것이 적절하고 `datasource`는 데이터 공급에 적절한 방법이다


## 참고
[UITableView 공식문서](https://developer.apple.com/documentation/uikit/uitableview)
[newmon블로그](https://infinitt.tistory.com/333)



