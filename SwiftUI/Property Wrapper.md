# Property Wrapper

## @State
뷰 계층에 저장할 주어진 값 타입을 위한 `Source Of Truth (SOT)` 로 State를 사용해라.
- SOT는 Data의 시작점이 어디인지를 나타낸다.

이니셜라이저가 필요하다.
SwiftUI가 제공하는 스토리지 관리와 충돌할 수 있는 memberwise 이니셜라이저에서 설정하는 것을 방지하기 위해 `private`으로 선언해야한다.

```swift
struct PlayButton: View {
    @State private var isPlaying: Bool = false // Create the state.

    var body: some View {
        Button(isPlaying ? "Pause" : "Play") { // Read the state.
            isPlaying.toggle() // Write the state.
        }
    }
}
```

State의 기본값에 접근하려면 `wrappedValue` 속성을 사용한다. wrappedValue는 연산프로퍼티로 State 구조체는 Set 으로 Old, new value를 비교하여 값이 다르면 새로운 view로 다시 그리는 과정을 거친다.

State 속성을 하위 뷰에 전달하면, SwiftUI는 컨테이너 뷰에서 값이 변경될 때마다 하위 뷰를 업데이트하지만, 하위 뷰는 값을 수정할 수 없다. 하위 뷰가 State의 저장된 값을 수정할 수 있도록 하려면, Binding을 전달하면 된다. 속성 이름 앞에 $를 붙여서 얻을 수 있는 State의 `projectedValue`에 액세스하여 State 값에 대한 Binding을 얻을 수 있습니다.

즉, Binding을 사용하여 State 속성을 뷰에 전달하면 뷰는 해당 State 속성의 변경을 Set을 통해 감시하고, 값이 변화했다면 뷰를 다시 그리도록 하여 뷰와 State를 동기화할 수 있다.


```swift
struct PlayerView: View {
    @State private var isPlaying: Bool = false // Create the state here now.

    var body: some View {
        VStack {
            PlayButton(isPlaying: $isPlaying) // Pass a binding.

            // ...
        }
    }
}
```

## @Observed Object
SOT가 아니기 때문에 이니셜라이저가 필요하지 않다. SOT로 부터 전달받고 StateObject를 관찰한다.
즉, 관찰할 수 있는 Object를 의미한다.

```
SuperView -> 자식뷰 A,B,C 
```
가 있다고 가정하면, SuperView는 StateObject를 가진다.(데이터의 시작점이니까)
반면, 자식뷰 A,B,C는 데이터의 시작점이 아니므로 ObservedObject를 가진다.

기본적으로 `ObservableObject`는 `@Published` 속성이 변경되기 전에 변경된 값을 방출하는 `objectWillChange`를 Combine한다. 

```swift
class Contact: ObservableObject {
    @Published var name: String
    @Published var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func haveBirthday() -> Int {
        age += 1
        return age
    }
}

let john = Contact(name: "John Appleseed", age: 24)
cancellable = john.objectWillChange
    .sink { _ in
        print("\(john.age) will change")
}
print(john.haveBirthday())
// Prints "24 will change"
// Prints "25"
```


```
Model -> ContentView -> ToggleView(자식뷰)
```
ContentView는 @State, 
ToggleView는 @ObservabelObject이다.

## @EnvironmentObject
```bash
"it’s shared data that every view can read if they want to."
```
```
Model -> App's views
```

어디서든 Model을 참조할 수 있는, 모든 view가 읽을 수 있는 shared data를 뜻한다.

`EnvironmentObject`는 관찰 가능한 객체가 바뀔 때마다 현재 뷰를 무효화한다. 속성을 환경 객체로 선언하는 경우, `environmentObject(_:)` 를 호출하여 부모뷰에 해당 모델 객체를 설정해야 한다.

```swift
import Foundation

class Environment: ObservableObject {
    @Published var isTrue: Bool = false
}

// MARK: ToggleView
import SwiftUI

struct ToggleView: View {
    @State private var isStateToggleOn: Bool = false
    @EnvironmentObject private var isEnvironmentToggleOn: Environment
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 2)
                .foregroundColor(.red)
            
            VStack {
                Text(isStateToggleOn ? "State On" : "State Off")
                
                Toggle("State", isOn: $isStateToggleOn)
                    .padding()
                Toggle(isOn: $isEnvironmentToggleOn.isTrue) {
                    Text("Environment")
                }
                .padding()
            }
        }
        .padding()
        
    }
}

struct EnvironmentToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView().environmentObject(Environment())
    }
}

// MARK: ContentView
import SwiftUI

struct ContentView: View {
    @StateObject var environment = Environment()
    
    var body: some View {
        VStack {
            HStack {
                ToggleView()
                    .environmentObject(environment)
                ToggleView()
                    .environmentObject(environment)
            }
            .frame(height: 250)
            .padding(.bottom)
            
            HStack {
                ToggleView()
                    .environmentObject(environment)
                ToggleView()
                    .environmentObject(environment)
            }
            .frame(height: 250)
            .padding(.top, 30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

- Environment 토글을 On 하면 4개의 toggle이 모두 같은 반응을 보이도록 구현한 예시

1. ObservableObject를 준수하는 Class타입이 필요하다.
2. 자식뷰인 ToggleView에서 @EnvironmentObject를 선언해주고 Binding으로 Environment의 isTrue 프로퍼티를 참조한다.
3. 부모뷰인 ContentView에  @StateObject를 선언해주어 toggleView의 environmentObject에 넣어주어 변하는 값을 전달해준다.
4. ToggleView에서 binding을 통해 변화를 전달한다. 


## 참고
- [@State 공식문서](https://developer.apple.com/documentation/swiftui/state)
- [@ObservableObject 공식문서](https://developer.apple.com/documentation/Combine/ObservableObject)
- [@EnvironmentObject 공식문서](https://developer.apple.com/documentation/swiftui/environmentobject)
- [zedd 티스토리](https://zeddios.tistory.com/964)
