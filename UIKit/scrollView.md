# ScrollView, AutoLayout

## Step
[공식문서참고하기](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithScrollViews.html#//apple_ref/doc/uid/TP40010853-CH24-SW1)

- scene에 scrollView 추가하기
- scrollView 오토레이아웃 제약 추가 : safeArea에만 있는게 아니고 전체 화면으로도 가능함 (마진 고려 선택할 수 있음)
- scrollView위에 view를 올리고 이름을 content View로 변경
- content view를 scrollView와 top space to container, leading, trailing, bottom을 다 제약을 걸어준다. scrollView가 보여질 영역이 바로 content view!
- 위아래로 또는 좌우로만 스크롤링 하려면 Option을 선택할 수 있음. (위아래로 한다면 scrollView와 equl widths로 지정, multipiler 1로 지정)
- label, imageView 등 원하는 기능 추가

 #### contents Layout Guide
 - content가 보여지는 영역
 - 처음에 스크롤뷰가 컨텐츠영역의 크기를 알 수 없기 때문에 빨간색 오류가 생긴다.
 #### Frame Layout Guide
 - 스크롤뷰의 Frame을 의미
 - 만약 컨텐츠 영역이 frame을 넘어서 스크롤하게 되는데, 한 Label을 움직이지 않고 고정시켜놓고 싶으면 Frame Layout Guide와 제약을 걸어주면 된다.

### Tip! content view의 크기를 모르는 경우
- 만약 크기를 몰라서 빨간색 오류가 발생했을 경우 content view위에 아무것도 없어도 오류를 없애는 방법!
   - content view를 Frame layout과 equl height으로 지정하면 빨간색 오류가 사라진다.
   - 이때 priority를 조정한다면 (가장 낮게 설정) 추후 Label을 올렸을 때, label의 priority를 높여 크기를 우선시 해줄 수 있다. => Label이 없으면 같은 높이, Label이 들어오면 Label의 크기에 맞게 설정 


## Dynamic ScrollView (w/ stackView)

- stackView로 묶고 Distribution 을 Fill Eqully로 설정하면 stack View 안의 객체들이 동일한 크기로 맞춰진다.
- spacing을 통해 간격을 설정해줄 수 있다.
- scrollView위에 stackView를 올린다면 제약은 scrollView 기준으로 잡아야한다. 제약 버튼을 누른후 v 를 클릭하여 기준을 바꿔주면 된다.
<img src="https://i.imgur.com/pOxLVzd.png" width ="300">

```swift
let label = UILabel()
stackView.addArrangeSubview(label)
```

