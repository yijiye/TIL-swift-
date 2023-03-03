# ScrollView method

### setContentOffset(_:animated:)
> ScrollView의 원점에 해당하는 content view의 원점에서 오프셋을 설정

- 스크롤 뷰의 왼쪽 상단 모서리에서 스크롤 뷰의 콘텐츠의 오프셋을 설정
- 첫 번째 인수는 설정하려는 오프셋이며, 두 번째 인수는 콘텐츠 오프셋의 변화를 애니메이션화할지 여부를 나타내는 Bool 타입이 들어온다.

```swift!
private func setScrollView() {
        let bottomOffset: CGPoint = CGPointMake(0, calculatorItemsScrollView.contentSize.height)
        calculatorItemsScrollView.setContentOffset(bottomOffset, animated: false)
    }
```
- `CGPoint`: 2차원 좌표계의 점을 포함하는 구조로 (x:,y:)를 설정할 수 있다.
- calculatorItemScrollView의 bottomOffset을 설정하고 애니메이션화는 false로 주어 scrollView를 구현.

## Main Run Loop
> 앱이 실행되면 iOS의 UIApplication이 main run loop를 실행시키고 이 루프는 각종 이벤트를 처리한다.

 **Update Cycle**
> 발생한 이벤트를 모두 처리하고 권한이 다시 main run loop로 돌아오게 되고 이 시점을 update cycle이라고 한다.

![](https://i.imgur.com/xrctwkF.png)

- 예를들어 `@IBAction` 을 통해 버튼을 눌러 이벤트를 변경하는 경우 변화가 바로 받아들여지는 것이 아니라 변화되는 `View`를 체크하게 된다.
- 그리고 모든 핸들러가 종료되고 `main run loop`로 권한이 다시 돌아오게 되는 시점인 `update cycle` 에서 `view`의 값을 바꾸어서 변화를 적용시켜준다.
- **즉 변경시켜주는 코드와 실제 변경되는 값이 적용되는 시점 사이에 시간차가 존재한다!!**

## UIView methods

### layoutIfNeeded()
> 레이아웃이 잠시 보류중일때, 즉시 뷰에 나타나도록 명령

- 이 방법은 일반적으로 다음 그리기 주기 전에 뷰의 하위 뷰의 레이아웃을 업데이트하고 싶을 때 호출된다.
- setNeedsLayout과 마찬가지로 layoutSubviews를 예약하는 메서드이지만 바로 실행시키는 동기적으로 작용하는 메서드이다.
- 이 방법을 호출하면, 보기의 하위 뷰가 화면에 표시되기 전에 적절하게 배치되고 크기가 조정되었는지 확인할 수 있다.

### setNeedsLayout
> 비용이 가장 적게드는 방법으로 수동으로 체크하여 update cycle에서 layoutSubviews를 호출한다.

- 뷰의 레이아웃을 다시 계산해야 한다는 것을 시스템에 나타낸다. 
- setNeedsLayout는 즉시 실행하고 반환하며 반환하기 전에 실제로 뷰를 업데이트하지 않는 대신 시스템이 해당 뷰에서 `layoutSubviews`를 호출하고 모든 하위 뷰에서 후속 `layoutSubviews` 호출을 트리거할 때 다음 업데이트 주기에 뷰가 업데이트된다.
- 비동기적으로 작동하여 호출되고 바로 반환된다.
- View의 보여지는 모습은 update cycle에 들어갔을 때 바뀌게 된다.

### layoutSubview()
> View의 값을 호출한 즉시 변경시켜주는 메서드

- View이 모든 Subview들의 layoutSubViews() 또한 연달아 호출한다. 
    - 따라서 비용이 많이든다. (직접 호출하는 것은 지양)
- View의 값에 재계산되어야하는 시점인 update cycle에서 자동으로 호출된다.
- subView 크기가 변경되었거나 View 크기가 변경되었을때, 뷰의 하위 뷰를 배치해야 할 때 호출
- 개발자는 이 방법을 재정의하여 사용자 지정 UIView 하위 클래스에서 하위 뷰의 레이아웃을 사용자 정의할 수 있다.

## 결론
- `layoutSubview()`는 값이 즉시 변경되야 하는 경우에 사용하되, 비용이 많이들기 때문에 지양하도록 하자
- `setNeedsLayout()`은 애니메이션 블록에서 값이 즉시 변경되는 것이 아니라 추후 `update cycle`에서 값이 변경되므로 값이 변하기는 하지만 애니메이션 효과는 볼 수 없다 (그래서 scrollView에 값이 추가되어도 한템포 느리게 올라왔나보다! 값은 입력되었으나 여전히 바로 올라오지 않았던 이유 해결)
- `layoutIfNeed()`는 `setNeedLayout`과 대부분 같고 동기적으로 동작하는 차이점이 있다.

## 참고
[Apple-setContentOffset](https://developer.apple.com/documentation/uikit/uiscrollview/1619400-setcontentoffset)
[scrollView주기](https://tech.gc.com/demystifying-ios-layout/)
[scrollView주기-군옥수수수](https://baked-corn.tistory.com/105)

