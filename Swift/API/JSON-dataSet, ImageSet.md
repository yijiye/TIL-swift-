## ◾️ Contents.json
JSON 형식의 데이터파일에 Imageset 폴더안에있는 contents.json 파일이 어떤 목적으로 있는지 고민하였다. contents.json 파일에 대해 알아보자!!
* [참조: Apple Developer Documentation - Asset Catalog Format Reference](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/ImageSetType.html#//apple_ref/doc/uid/TP40015170-CH25-SW1) <br/> ✏️ **Contents.json** : 개별 리소스 파일에 대한 **메타데이터**, 온디맨드 리소스 태그, 앱 슬라이싱 property 및 attribute
- ✏️ **metadata** : 데이터를 설명해주는 데이터. 대량의 정보 가운데에서 찾고 있는 정보를 효율적으로 찾아내서 이용하기 위해 일정한 규칙에 따라 콘텐츠에 대하여 부여되는 데이터이다. 구조화된 정보를 분석, 분류하고 부가적 정보를 추가하기 위해 그 데이터 뒤에 함께 따라가는 정보를 말한다.

처음에는 Contents.json 파일도 따로 타입을 정의해줘야 하는지 고민했으나 메타데이터이기 때문에 코드에서 활용할 일이 없다고 생각하여 타입을 정의하지 않았다.

---
<br/>

## ◾️ imageset, dataset 파일의 차이
확장자가 imageset, dataset 둘의 차이점에 대해 알아보자!!

### ✏️ dataset
Xcode에서 생성된 장치 실행 코드(Mach-O)를 제외한 모든 종류의 데이터를 포함하는 파일의 집합.

프로젝트 JSON 파일을 Asset에 등록하여 사용하기 위해서 dataset으로 생성,삽입해야 한다.
이후, 코드에서 dataset에 저장된 data를 사용하려면 `NSDataAsset` 타입 인스턴스를 생성해야 한다.
<br/>

### ✏️ imageset
UIImage 및 NSImage 인스턴스에 사용되는 named image asset의 그래픽 이미지 파일들.

프로젝트에 사용할 Image 파일을 Asset에 등록하여 사용하기 위해서 imageset으로 생성, 삽입해야 한다.
이후, 코드에서 imageset에 저장된 image를 사용하려면 `UIImage`, `NSImage` 인스턴스를 생성해야 한다.

```swift
// SwiftUI
let image = Image("ImageName")

// UIKit
let image = UIImage(named: "ImageName")

// AppKit
let image = NSImage(named: "ImageName")
```

