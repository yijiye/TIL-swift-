# AVAssetImageGenerator로 Thumbnail 만들기
> class 
> video asset에서 image를 만들어내는 객체

.mp4 포맷 영상의 썸네일을 구하기 위해 `AVAssetImageGenerator`를 사용하였다.
이미지를 생성하기 위해 `Asset`이 필요하고 `Asset`을 구하기 위해 `URL`이 필요하다.
나는 녹화가 완료된 데이터(영상)을 `CoreData`에 저장하였는데 이때 `outPutURL(임시 URL)`에 담은 후 `Data`로 뽑아서 `Data`타입으로 저장을 하였다.
그래서 `CoreData`에 저장한 model 타입을 만들 때 `URL`이 이용되고 이때 썸네일을 뽑아서 같이 `CoreData`에 넣는 방법으로 구현했다.

### `URL`을 받아와서 `Asset`을 만들고 `AVAssetImageGenerator`를 이용하여 이미지를 뽑아내는 메서드를 구현

```swift
 private func generateThumbnail(from url: URL) -> Future<UIImage?, RecordingError> {
    return Future<UIImage?, RecordingError> { promise in
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 1)

            guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
                promise(.failure(.thumbnail))
                return
            }
            let thumbnailImage = UIImage(cgImage: cgImage)
            promise(.success(thumbnailImage))
        }
    }
}
```

- 나는 Combine을 사용하여 `Future`를 이용했다. (이렇게 쓰는게 맞나..?)
- UI를 방해하면 안되기 때문에 `DispatchQueue.global().async` 블록 안에 넣어주었다.
- `CMTime` : 1초로 정의 했다.
- `copyCGImage(at, actualTime:)` : cgImage를 구한다. 이 프로퍼티는 iOS16부터 사용할 수 없지만 이 앱의 타겟은 최소 iOS14버전이기 때문에 사용하였다.
- 마지막에 UIImage로 변경하여 success에 넣어주었다.


### Future를 구독하여 성공시 image를 받아 CoreData에 저장

```swift
private func fetchThumbnail(from videoRecordedURL: URL, videoData: Data, title: String) {
    generateThumbnail(from: videoRecordedURL)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] image in
            if let image {
                guard let imageData = image.pngData(),
                      let playTime = self?.fetchPlayTime(videoRecordedURL.absoluteString) else { return }
                let video = Video(title: "\(title).mp4", date: Date(), savedVideo: videoData, thumbnailImage: imageData, playTime: playTime)
                self?.viewModel.create(video)
            }
        }
        .store(in: &cancellables)
}
```

제목 그대로 `Future`타입을 반환하는 메서드를 구독하여 실패와 성공 케이스로 나눠 성공했을 때 이미지를 받아와서 `CoreData`에 넣을 `model` 타입에 이미지를 같이 저장해주었다.
그리고 viewModel의 `create`를 실행해 실제 데이터를 로컬 DB에 저장했다.


### 녹화가 끝나고 실행되도록 구현

AVFoundation에는 `AVCaptureFileOutputRecordingDelegate` 가 있고 여기에 녹화가 종료되면 실행되는 메서드가 있다. 나는 녹화가 종료되면 썸네일을 가져오고 그걸 로컬DB에 저장하도록 했다.

```swift
func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recordStackView.changeCameraModeButton.isEnabled = true
    if (error != nil) {
        print(error?.localizedDescription as Any)
    } else {
        guard let videoRecordedURL = outputURL,
              let videoData = try? Data(contentsOf: videoRecordedURL) else { return }
            
        let title = "영상의 제목을 입력해주세요."
        let save = "저장"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: save, style: .default) { [weak self] _ in
            guard let videoTitle = alert.textFields?[0].text else { return }
            self?.fetchThumbnail(from: videoRecordedURL, videoData: videoData, title: videoTitle)
            }
            
        alert.addTextField()
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
}
```

- 추가적으로 비디오의 이름은 저장이 끝나면 Alert창이 뜨고 거기 TextField에 입력하여 얻은 text를 사용했다. Alert에 textField가 포함되어있어 쉽게 구현할 수 있었다.


## 참고
- [AppleDeveloper - AVAssetImageGenerator](https://developer.apple.com/documentation/avfoundation/avassetimagegenerator)
- [AppleDeveloper - copyCGImage(at:actualTime)](https://developer.apple.com/documentation/avfoundation/avassetimagegenerator/1387303-copycgimage)
- [AppleDeveloper - Creating images from a video asset](https://developer.apple.com/documentation/avfoundation/media_reading_and_writing/creating_images_from_a_video_asset)
- [felix-mr.tistory](https://felix-mr.tistory.com/4)
- [hcn1519.github](https://hcn1519.github.io/articles/2018-05/avfoundationthumbnail)
