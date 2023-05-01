# SwiftUI

## 특징
- Navigation API
- Layout: VStack, ZStack, HStack 등등
- macOS에 대한 개선
- UIKit 상호 운용성
- Swift Charts
- UI 구성요소 확장
- Transferable 프로토콜을 이용한 Sharing API
- 잠금 화면 위젯

### 선언적 구문
**선언형이란,** 수행해야 하는 작업을 명시한 것으로 View 자기자신이 어떻게 변하는지 알 수 있다.
**명령형이란,** 작업을 수행하기 위한 단계를 설명한 것으로 View 자기자신이 어떻게 변하는지 예상할 수 없다.

SwiftUI는 선언전 구문으로 사용자 인터페이스의 기능을 명시하기만 하면된다.

```swift
import SwiftUI

struct AlbumDetail: View {
    var album: Album

    var body: some View {
        List(album.songs) { song in 
            HStack {
                Image(album.cover)
                VStack(alignment: .leading) {
                    Text(song.title)
                    Text(song.artist.name)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

### 디자인 도구
디자인 캔버스에서 작업하면 편집하는 모든 내용이 옆에 표시되는 편집기의 코드와 동기화 된다.
코드를 입력하는 동시에 미리보기로 바로 볼 수 있고 라이트모드 및 다크모드와 같은 다양한 구성에서 UI를 확인할 수 있다.

- 드로그 앤 드롭 : 캔버스에서 컨트롤을 드래그하여 정렬할 수 있다.
- 동적 대체 : Swift 컴파일러 및 런타임은 Xcode 전체에서 기본 제공되므로 앱을 지속적으로 구축하고 실행할 수 있다.
- 미리보기 : 여러개의 미리보기를 생성하여 샘플 데이터를 얻을 수 있고 UI를 원하는 기기에서 원하는 방향으로 표시할 수 있다.

### UIKit 및 AppKit과 호환
SwiftUI는 UIKit 및 AppKit과 호환되도록 설계되어 기존 앱에 추가로 적용할 수 있다.


## 참고
- [SwiftUI 공식문서](https://developer.apple.com/kr/xcode/swiftui/)

