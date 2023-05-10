맛보기 1탄!

# Core Graphics
> 2차원을 그리기 위한 Tool

## Overview
Quartz 2D는 2차원을 그리기 위한 engine
- macOS : 그래픽, 이미지 테크놀로지와 같이 사용 가능 (Core Image, Core Video, OpenGL, QuickTime)
- iOS : 그래픽, 애니메이션 기술을 함께 이용 가능 (Core Animation, OpenGL Es, UIKit class)

### The Page
그림을 그릴때 밑에서부터 위로 쌓이는(겹치는) 구조 

### Drawing Destinations
> opaque data type (CGContextRef 타입으로 캡슐화되어 있음)

window, printer, PDF, Bitmap, Layer로 표현될 수 있다.
디바이스에 상관없이 사용가능하도록 캡슐화 되어 있음.
Quartz가 알아서 만들어주기 때문에 개발자는 신경쓰지 않아도 됨.

### Quartz 2D Coordinate Systems

(0,0)부터 시작해서 오른쪽으로 갈수록 위로갈수록 값이 커진다.
iOS는 UIView에 의해 반환된다.
`UIGraphicsBeginImageContextWithOptions` 메서드 활용

### Drawing to a View Graphics Context in iOS 

drawRect를 이행하면서 구현한다.
<View Programming Guide for iOS 참고>


## Paths
> 어떤 경로를 통해서 그릴건지?

- Points : 시작지점, 끝지점 등 말 그대로 포인트를 의미
- Lines : 포인트를 잇는 사이 라인
- Arcs : '호' 를 그리를 수 있다.


## Transform
> 비틀거나, rotate등을 표현

UIView는 사각형으로만 그릴 수 있는데, 이미지의 크기를 줄이거나 rotate 하거나 뒤집거나 등등 다양하게 바꿀 수 있다.

## 원, 선 그려보기
```swift
final class CoreGraphicsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func drawCircleButtonTapped(_ sender: UIButton) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(2.0)
        
        context.addEllipse(in: CGRect(x: 50, y: 200, width: 200, height: 200))
        context.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    

    @IBAction func markButtonTapped(_ sender: UIButton) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(5.0)
        
        context.addEllipse(in: CGRect(x: 50, y: 200, width: 200, height: 200))
        context.strokePath()
        
        
        context.setLineWidth(5.0)
        context.setStrokeColor(UIColor.blue.cgColor)
        
        context.move(to: CGPoint(x: 100, y: 300))
        context.addLine(to: CGPoint(x: 140, y: 340))
        context.addLine(to: CGPoint(x: 200, y: 260))
        context.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
}

```

<img src="https://i.imgur.com/3DGyvMv.png" width="200">
<img src="https://i.imgur.com/pIQS5tN.png" width="200">

## 참고
- [CoreGraphics 공식문서](https://developer.apple.com/documentation/coregraphics)
