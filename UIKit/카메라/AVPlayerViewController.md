# AVPlayerViewController
> Class
> playback 컨트롤을 위한 유저 인터페이스를 보여주고 플레이어로 부터 컨텐츠를 보여주는 viewController 

## Overview
AVKit프레임워크는 AVPlayerViewController subclassing을 지원하지 않는다.

- Airplay 지원
- Picture in Picture(PiP) 지원
PiP 재생을 통해 사용자는 비디오 플레이어를 작은 플로팅 창으로 최소화하여 기본 앱이나 다른 앱에서 다른 활동을 수행할 수 있다.
- tvOS Playback 경험 커스텀 지원

## 직접 구현하기

video를 플레이하려면 videoURL이 필요하다. 이 URL(filepath)을 AVPlayer(url:)에 넣어주어 플레이하도록 해야하는데 여기서 트러블슈팅이 있었다.

- 🔍 저장하는 Model 타입에 URL을 통해 썸네일을 저장하니 URL을 같이 저장해서 이 URL을 사용해보자 

처음 이렇게 접근했는데, 앱을 종료하고 다시 실행하니 동영상 재생이 제대로 되지 않았다. 이유를 생각해보니 임시로 URL을 만들어서 이 URL이 변경되었나? 정확하지 않은가 의심했다.

```swift
func createVideoURL() -> URL? {
    let directory = NSTemporaryDirectory() as NSString
        
    if directory != "" {
        let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
        return URL(fileURLWithPath: path)
    }
        
    return nil
}
```

이렇게 임시Directory를 만들고 Filepath를 저장한 것이 문제인가 싶어서 FileManager를 이용해서 저장하는 방법으로 변경했다. 그러나 이마저도 해결되지 않았다.
URL은 앱을 다시 켰을 때와 처음과 동일했다. 결국 문제는 URL은 맞지만 그 안에 파일이 없다는게 문제였다. 생각해보니 CoreData에 영상을 저장했는데 filePath는 CoreData 위치와 맞지 않았다. 그냥 filePath만 일치했을 뿐...🥲 

### 해결방법

저장된 데이터의 url을 찾아야했는데 CoreData저장 위치를 일일히 알아내는 것은 힘들었다. 저장되고나서 아는건 되지만 계속해서 추적하기는 불가능했다. 
따라서 Data타입을 url로 변경하는 방법을 계속해서 찾아보았고 `write(to:options)` 메서드를 발견했다. 이는 데이터를 담아줄 url을 변수고 가지고 있다. 

- 새로운 임시 url을 만든다.
- 화면에 띄울 data를 url에 저장한다.
- 그 url을 player에 넣어주어 화면에 띄운다.

이렇게 하니까 앱을 종료하고 다시켜도 정상 작동하는 것을 확인했다.

```swift
import AVKit
...

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let videoEntity = viewModel.read(at: indexPath),
          let video = videoEntity.savedVideo,
          let videoURL = viewModel.createVideoURL() else { return }
        
    do {
        try video.write(to: videoURL)
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerController.player = player
        playerController.entersFullScreenWhenPlaybackBegins = true
        self.present(playerController, animated: true) {
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}
```


## 참고
- [AppleDeveloper - AVPlayerViewController](https://developer.apple.com/documentation/avkit/avplayerviewcontroller)
- [AppleDeveloper - write(to:options)](https://developer.apple.com/documentation/foundation/data/1779858-write)
- [moonibot.tistory](https://moonibot.tistory.com/43)
