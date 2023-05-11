# Using Lightweight Migration
> 앱의 변경 사항에 맞게 데이터 모델을 업데이트하기 위해 lightweight(자동) migraion을 요청해라.

## Overview
Core Data는 자동으로 data 이동을 수행할 수 있다 lightweight migration으로!
lightweight migration은 소스와 대상 관리 객체 모델의 차이점을 기반으로 마이그레이션을 추론한다.

- Core Data는 앱의 요구사항이 변경될 때 데이터 모델도 변경될 수 있는데, 이러한 경우 데이터베이스 스키마를 새로 만들고 기존 데이터를 새 스키마로 이동시켜야할 수 있다.
- 그러나 Lightweight migration은 작은 변경 사항에 대해 migration 스크립트를 작성하지 않고도 Core Data가 자동으로 이를 처리해준다.
- 즉, 대상 데이터베이스 스키마를 변경하지 않고도 migration을 수행하는데 Core Data의 원본 데이터 모델과 대상 데이터 모델간의 차이를 분석하고 이를 기반으로 migration을 추론한다.

### Generating an Inferred Mapping Model

자동 Lightweight migration을 수행하기 위해서는 Core Data가 런타임에서 원본과 대상 관리객체 모델을 찾을 수 있어야 한다.
Core Data는 Bundle 클래스의 allBundles 및 allFrameworks 메서드에서 반환되는 번들에서 모델을 찾는다. 그런 다음 Core Data는 영속 entity와 attribute의 스키마 변경을 분석하고 추론된 매핑 모델을 생성한다. 추론된 매핑 모델을 생성하려면 분명한 마이그레이션 패턴에 맞게 변경이 필요하다.
예를 들어 다음과 같은 경우이다.
- attribute 추가
- attribute 제거
- 필수 attribute가 optinal로 변경
- optional attribute가 필수로 변경되고 기본값이 정의
- entity또는 attribute 이름 변경

### Managing Changes to Entities and Properties

엔티티 또는 속성의 이름을 변경하는 경우, 대상 모델의 이름을 원본 모델에서 해당 속성 또는 엔티티의 이름으로 설정할 수 있다. Xcode Data Modeling tool’s property inspector(엔티티나 속성 모두)를 사용하여 관리 객체 모델에서 이름 변경 식별자를 설정할 수 있다. 예를 들어 다음과 같이 할 수 있다.

- Car 엔티티를 Automobile로 이름 변경
- Car의 color 속성을 paintColor로 이름 변경

이름 변경 식별자는 규범적인 이름을 생성하므로, 관리 객체 모델에서 이름 변경 식별자를 원본 모델의 속성 이름으로 설정한다(해당 속성이 이미 이름 변경 식별자를 가지고 있지 않은 경우). 이는 모델의 버전 2에서 속성의 이름을 변경한 다음 버전 3에서 다시 이름을 변경할 수 있는 것을 의미한다. 이러한 이름 변경은 버전 2에서 버전 3으로 이동하거나 버전 1에서 버전 3으로 이동할 때 올바르게 작동한다.

### Managing Changes to Relationships

관계와 관계 유형의 변경 사항도 처리할 수 있다. 새로운 관계를 추가하거나 기존의 관계를 삭제할 수 있다. 또한 속성과 마찬가지로 관계의 이름을 이름 변경 식별자를 사용하여 변경할 수도 있다.
또한 관계를 일대일에서 일대다로 변경하거나 순서가 없는 다대다 관계를 정렬된 관계로 변경할 수도 있다(그 반대도 가능하다).

### Managing Changes to Hierarchies

계층 구조에서 엔티티를 추가, 제거, 이름 변경할 수 있다. 또한 새로운 상위 또는 하위 엔티티를 만들고 속성을 엔티티 계층 구조에서 위로 또는 아래로 이동시킬 수 있다. 엔티티를 계층 구조에서 제거할 수도 있다. 그러나 기존의 두 엔티티가 원본에서 공통 상위 엔티티를 공유하지 않는 경우, 대상에서도 공통 상위 엔티티를 공유할 수 없다. 즉, 엔티티 계층 구조를 병합할 수는 없다.

### Confirming Whether Core Data Can Infer the Model

Core Data는 실제로 마이그레이션 작업을 수행하지 않고 원본 모델과 대상 모델 간의 매핑 모델을 추론할 수 있는지 미리 확인하고 싶다면 `NSMappingModel`의 `inferredMappingModel(forSourceModel:destinationModel:)` 메서드를 사용할 수 있다. 이 메서드는 Core Data가 추론된 모델을 생성할 수 있는 경우 해당 모델을 반환하고, 그렇지 않은 경우 nil을 반환한다.

만약 데이터 변경이 자동 마이그레이션의 기능을 초과한다면, heavyweight 마이그레이션(일반적으로 수동 마이그레이션이라고 함)을 수행할 수 있다.

### Requesting Lightweight Migration

Lightweight Migration을 요청하기 위해서는 `addPersistentStore(ofType:configurationName:at:options:)` 메서드에 전달하는 `options` 딕셔너리에서 값을 설정한다. `NSMigratePersistentStoresAutomaticallyOption` 키와 `NSInferMappingModelAutomaticallyOption` 키에 대응하는 값을 `true`로 설정한다.

```swift
let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
do {
    try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
} catch {
    fatalError("Failed to add persistent store: \(error)")
}

```

## 참고 
- [Using Lightweight Migration 공식문서](https://developer.apple.com/documentation/coredata/using_lightweight_migration#2903988)
- [iamgroot velog](https://velog.io/@iamgroot1231/Using-Lightweight-Migration)
