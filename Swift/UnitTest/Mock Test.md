# Mock 객체를 활용한 Unit Test

ViewModel을 Test하려는데, 대부분의 method가 `private` 접근제어가 걸려있어 바로 접근하기 어려웠다. 이때, 테스트를 위한 Mock 객체를 만들어 접근제어가 걸려있는 테스트 할 메서드가 실행되도록 속여 테스트하는 방법으로 구현하였다.

- 테스트 할 객체

```swift
import Foundation
import Combine

final class PlanManagerViewModel {
    @Published var planList: [Plan] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let todoViewModel: PlanSubscriber
    private let doingViewModel: PlanSubscriber
    private let doneViewModel: PlanSubscriber
    
    init(todoViewModel: PlanSubscriber, doingViewModel: PlanSubscriber, doneViewModel: PlanSubscriber) {
        self.todoViewModel = todoViewModel
        self.doingViewModel = doingViewModel
        self.doneViewModel = doneViewModel
        setUpBindings()
    }
    ...
    
    private func bindDelete(subscriber: PlanSubscriber) {
        subscriber.deletePublisher
            .sink { [weak self] plan in
                self?.delete(by: plan.id)
            }
            .store(in: &cancellables)
    }
    
    private func bindChange(subscriber: PlanSubscriber) {
        subscriber.changePublisher
            .sink { [weak self] (plan, state) in
                self?.changeState(plan: plan, state: state)
            }
            .store(in: &cancellables)
    }
    
    private func delete(by id: UUID) {
        planList.removeAll { $0.id == id }
    }
    
    private func changeState(plan: Plan, state: State) {
        guard let index = self.planList.firstIndex(where: { $0.id == plan.id }) else { return }
        
        var plan = planList[index]
        plan.state = state
      
        update(plan)
    }
}
```

이때, `delete`와 `changeState`메서드의 경우 `private`이 걸려있었지만, `PlanSubscriber` 프로토콜을 채택한 `viewModel`의 `publisher`를 구독하여 변경사항이 생길 때, 실행되도록 구현되어 있었다.

따라서 `PlanSubscriber` 프로토콜을 채택한 `MockPlanSubscriber` 객체를 만들어 테스트하였다.

- Mock객체

```swift
import Foundation
import Combine

final class MockPlanSubscriber: PlanSubscriber {
    var plans: [Plan]?
    var deletePublisher = PassthroughSubject<Plan, Never>()
    var changePublisher = PassthroughSubject<(Plan, State), Never>()

    func updatePlan(_ plans: [Plan]) {
        self.plans = plans
    }
}
```

- 테스트 객체

```swift 
import XCTest
@testable import ProjectManager

final class PlanManagerViewModelTests: XCTestCase {
    var sut: PlanManagerViewModel!
    var mockTodoPlanSubscriber: MockPlanSubscriber!
    var mockDoingPlanSubscriber: MockPlanSubscriber!
    var mockDonePlanSubscriber: MockPlanSubscriber!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTodoPlanSubscriber = MockPlanSubscriber()
        mockDoingPlanSubscriber = MockPlanSubscriber()
        mockDonePlanSubscriber = MockPlanSubscriber()
        
        sut = PlanManagerViewModel(
            todoViewModel: mockTodoPlanSubscriber,
            doingViewModel: mockDoingPlanSubscriber,
            doneViewModel: mockDonePlanSubscriber
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    ...
    func test_mockPlanSubscriber의_deletePublisher에값이들어오면_planList배열에서삭제된다() {
        // given
        let todoPlan = Plan(title: "산책", body: "강아지 산책시키기", date: Date(), state: .todo)
        let doingPlan = Plan(title: "집안일", body: "설거지, 빨래, 청소기돌리기", date: Date(), state: .doing)
        let donePlan = Plan(title: "공부", body: "MVC, MVP, MVVM 패턴 공부하기", date: Date(), state: .done)
        
        sut.create(todoPlan)
        sut.create(doingPlan)
        sut.create(donePlan)
        let oldPlans = sut.planList
        
        mockTodoPlanSubscriber.deletePublisher.send(todoPlan)
        mockDoingPlanSubscriber.deletePublisher.send(doingPlan)
        mockDonePlanSubscriber.deletePublisher.send(donePlan)
        
        // when
        let newPlans = sut.planList
        
        // then
        XCTAssertNotEqual(oldPlans, newPlans)
    }
}
```

- `mockTodoPlanSubscriber`  : mock 객체를 주입한 sut를 선언
`mockDoingPlanSubscriber` 
`mockDonePlanSubscriber` 

- `mockTodoPlanSubscriber.deletePublisher.send(todoPlan)` : mock 객체의 publisher에 값을 보냄
- 값이 보내지면 `sut` 객체에서 값의 변화를 감지하여 `delete`메서드가 실행되어 실제 `[Plan]` 배열이 달라져있는지 최종 아웃풋으로 변화 확인



## 참고
- [Realm - Mock](https://academy.realm.io/kr/posts/making-mock-objects-more-useful-try-swift-2017/)
- [MartinFowler - MockArticle](https://martinfowler.com/articles/mocksArentStubs.html)
