# Frame vs Bounds

# Q. Bounds와 Frame의 차이점은 무엇인가요?

```bash
Frame은 슈퍼뷰의 좌표계로부터의 자기자신의 뷰의 위치와 크기를 설명하고, Bounds는 자기자신의 좌표계에서의 자기자신의 뷰의 위치와 크기를 설명한다. 
```

# Overview
답은 언제나 공식문서에 있다!

## Frame
> 슈퍼뷰의 좌표계에서 뷰의 위치와 크기를 설명하는 프레임 직사각형

레이아웃을 잡을 때 뷰의 위치와 사이즈를 설정하기 위해  이 frame을 사용할 수 있다. 
이 속성을 설정하면 `center` 속성에 의해 지정된 지점이 변경되고 그에 따라 `bounds` 직사각형의 크기가 변경된다. 프레임 직사각형의 좌표계는 항상 포인트로 설정된다.

```bash
주의
`transform` 프로퍼티가 transform과 동일하지 않다면 이 프로퍼티의 값은 정의된 것이 아니니 무시해라
```

프레임 직사각형을 자동으로 재배치하려면 `draw(:)` 메서드를 호출하면 된다.


<img src="https://hackmd.io/_uploads/SJ0M3VW_2.png" width="300">

[출처 소들이](https://babbab2.tistory.com/44)

- frame의 사이즈는 view 자체의 크기가 아니라 **view가 차지하는 영역을 감싸서 만든 사각형**이 바로 frame의 사이즈가 된다.

## Bounds
> 자기 자신의 좌표계에서 뷰의 위치와 크기를 묘사하는 bounds 직사각형

디폴트 bounds는 (0,0)으로 프레임 프로퍼티에서 직사각형의 사이즈와 같은 사이즈를 가진다.
이 직사각형의 사이즈 포션을 바꾸면 중심부 기준으로 뷰의 크기가 줄어들거나 커진다. 크기를 변경하면 프레임 속성의 직사각형 크기도 일치하도록 변경된다.
bounds 직사각형의 좌표는 항상 포인트로 지정된다.

<img src="https://hackmd.io/_uploads/SkGL34Z_h.png" width="300">

[출처 소들이](https://babbab2.tistory.com/44)

View가 회전을 하든 안하든 **자신의 원점이 곧 좌표의 시작점**이 된다.

### 예시
루트뷰 위에 FirstView, SecondView, ThirdView가 올려져 있다는 가정하에 SecondView의 Bounds를 변경하면 어떤일이 벌어질까?

- SecondView가 움직이는것이 아니라 thirdView가 움직인 것 처럼 보임! 

왜 그럴까? 
바로 `viewport` 때문이다. `viewport` 라는 것은 화면에 보여지는 보임창을 의미하는데 각각의 뷰는 그 사이즈 만큼 `viewport`를 가진다.
그래서 bounds.origin을 바꾸면 `viewport`가 변화되기 때문에 thirdView가 바뀐것 처럼 보여지는 것이다.

<img src="https://hackmd.io/_uploads/B1M5AV-uh.png" width="400">

(소들이님 블로그 보고 정말 쉽게 이해할 수 있었다...감사합니다!) 


## 그럼 언제 사용할까?

### Frame
단순히 UIView의 위치나 크기를 설정할 때 사용한다.

### Bounds
- View를 회전한 후 View의 실제 크기를 알고 싶을 때 사용한다.
- View 내부에 그림을 그릴때 (drawRect)를 사용한다.
- ScrollView에서 스크롤을 할 때 사용한다.
ScrollView의 `contentOffset`이 바로 bounds를 설정하는 값이다.

## 참고
- [Apple Developer - Frame](https://developer.apple.com/documentation/uikit/uiview/1622621-frame)
- [Apple Developer - Bounds](https://developer.apple.com/documentation/uikit/uiview/1622580-bounds)
- [소들이 블로그](https://babbab2.tistory.com/45)
