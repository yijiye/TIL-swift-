# AVFoundation
> Framework
> Video Record 화면 구현하기

## Overview
AVFoundation은 Apple 플랫폼에서 시청각 미디어를 검사, 재생, 캡처 및 처리하기 위한 광범위한 작업을 포함하는 몇 가지 주요 기술 영역을 결합한다.

**즉, Apple 플랫폼에 시청각 관련한 하드웨어를 컨트롤할 수 있게 해주는 프레임워크이다.**

- STEP
   - CaptureSession 생성
   - CaptureDevice 생성
   - CaptureDeivceInput 생성
   - Video UI에 출력
   - Recording 

## Capture setup
> API Collection 
> media capture를 위해 내장 카메라나 마이크 그리고 외부 디바이스를 구성해야한다.

- 사용자 지정 카메라 UI 구현
- 사용자가 초점, 노출 및 안정화 옵션과 같은 사진 및 비디오 캡처를 직접 제어할 수 있도록 구현
- RAW 형식 사진, 깊이 지도 또는 사용자 지정 시간 메타데이터가 있는 비디오와 같은 시스템 카메라 UI와 다른 결과를 생성한다.
- 캡처 장치에서 직접 픽셀 또는 오디오 데이터 스트리밍에 실시간으로 액세스할 수 있다.

<img src="https://hackmd.io/_uploads/rJiN-hzPh.png" width=600>

캡쳐 아키텍쳐의 메인파트는 `sessions`, `inputs`, `output` 3가지 이다.

- `CaptureSession` : 하나 이상의 `input`과 `output`을 연결한다.
- `Inputs` : iOS나 Mac에 빌트인된 카메라나 마이크와 같은 디바이스를 포함한 media의 소스를 뜻한다. 디바이스로 찍은 사진이나 동영상을 말한다.
- `Outputs` : 사용가능한 데이터를 만들어 낸 결과물
- `CatureDevice` : 디바이스, 내 아이폰 카메라

## CaptureSession 
`Input`과 `Output`을 연결해주어 데이터 흐름을 제어한다.

```swift 
let captureSession = AVCaptureSession()
captureSession.sessionPreset = .high

...
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.startRunning()
    }
}
    
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.stopRunning()
    }
}
```

- `sessionPreset` : 녹화 품질을 설정할 수 있다. 높게할수록 배터리 소비량이 늘어난다.
- `startRunning()` : 실질적은 플로우가 시작된다. **이는 UI를 처리하는 메인스레드와 다른 스레드에서 처리해줘야한다.** 
- `stopRunning()` : 세션의 일이 끝났을 때 호출한다.

나는 view가 나타날때 시작을해주고 view가 사라질때 종료를 설정해주었다. 둘다 메인스레드가 아닌 global()안에 넣어주었다.

## CaptureDevice
사용하려는 장치를 정의해준다.

```swift
// audioDevice
let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)

// cameraDevice
private func selectedCamera(in position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        
    let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: deviceTypes,
        mediaType: .video,
        position: .unspecified
    )
        
    let devices = discoverySession.devices
    guard !devices.isEmpty,
          let device = devices.first(where: { device in device.position == position }) else { return nil }
        
    return device
}
```

## CaptureDeviceInput
`captureDevice`를 이용해서 `session`에 `captureDeviceInput`을 추가해준다.

```swift
private func setUpSession() {
    guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }

    captureSession.sessionPreset = .high
        
    do {
        // 1
        captureSession.beginConfiguration()
        
        // 2
        videoDevice = selectedCamera(in: .back)
        guard let videoDevice else { return }
        videoInput = try AVCaptureDeviceInput(device: videoDevice)
        guard let videoInput else { return }
            
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
            
        // 3
        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(audioInput)  {
            captureSession.addInput(audioInput)
        }
        
        // 4
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        // 5
        captureSession.commitConfiguration()
        self.view.layer.addSublayer(videoPreViewLayer)
        
        // 6
        setUpCloseButton()
        setUpRecordStackView()
        
        videoPreViewLayer.session = captureSession
            
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}
```

1. 세션 구성의 시작을 나타낸다.
2. 비디오 디바이스에 대한 입력을 만들어 세션에 추가한다.
3. 오디오 디바이스에 대한 입력을 만들어 세션에 추가한다.
4. 비디오, 오디오를 파일로 출력하기 위한 output을 만들어 세션에 추가한다.
5. 세션 구성의 완료를 나타낸다.
6. videoPreViewLayer 위에 추가하는 UI요소를 넣어준다.


## Video UI
화면에 비디오나 사진 촬영시 보여지는 UI를 구현한다.

```swift
 private lazy var videoPreViewLayer: AVCaptureVideoPreviewLayer = {
    let previewLayer = AVCaptureVideoPreviewLayer()
    previewLayer.frame = self.view.frame
    previewLayer.videoGravity = .resizeAspectFill
        
    return previewLayer
}()
```

- frame 은 view의 frame에 맞추고 videoGravity에 원하는 값을 넣어주었다.
- session을 구성할때 view의 layer에 추가해주고 그 아래 다른 요소를 추가해야 정상적으로 화면에 나타났다. 
- 우선 Layer를 추가하고 다른 view나 button등 UI는 그 다음에 추가해야 화면에 뜸! 
- 또한 카메라 사용전 기본 info.plist 설정도 해야한다.


## Recording
이제 view에 나타는 화면을 녹화해야하는데 이는 `AVCaptureMovieFileOutput`을 이용하면 된다.

```swift
let videoOutput = AVCaptureMovieFileOutput()

// 녹화시작
private func startRecording() {
    startTimer()
    outputURL = viewModel.createVideoURL()
    guard let outputURL else { return }
    videoOutput.startRecording(to: outputURL, recordingDelegate: self)
}

// 녹화종료
private func stopRecording() {
    if videoOutput.isRecording == true {
        stopTimer()
        videoOutput.stopRecording()
    }
}
```

녹화가 종료된 후의 작업은 `AVCaptureFileOutputRecordingDelegate`를 준수하여 원하는 메서드를 사용할 수 있다.

```swift
extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordStackView.changeCameraModeButton.isEnabled = false
     }
    
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

- 첫 번째 메서드는 녹화가 시작되면 호출되는 메서드로 나는 녹화가 시작되었을 때, 카메라 모드를 바꾸는 버튼이 작동하지 않도록 구현했다.
- 두 번째 메서드는 녹화가 종료되면 호출되는 메서드로 종료가 되면 제목을 입력하는 Alert창이 뜨고 입력된 제목과 나머지 데이터를 이용해 로컬 DB에 저장하도록 구현했다.


## 참고
- [AppleDeveloper - AVFoundation](https://developer.apple.com/documentation/avfoundation/)
- [AppleDeveloper - Capture setup](https://developer.apple.com/documentation/avfoundation/capture_setup)
- [@heyksw velog](https://velog.io/@heyksw/iOS-AVFoundation-으로-custom-camera-구현)
- [jintaewoo.tistory](https://jintaewoo.tistory.com/43)
- [appcoda](https://www.appcoda.com/avfoundation-swift-guide/)
