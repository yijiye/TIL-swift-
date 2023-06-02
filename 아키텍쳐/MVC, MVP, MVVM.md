# MVC, MVP, MVVM

<img src="https://hackmd.io/_uploads/rkl6Ix4NL2.png" width="500">


## 정의

### MVC

Model, View, Controller로 역할이 분리된 아키텍쳐

- Model은 비즈니스로직을 담당한다.
- View는 화면에 띄워지는 UI를 관리한다. 
- Controller는 Model에 일을 시키고, Model이 한 일을 전달받아 UI에게 화면을 띄우도록 하고, UI에서 사용자 액션을 받으면 그걸 다시 Model에게 명령하는 등 가운데서 말 그대로 컨트롤하는 역할을 한다.

### MVP 

Model, View, Presenter로 역할이 분리된 아키텍쳐

- MVC에서 C가 P로 교체된 구조
- presenter는 view와 1:1 관계이다. 
- 즉, view는 presenter를 참조하고 presenter또한 view를 참조한다.
- 데이터 binding이 없다.

### MVVM

Model, View, ViewModel로 역할이 분리된 아키텍쳐

- View는 ViewModel을 알고있지만, ViewModel은 View를 알 필요가 없다. 
- 두 사이에 Binding을 통한 데이터 전달이 이루어진다. 
- ViewModel의 역할은 View가 사용할 메서드와 필드를 구현하고, View에 상태 변화를 알리는 것이다.


## MVVM의 도입 배경

내가 생각한 가장 큰 이유는 2가지이다.
- MVC 패턴을 사용하면 Model이 해야하는 비즈니스 로직들을 Controller에서도 많이 처리하게 되어 Controller가 비대해지는 문제가 있다.
- Controller에 UI와 로직이 엮여있으니 테스트하기 어렵다.

이를 해결하고자 MVVM을 도입하게 되었고 따라서 MVVM을 사용하는 핵심 이유는 아래와 같다.
- **View와 ViewModel을 분리시켜 테스트를 하기 쉽다.**
- 부수적으로 분리하니까 Controller가 비대해지는 것을 막을 수 있다.


## MVVM 패턴 적용시 내가 정한 규칙 

MVVM 패턴을 적용할 때, 개발자마다 스타일이 다달라 정해진 기준은 많이 없다는 생각이 들었다. 협업자들끼리 정해야하는 부분도 많았고, 이제 막 공부하는 나같은 경우는 더더욱 기준이 없어서 어려웠다.
그래서 이것만큼은 지켜야겠다고 생각한 것과 나름의 이유를 정리해보았다.

1. ViewModel은 View를 알 필요가 없다.

이건 MVVM의 개념에서 확인했듯이 ViewModel에서는 View의 요소를 알 필요가 없고 View에서 ViewModel을 바인딩해서 업데이트를 하기 때문에 ViewModel에서 `import UIKit`을 할 필요가 없다.

2. ViewModel과 View는 1대1 관계를 유지하자.

이 부분은 사실 반드시 1대1관계를 유지할 필요는 없다. 개념을 다시 생각해보면 View의 로직을 담당하는 것은 ViewModel이 하고 View가 한개가 있다면 ViewModel로 한개가 있는게 맞다고 생각했다. 만약 View의 로직이 많아 ViewModel이 많아진다면, View를 나눠서 해당 View에 대한 ViewModel을 만드는 것이 맞다고 생각한다.

3. ViewModel에 대한 Test를 해보자.

MVVM의 가장 큰 장점은 테스트가 용이하다는 것이다. 로직이 분리되어있으니까! 그래서 MVVM 패턴을 적용한다면, Test를 반드시 해보자


<details><summary><big>패턴별 소스코드</big></summary>

### MVC

```swift
class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var todos = ["집안 일", "공부하기", "TIL 쓰기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text, text.isEmpty == false {
                guard let self = self else { return }
                self.todos.append(text)
                self.tableview.performBatchUpdates {
                    self.tableview.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "할 일을 입력해주세요."
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func fetchButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                let data = UserDefaults.standard.string(forKey: "todos")
                self?.todos = data?.components(separatedBy: ",") ?? ["데이터 없음"]
                self?.tableview.reloadData()
                self?.indicator.stopAnimating()
            }
        })
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.set(self?.todos.joined(separator: ","), forKey: "todos")
                self?.indicator.stopAnimating()
            }
        })
    }
}

```


## MVP

```swift
class Presenter {
    var view: ViewController?
    var todos = ["집안 일", "공부하기", "TIL 쓰기"]
    
    
    var count: Int {
        todos.count
    }
    
    func append(_ text: String) {
        todos.append(text)
    }
    
    func remove(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row)
    }
    
    func tableViewInsertRow() {
        view?.tableview.performBatchUpdates {
            view?.tableview.insertRows(at: [IndexPath(row: self.count-1, section: 0)], with: .automatic)
        }
    }
    
    func tableViewDeleteRow(_ indexPath: IndexPath) {
        view?.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func fetchButtonTapped(completion: @escaping (() -> ())) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                let data = UserDefaults.standard.string(forKey: "todos")
                self?.todos = data?.components(separatedBy: ",") ?? ["데이터 없음"]
                self?.view?.tableview.reloadData()
                completion()
            }
        })
    }
    
    func saveButtonTapped(completion: @escaping (() -> ())) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.set(self?.todos.joined(separator: ","), forKey: "todos")
                completion()
            }
        })
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        presenter.view = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text, text.isEmpty == false {
                guard let self = self else { return }
                self.presenter.append(text)
                self.presenter.tableViewInsertRow()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "할 일을 입력해주세요."
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func fetchButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        self.presenter.fetchButtonTapped(completion: {
            self.indicator.stopAnimating()
        })
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        self.presenter.saveButtonTapped {
            self.indicator.stopAnimating()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = presenter.todos[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.imageView?.image = cell?.imageView?.image == nil ? UIImage(systemName: "checkmark") : nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.remove(at: indexPath)
            presenter.tableViewDeleteRow(indexPath)
        }
    }
}

```


## MVVM

```swift
import UIKit

class ViewModel {
    var todos = ["집안 일", "공부하기", "TIL 쓰기"] {
        didSet { //프로퍼티 옵저버로 biding
            todoListener?()
        }
    }
    
    var count: Int {
        todos.count
    }
    
    var todoListener: (() -> ())? // 클로저
    
    func append(_ text: String) {
        todos.append(text)
    }
    
    func remove(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row)
    }
    
    func fetchButtonTapped(completion: @escaping (() -> ())) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                let data = UserDefaults.standard.string(forKey: "todos")
                self?.todos = data?.components(separatedBy: ",") ?? ["데이터 없음"]
                completion()
            }
        })
    }
    
    func saveButtonTapped(completion: @escaping (() -> ())) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.set(self?.todos.joined(separator: ","), forKey: "todos")
                completion()
            }
        })
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        viewModel.todoListener = updateTableView //todoListner binding
    }
    
    private func updateTableView() {
        tableview.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text, text.isEmpty == false {
                guard let self = self else { return }
                viewModel.append(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "할 일을 입력해주세요."
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func fetchButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        self.viewModel.fetchButtonTapped(completion: {
            self.indicator.stopAnimating()
        })
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        self.viewModel.saveButtonTapped {
            self.indicator.stopAnimating()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = viewModel.todos[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.imageView?.image = cell?.imageView?.image == nil ? UIImage(systemName: "checkmark") : nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.remove(at: indexPath)
    }
}

```

</details>
