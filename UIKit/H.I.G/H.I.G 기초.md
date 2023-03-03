# H.I.G
Human Interface Guidelines
> 모든 사용자가 언제 어디서든 어떠한 상황에서도 모두 접근 가능하도록 설계


**주요 참고할 내용**

Foundation
- Accessibility
- Images (Scale factors 만)
- Layout
- Right to left
- SF Symbols
- Typography
- Patterns
- Entering data
- Feedback
- Launching
- Loading
- Modality

Components
Inputs

### 화면 전환에 사용된 기법 (모달리티, 내비게이션)

**모달리티(Modality)**
화면에서 화면으로 넘어갈 때 연관성이 없는 경우 모달리티 기법으로 보여준다.
또한 아래에서 위로 창이 올라오게끔 표현된다

[Modality](https://developer.apple.com/design/human-interface-guidelines/patterns/modality)

**내비게이션(Navigation)**
화면에서 화면으로 넘어갈 때 정보가 이어질 때 내비게이션 기법으로 보여준다.
정보의 depth! 
화면은 오른쪽에서 왼쪽으로 옆에서 나타난다.
예를 들어서 메모를 입력하기 위해 메모를 클릭하여 들어가면 내비게이션 기법으로 이동하게 되고 입력하는 키보드가 올라올때는 메모와는 연관성이 없으므로 모달리티 기법으로 표현된다.

[Navigation](https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/navigation-bars)

### 화면 구성 (Components)

#### Text View vs Text field
- Text View 는 여러줄을 입력할 때 사용되는 요소
- Text field 는 한줄을 입력할 때 사용되는 요소

#### Status bar

- 시간, 통신망, 배터리 잔량등을 화면 맨 위에 표시해주는 바
- 특정 앱 (게임화면, 영상앱 등 화면이 전체적으로 필요한 앱) 이 아닌경우에는 status bar를 가리면 안된다!
- 그리고 이 부분은 바꿀 수 없는 부분이다

#### Tabbar vs Toolbar

- [Tabbar](https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/tab-bars) 는 메뉴이동을 위한 바 => 바 항목을 사용하여 상호배타적인 콘텐츠 창을 탐색한다.
- [Toolbar](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/toolbars) 는 화면 안에서 일어나는 액션을 위한 바 => 예를 들어 메모장에서 현재 메모개수를 아래 툴바로 보여주고 메모__개수 라고 명시하여 메모장에서 일어나는 액션을 나타낸다.
- 두가지 크기도 다르다 탭바가 더 큼

#### Button, Icon

- 보통 버튼에 들어가는 아이콘은 Image view 라고 표현한다.
- 내비게이션바 안에 있는 버튼은 바버튼아이템 이라고 부른다.
- '>' 로 표현하는 것은 (목록 마지막에) 악세서리 뷰 라고 한다.

<img src= "https://i.imgur.com/pdb3YA6.png" width= "300" height= "500">

#### Pull-down button, Pop-up button

- 풀다운버튼은 버튼의 목적과 직접 관련된 항목이나 작업의 메뉴를 표시
- 팝업버튼은 상호배타적인 (관계가 없는) 선택 목록을 제공해야 하는 경우에 사용 (예시로 음악 앱에서 플레이리스트 sort 하는 버튼이 팝업버튼이다.)
- 더보기 버튼은 More pull-down 버튼! 눈에띄지 않는 곳에 배치할 때 사용한다.

[팝업버튼과 풀다운버튼비교](https://sujinnaljin.medium.com/ios-pull-down-button-과-pop-up-button-f0f85d650b51)

#### Navigation bar

![](https://i.imgur.com/ivoL5nS.png)

- 미리알림앱에서 미리알림 중 여행준비라는 제목의 알림으로 들어가면 위와같은 내비게이션바를 볼 수 있다.
- 큰 제목으로 표현되다가 스크롤을 내리면 여행준비 제목이 위로 올라가면서 표준제목으로 변경된다!

#### Search field

![](https://i.imgur.com/w0F0rUV.png)


- H.I.G 를 참고하면 검색창에는 '검색' 이라고 단순하게 표현하는 것을 지양한다.
- 간단한 설명이라도 적어주는게 좋다!

#### UITableView
- tableview 란, 하나의 줄을과 행을 사용하여 표현한 것
예를들어, 설정앱에 들어가서 항목별로 쭉 보여지는게 tableview 라고 할 수 있다. 
- 여러줄로 표기하는 것은 collection

<img src="https://assets.alexandria.raywenderlich.com/books/ia/images/95c613964290e6f865a23ca270e9681b130ddc114f4c44d587269673c02b354c/original.png" width= "300" height= "300">
[참고자료](https://www.kodeco.com/books/ios-apprentice/v8.2/chapters/20-table-views)



#### Section and Raw

- section은 연락처의 A 항목에 해당하는 내역들을 섹션으로 구분해 놓은 것을 뜻한다.
- raw는 한줄 한줄을 의미 (?)

<img src="https://docs-assets.developer.apple.com/published/0e083c5df8/tableview-basics@2x.png" width= "300" height= "400">
[참고문서](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data)

