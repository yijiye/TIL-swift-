# Delegate
- 객체 지향 프로그래밍에서 하나의 특정 객체가 모든 일을 처리하는 것이 아니라 처리 해야 할 일 중 일부 작업을 다른 객체에 위임하는 것
- 1:1로 데이터를 전달할 때 사용

# 예제
- 첫번째 화면에서 ```다음화면으로 이동``` 버튼을 눌러 두번째 화면으로 이동하고 ```+100 point```버튼을 눌러 포인트를 늘린다. 
- 다시 ```이전화면으로 이동``` 버튼을 눌러 첫번째 화면으로 돌아와 ```화면 업데이트```를 눌러 값을 업데이트를 해준다.

<img src ="https://user-images.githubusercontent.com/114971172/212449867-da157901-fc85-4a49-a58c-1760773150fa.gif" width = "200">


## Protocol 정의
- 전달해주고 싶은 값(프로퍼티 or 메서드)을 protocol 안에 넣어주어 접근을 한정적으로 만들어준다.
- 위의 예제의 경우 포인트를 올려주는 것이 목적이므로 포인트 프로퍼티를 가지는 ```class Point```를 정의해주었다.
- 그리고 그 ```class Point``` 자체를 protocol에 넣어주었다.

```swift
class Point {
    var point: Int = 100
}
```
```swift
protocol UpdatePointDelegate {
    var updatePoint : Point { get set }
}
```
- protocol 내의 프로퍼티는 get 이나 set 전용으로 구현해야 한다. 만약 get, set을 지우고 작성하면 아래와 같은 에러가 발생한다.

![](https://i.imgur.com/q6o0peq.png)

## 데이터를 전달받을 화면 (첫번째 화면)에서 두번째 화면으로 이동
- 첫번째 화면에서 해야할 일
   - 두번째 화면으로 이동 (present, performSegue 등)
   - 두번째 화면에서 변하는 값을 대신 하겠다는 선언! 
- 첫번째 화면에서 결국 두번째 화면에서 변한 값을 전달받으니까 protocol을 채택한다. (다시말해서 일을 위임받아서 protocol대로 한다고 이해했다.)

### 화면 이동
   - 여러가지 방법이 있어서 그 방법에 따라 접근하는 스타일이 다르다.
   - 결국 중요한건 첫번째 화면이 가리키는 화면이 어디인지 그걸 정확히 연결시키는지가 중요하다.

```swift
@IBAction func nextPageButtonTapped(_ sender: UIButton) {
        guard let secondVC = self.storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        secondVC.delegate = self
        present(secondVC, animated: true, completion: nil)
    }
```
- 다음화면으로 이동 버튼을 누르면 두번째 화면으로 이동하는데 이때 두번째 화면을 새로운 인스턴스로 만들어준다. (secondVC)
- 그리고 그 인스턴스의 일을 self (내가) 하겠다고 delegate 선언을 해준다.
- 그리고 그 새롭게 만든 화면을 띄어준다. 

```swift 
@IBAction func nextPageButtonTapped(_ sender: UIButton) {
        guard let secondVC = self.storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        guard let secondVC2 = self.storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        secondVC.delegate = self
        present(secondVC2, animated: true, completion: nil)
    }
```
- 새로운 인스턴스인 이유는 secondVC를 새롭게 만들어 주고 delegate는 원래의 secondVC로 위임하고, secondVC2의 화면을 띄어준다면 값이 변화하지 않는다.
- 왜냐면 또 새로운 인스턴스를 만들었기 때문에! 

### ViewController의 identifier 확인
<img src = "https://i.imgur.com/x7RVrWW.png" width = "200">

- 스토리보드에서 뷰컨트롤러 윗부분을 누르고 설정화면을 확인한다.

<img src = "https://i.imgur.com/WghYHyd.png" width = "200">


- 가운데에 있는 버튼을 누르면 Identity 값을 입력할 수 있다. 이때 입력한 값이 화면을 확인하는 과정에서 identifier 값으로 들어간다.


### delegate 선언

- 위의 예제 코드에서 알 수 있듯이 변화를 업데이트 하려면 self에 delegate를 선언해주어야 한다.
- 이 과정이 빠지면 일을 대신 해줄 수 없어서 변화를 가져올 수 없다


### 데이터를 전달하는 화면 (두번째 화면)에서 데이터를 전달해주는 메서드
- 두번째 화면에서는 protocol을 채택하지 않고 변수를 만들어준다.
- 변수로 만들어서 그 protocol에 접근할 수 있다.

```swift
class SecondViewController: UIViewController {
    
    var delegate: UpdatePointDelegate? // protocol을 변수로 만들어 줌
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func plusPointButtonTapped(_ sender: UIButton) {
        delegate?.updatePoint.point += 100
//        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
```
- 변수로 delegate를 만들어 주고 그 delegate가 해야하는 일을 +100 point 버턴을 눌렀을 때 변화가 되도록 코드를 작성해준다.
- dismissButtonTapped는 이전화면으로 이동하기 위해 화면을 dismiss 해주는 버튼이다. 
- ```plusPointButtonTapped```에 dismiss를 넣는다면 누르면서 화면이 바뀌는 것을 확인할 수 있었다.
---
### performSegue 로 화면 전환하는 경우
- present로 화면을 띄우면 확인하는 경우가 1개밖에 없어서 심플했다.
- 첫번째 뷰컨트롤러 -> 네비게이션컨트롤러 -> 두번째 뷰 컨트롤러 와 같은 방식으로 화면 전환이 된다고 가정했을 때 화면을 이동하려면 어떻게 해야할까? 

```swift
 @IBAction private func barButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toManageVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        guard let secondVC = navigationController.topViewController as? ManageStockViewController else { return }
        secondVC.delegate = self
//        present(secondVC, animated: true, completion: nil)
    }
```
- protocol을 만들어주고 delegate 변수를 만들어주는건 위와 동일하다.
- performSegue로 화면을 전환할때, prepare가 실행되어 미리 뷰 컨트롤러에게 알려주는데 이 과정은 숨어져 있다(?) 따로 정의해줄 필요 없이 performSegue만으로 화면이동을 할 수 있다. 필요시에 override 해서 prepare를 구현해줄 수 있다.
- prepare를 구현하여 단계별로 확인한다.
   - 첫번째 뷰 컨트롤러에서 네비게이션 컨트롤러를 확인하는 과정
   - 네비게이션 컨트롤러에서 두번째 뷰 컨트롤러를 확인하는 과정
   두가지 과정에서 다운캐스팅이 반드시 필요하다! 네비게이션컨트롤러가 내가 이동하고자 하는 네비게이션컨트롤러가 맞는지, 뷰컨트롤러가 내가 이동하고자 하는 뷰 컨트롤러가 맞는지 다운캐스팅으로 확인하는 과정을 넣어준다.
   
- 마지막 present 과정은 필요없다. 왜냐면 performSegue로 화면 전환을 하니까!! 

**prepare(for:sender:)**
> Notifies the view controller that a segue is about to be performed.
[prepare공식문서](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621490-prepare)

---
### segue로 화면전환이 연결되어 있는데 present 코드로 구현해서 화면을 이동시키는 경우
</br>

- 생각해볼 경우의 수가 참 많은 화면전환 🔥
![](https://i.imgur.com/27mXFi7.png)
- 첫번째 화면하고 두번째 화면이 스토리보드상에서 segue로 연결되어 있는데, delegate를 쓰면서 present로 화면을 띄어주는 코드를 만들었더니 앱을 실행하는건 문제가 없었다. **그런데 실행창에 이런 메세지가 떴다. 이미 화면이 떠있는데 왜 또 띄우냐는 얘기**
- 그래서 둘중 하나만 쓰는게 맞는거 같다. present로 띄울거면 segue를 끊고 segue를 쓸거면 위의 performSegue, prepare로 화면 전환을 하는걸로!!

---
## 참고
[delegate 상어블로그](https://shark-sea.kr/entry/swift-delegate패턴-알아보기)
[protocol 공식문서](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID281)
