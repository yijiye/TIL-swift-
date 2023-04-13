# CoreData
> 모델 계층 개체를 관리하는 프레임워크
> 저장할 정보들을 객체의 형태로 저장하고 관리하며 객체간 관계를 설정할 수 있다.

## Overview
- CoreData는 데이터를 객체로 취급한다.
- On-disk 방식으로 저장하여 앱을 종료하거나 기기를 종료해도 데이터에 접근 가능하다.
- 관리 객체 모델을 Entity, Attribute, Relationships으로 구성된다.
   - Entity: Core Data의 클래스 정의
   - Attribute: Entity의 정보를 나타내는 속성
   - Relationships: 여러 Entity를 연결하는 링크

## How To Use

1. CoreData 파일 추가
2. CoreData에 Entity 추가
3. Entity에 Attribute 추가
   기본타입외의 타입을 사용한다면 `Transformable`을 선택한다. <br>
<img src="https://i.imgur.com/67YT6Pi.png" width=500>
<img src="https://i.imgur.com/uBfBznt.png" width=500>


## Core Data Stack
> 앱의 모델 layer를 관리하고 유지하는 역할을 함

객체와 외부 데이터 저장소 사이를 중재하는 다층 구조로 이루어진 프레임워크
모델 layer를 공동으로 지원하는 클래스를 제공한다.

<img src="https://i.imgur.com/QSWa5Ib.png" width ="600">

- CoreData가 생성될 때 
1. NSPersistentStoreCoordinator 인스턴스화
2. NSManagedObjectModel 필요
3. NSManagedObjectContext 초기화
4. NSManagedObjectContext가 NSPersistentStoreCoordinator에 대한 참조를 유지

- CoreData 설정이 완료되면
1. 영구 저장소과 상호작용 할 준비를 마친다.
2. 이제 NSManagedObjectContext를 통해 NSPersistentStoreCoordinator와 상호작용 한다.

#### NSPersistentStoreCoordinator (영구 저장소 코디네이터)
- persistent storage (영구저장소) 와 managed object model을 연결한다.
- 따라서 coordinator 없는 context는 persistent storage에 접근할 수 없다.
- coordinator는 작업을 직렬화해 진행하므로 동시적으로 읽고 쓰려면 여러 coordinator를 사용해야한다.

- Core Data가 제공하는 영구 저장소 유형
<img src="https://i.imgur.com/Uym58Ok.png" width = "600">

- SQLite Store
- XML Store
- Binary Store
- In-Memory Store

[특징 알아보기](https://delmasong.hashnode.dev/coredata)

#### NSManagedObjectModel (관리객체모델)
- `.xcdatamodeld`파일을 프로그래밍적으로 표현한 형태
- Entity의 구조를 정의하는 객체
- 스키마의 Entity를 설명하는 `NSEntityDescription`을 포함


#### NSManagedObjectContext (관리객체 컨텍스트)
- managed objects를 생성하고, 저장하고, fetch 작업을 제공한다. (비동기적으로!)
- 모든 관리객체는 `NSManagedObjectContext`를 등록해야 하고 컨텍스트를 사용해서 object graph (데이터의 집합)에 객체를 추가/삭제/수정한다.
- In-memory 스크래치 패드이다.
   - 스크래치 패드: 작업 중 발생하는 중간 결과를 임시 보관하는데 사용하는 임시 기억 장소

```swift
final class DailyBoxOfficeCoreDataManager: DataManager {
    ...
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    ...
}
```
- 보통 앱에서 하나의 context를 사용하는데 (viewContext) 여러개의 context가 필요한 경우 메인스레드가 blocking 될 수 있으므로 이런 경우 개인 큐에서 실행되는 새로운 관리 객체 컨텍스트를 반환해주는 `newBackgroundContext()`를 사용한다.

#### NSPersistentContainer (영구 컨테이너)
- Core Data Stack을 나타내는 필요한 모든 객체를 포함 
- Container를 통해 한번에 관리된다.


### CoreData CRUD

#### 1. import CoreData
#### 2. NSManagedObjectContext를 가져온다.

`NSManagedObjectContext`를 가져오기 전, Core Data Stack을 나타내는 필요한 모든 객체를 포함하는 `NSPersistentContainer`를 만든다.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BoxOfficeCoreData")       
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        })

        return container
    }()
```

- "BoxOfficeData"는 Core Data Model 이름이다. (entity 이름이 아님!)

이제 본격적으로 `NSManagedObjectContext`를 가져온다.

#### Create
```swift
final class DailyBoxOfficeCoreDataManager: DataManager {
    static let shared = DailyBoxOfficeCoreDataManager()
    
    // 1. 
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    private init() {}
    
    func create(key: String, value: [Any]) {
        
        // 2. 
        guard let context = self.context,
              let dailyBoxOfficeEntity = NSEntityDescription.entity(forEntityName: "DailyBoxOfficeData", in: context),
              
              // 3. 
              let dailyBoxOfficeData = NSManagedObject(entity: dailyBoxOfficeEntity, insertInto: context) as? DailyBoxOfficeData else { return }
        
        setValue(at: dailyBoxOfficeData, date: key, and: value)
        
        // 4. 
        save()
    }
    
    private func save() {
        guard let context = self.context else { return }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

1. Container를 통해 Context 참조를 가져옴
2. 저장할 Entity 인스턴스 생성 (내가 어떤 Entity에 저장해야하는지 알아야 하니깐)
3. NSManagedObject 객체를 새로 만들어 context에 삽입
   NSManagedObject에 값을 세팅해준다.
4. save() 로 변경사항을 디스크에 저장, NSManagedObjectContext를 저장해준다.


#### Read
``` swift
    func read(key: String) -> Any? {
        fetchData(date: key)
    }

    private func fetchData(date: String) -> DailyBoxOfficeData? {
        // 1.
        guard let context = self.context else { return nil }
        
        // 2.
        let filter = filteredDataRequest(date: date)
        
        // 3.
        do {
            let data = try context.fetch(filter)
            return data.first
        } catch {
            return nil
        }
    }
     
     private func filteredDataRequest(date: String) -> NSFetchRequest<DailyBoxOfficeData> {
        let fetchRequest = NSFetchRequest<DailyBoxOfficeData>(entityName: "DailyBoxOfficeData")
        fetchRequest.predicate = NSPredicate(format: "selectedDate == %@", date)
        return fetchRequest
    }


```
1. context 참조를 가져온다.
2. 가져올 EntityName을 지정하고 NSFetchRequest를 통해 데이터를 가지고 올 인스턴스를 생성한다.
   - 이때, predicate은 fetch될 데이터를 비교해주는 구문이다. 여기서는 선택된 날짜랑 같은 날짜인지 확인해주는 코드를 구현하였음.
3. context를 통해 데이터를 fetch 한다.

#### Update

```swift
    func update(key: String, value: [Any]) {
        // 1.
        guard let dailyBoxOfficeData = fetchData(date: key) else { return }
        
        // 2.
        setValue(at: dailyBoxOfficeData, date: key, and: value)
        save()
    }
```

1. 데이터를 fetch 하여 기존 데이터를 가져온다.
2. setValue로 새로운 데이터를 업데이트한다.

#### Delete

```swift
    func delete() {
        // 1.
        guard let context = self.context else { return }
        
        // 2.
        let request: NSFetchRequest<NSFetchRequestResult> = DailyBoxOfficeData.fetchRequest()
        // 3.
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
```

1. context참조를 가져온다.
2. NSFetchRequest를 통해 데이터를 가져올 인스턴스를 생성한다.
3. NSBatchDeleteRequest를 통해 삭제할 데이터를 정의한 후 context를 통해 데이터를 삭제한다.


----

## 참고
- [공식문서](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html#//apple_ref/doc/uid/TP40001075-CH8-SW1)
- [CoreData-delmasong](https://delmasong.hashnode.dev/coredata)
- [newBackgroundcontext-eungding](https://eunjin3786.tistory.com/154)
- [CoreData,predicate-memohg](https://memohg.tistory.com/118)
- [NSPredicate-FLIP.LOG](https://onelife2live.tistory.com/35)

