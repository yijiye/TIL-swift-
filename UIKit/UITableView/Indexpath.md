# IndexPath
- section과 row의 속성을 가지며 이는 배열로 표현할 수 있다.
- 예를들어 indexPath(row: 1, section: 2) 는 [2, 1] 처럼 section과 row로 표현할 수 있고 하나의 indexPath는 하나의 row,section의 값을 가진다. 
- 또한 이 값은 0부터 시작된다.

## 활용 방법
```swift
enum FoodType: String, CaseIterable {
    case american = "American"
    case chinese = "Chinese"
    case korean = "Korean"
    case japanese = "Japanese"
}

let index = FoodType.allCases[indexPath.section]
```
- FoodType.allCases를 이용하여 FoodType의 case를 하나의 배열로 만들어준다. 
`[american, chinese, korean, japanese]` 의 배열 생성
- indexPath.section은 TableView에서 섹션(section)을 식별하는 데 사용되는 속성이며, 이 값은 0부터 시작한다. 따라서, index는 FoodType 열거형의 모든 케이스 중에서 `indexPath`의 `section` 값에 해당하는 케이스를 가져오는 것이다.

```swift
var menu: [FoodType: [Food]] = [
        .american: [
            Food(name: "햄버거", price: 5000),
            Food(name: "피자", price: 18000),
            Food(name: "아메리카노", price: 41000)
        ],
        .chinese: [
            Food(name: "탕수육", price: 18000)
        ],
        .korean: [
            Food(name: "비빔밥", price: 8000),
            Food(name: "돼지갈비", price: 20000)
        ],
        .japanese: [
            Food(name: "스시", price: 20000),
            Food(name: "스윙스(돈까스)", price: 5000)
        ]
    ]

 let index = FoodType.allCases[indexPath.section]
 guard let name = menu[index] else { return UITableViewCell() }
 cell.menuLabel.text = name[indexPath.row].name
```
- `index`는 예를 들어, `section 0` 인 `.american`에 접근할 수 있다. `menu[.american]`을 `name`에 넣어주고 `.american`의 `Food` 배열을 가져와 `name[indexPath.row]`를 사용하여 선택하게 된다. `.name`에 접근하므로 `Food` 배열의 `row`번째 `name`을 `menuLabel.text`로 넣어주는 것이다.
- 즉, `menu[.american]`으로 가져온 배열은 `.american` 카테고리의 모든 음식을 포함하고 있지만, 선택된 셀에서는 해당 카테고리에서 몇 번째 음식을 선택했는지에 따라 다른 음식이 선택된다. 따라서, `indexPath.row`를 사용하여 선택된 셀에서 해당 카테고리의 몇 번째 음식인지를 찾아내야한다.
- UITableView에서 한번에 하나의 셀만 선택할 수 있으므로, 먼저 선택한 section을 통해 해당 항목을 정하고 선택한 row에 해당하는 값을 가져오는 것이다!!
- indexPath.section으로 section에 해당하는 FoodType을 고르고, indexPath.row로 선택한 row에 해당하는 음식을 가져온것

# header
- tableView에 HeaderTitle 입력하는 방법
   1. headerTitle에 들어갈 UILabel(fram: CGRect) 를 하나 구성한다.
   2. header.text, textAlignment, font 등 원하는 조건을 넣어준다.
   3. tableView.tableHeaderView = header 를 넣어준다.
   4. viewDidLoad() 에 띄워준다.

```swift
func configureHeader() {
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
      
        header.text = "메뉴판"
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 30)
        tableView.tableHeaderView = header
    }
```

# titleForHeaderInSection method
- section에 headertitle을 추가해주는 메서드
- section에 FoodType의 case의 rawValue가 입력되도록 설정하기위해 FoodType.allCases[section].rawValue로 접근하여 title에 넣어준 후 반환하여 나타내주었다. 

```swift
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = FoodType.allCases[section].rawValue
        return sectionTitle
    }
```

# customTableViewCell
- customTableViewCell을 코드로 구현할 때, let cell: UITableViewCell 타입을 넣어 제한을 두는 것이 아니라 새로운 customTableViewCell.swift 파일을 만들고 let cell 마지막에 타입캐스팅을 해주어 구현할 수 있다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
```
