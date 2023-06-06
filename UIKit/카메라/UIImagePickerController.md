# UIImagePickerController
> 사진촬영, 동영상촬영, 유저의 media 라이브러리에서 아이템 선택을 위한 시스템 인터페이스를 관리하는 ViewController

```swift
@MainActor class UIImagePickerController : UINavigationController
```

## Overview
Image picker controller는 유저의 상호작용을 관리하고 delegate 객체에 그 상호작용의 결과를 전달한다.
역할과 모습은 할당한 `source type`과 관련있다.

- `UIImagePickerController.SourceType.camera` : 새로운 사진이나 영상을 촬영하는 유저 인터페이스 제공
- `UIImagePickerController.SourceType.photoLibrary, savedPhotosAlbum`: 저장된 사진이나 영상 중에 선택하는 인터페이스 제공


디폴트 컨트롤을 포함한 Image picker controller를 사용하기 위해 아래 스텝을 따르자

1. 주어진 소스에서 콘텐츠를 선택할 수 있는 기기인지 확인하기. `UIImagePickerController.SourceType` 열거형에서 상수를 제공하여 `isSourceTypeAvailable`클래스 메서드를 호출하여 확인한다.

2. 사용 중인 소스 유형에서 사용 가능한 미디어 유형 확인하기. 
`availableMediaTypes(for)` 클래스 메서드를 호출하여 동영상 녹화에 사용할 수 있는 카메라와 정지 이미지만 사용할 수 있는 카메라를 구분한다.

3. 원하는 미디어 유형에 따라 image picker controller에 대한 UI를 조정한다.
`mediaTypes` 속성을 설정하여 정지 이미지, 동영상 또는 둘 다를 사용할 수 있도록 설정한다.

4. 사용자 인터페이스를 표시한다.
iPhone, iPod touch에서 현재 활성화된 뷰 컨트롤러의 `preset(animated,completion)` 메서드를 호출하여 모달로 표시한다.
이때 구성된 image picker controller를 새로운 뷰 컨트롤러에 전달한다.

5. 사용자가 새로 촬영하거나 저장된 이미지나 동영상을 선택하거나 또는 작업을 취소하는 경우 delegate 객체를 사용하여 image picker를 해제한다.
새로 촬영한 미디어의 경우 delegate는 이를 디바이스의 카메라 롤에 저장할 수 있다. 이전에 저장된 미디어의 경우 delegate는 앱의 목적에 따라 데이터를 사용할 수 있다.


Custom한 image picker controller를 사용하려면 Overlay view를 제공하고 정지 이미지 또는 동영상을 캡처하는데 설명된 방법을 사용하면 된다. [코드예제확인하기](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/customizing_an_image_picker_controller)

```bash
Important

- UIImagePickerController 클래스는 세로 모드만 지원한다. 
- 이 클래스는 그대로 사용되도록 의도되었으며 서브클래싱을 지원하지 않는다. 
- 이 클래스의 뷰 계층 구조는 비공개로 유지되어 수정하면 안된다.
- (예외) cameraOverlayView 속성에 사용자 정의 뷰를 할당하고 해당 뷰를 사용하여 추가 정보를 표시하거나 카메라 인터페이스와 코드간의 상호작용을 관리할 수 있다.
```

## Provide a delegate object
Image picker controller를 사용하기 위해 `UIImagePickerControllerDelegate` 프로토콜을 준수하는 delegate를 사용해야한다. iOS 4.1 부터 카메라롤에 스틸이미지를 저장할 수 있다.

## Adjust flash mode
iOS 4.0 부터 유저가 설정하는 플래시 모드를 설정할 수 있다. [자세한 내용 참고](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)

## Work with movies
동영상 캡처는 기본적으로 10분의 제한 시간을 가지지만 `videoMaximumDuration` 속성을 사용하여 조정할 수 있다.
사용자가 유튜브등 다른 곳으로 공유 버튼을 탭하는 경우, 적절한 지속 시간 제한과 품질이 적용된다.
기본 카메라 인터페이스는 이전에 저장된 동영상 편집을 지원한다. 편집은 동영상 시작 또는 끝에서 트리밍한 다음 트리밍된 동영상을 저장하는 작업을 포함한다.
새로운 녹화도 지원하는 인터페이스 대신 편집에 특화된 인터페이스를 표시하려면 `UIVideoEditorController` 를 사용하는 것이 좋다.

## Work with Live Photos 
라이브 포토는 지원되는 기기의 카메라 앱 기능으로 캡처된 순간 뿐만아니라 캡처 직전과 직후의 움직임과 소리를 포함하여 사진을 표현한다.
`PHLivePhoto` 객체는 라이브 포토를 나타내며 `PHLivePhotoView` 클래스는 라이브 포토를 표시하고 그 내용을 재생하기 위한 시스템 표준 대화형 인터페이스를 제공한다.

라이브 포토는 소리와 움직임을 표현하지만 사진으로 유지된다. image picker controller를 사용하여 정지 이미지를 캡처하거나 선택할 때, 라이브 포토로 캡처된 에셋은 picker에 나타난다.
그러나 사용자가 에셋을 선택할 때 delegate 객체는 라이브 포토의 정지 이미지 표현을 표함하는 UIImage 객체만 받는다.
image picker에서 움직임 소리콘텐츠를 얻으려면 `mediaTypes` 배열에서 `kUTTypeImage` 및 `kUTTypeLivePhoto` 유형을 모두 포함해야한다.

## Perform fully-customized media capture and browsing

전체적으로 사용자 정의된 이미지 또는 동영상 캡처를 수행하려면 `Still and Video Media Capture`에서 설명한대로 `AVFoundation` 프레임워크를 사용해라.

사진 라이브러리 탐색을 위해 완전히 사용자 정의된 이미지 피커를 만들려면 `Photos` 프레임 워크의 클래스를 사용해라. 예를들어 iOS에 의해 생성되고 캐시된 더 큰 썸네일 이미지를 표시하거나 타임스탬프와 위치 정보와 같은 이미지 메타데이터를 활용하여 `MapKit` 및 아이클라우드 사진 공유와 같은 다른 기능을 통합할 수 있는 사용자 정의 이미지 피커를 만들 수 있다.


## 참고
- [AppleDeveloper-UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller#1658363)
