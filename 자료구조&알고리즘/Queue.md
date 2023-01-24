# Stack and Queue

![](https://i.imgur.com/wl64yPS.png)


**Queue : FIFO (First In, First Out)**
- 먼저 들어온 값이 아래부터 순차적으로 쌓인다.
- 값을 빼내올때는 먼저 들어온 값 부터 빼낸다.


### Queue
```swift
struct Queue<T> {
    
    var array: [T] = []
    init() { }
    
    var isEmpty : Bool {
        return array.isEmpty
    }
    
    var peek: T? {
        return array.first
    }
    
    mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }
    
    mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
}
```
- ```isEmpty``` : 비어있는지 확인, true면 비어있으므로 ```array.isEmpty```를 반환
- ```peek```: 첫번째 값을 삭제하지 않고 반환
- ```func enqueue```: 값을 넣어주는 메서드
- ```func dequeue```: 첫번째 값을 삭제하고 반환하는 메서드 

```swift
extension Queue: CustomStringConvertible {
    var description: String {
        return String(describing: array)
    }
}
```
- ```CustomStringConvertible``` 프로토콜을 준수한다.
- String 값으로 반환하여 출력 (보기쉽게하기위해)

**출력문**
```swift
var queue = Queue<Int>()
queue.enqueue(20)
queue.enqueue(30)
queue.enqueue(3)
queue.enqueue(50)
print(queue)
queue.dequeue()
print(queue)
```
```
[20, 30, 3, 50] // enqueue로 값을 입력
[30, 3, 50] // dequeue로 첫번째 값을 삭제
```
#### Dequeue 시에 하나씩 앞당겨지는 것을 최소화하기 위한 방법 (head적용)

```swift
public mutating func dequeue() -> T? {
        guard head <= queue.count, let element = queue[head] else { return nil }
        queue[head] = nil
        head += 1
        
        if head > 50 {
            queue.removeFirst(head)
            head = 0
        }
        return element
    }
```
- 개발자 소들이에서 가져온 코드인데, 50개를 지날때 마다 head앞에 있는 값들을 nil로 바꿔주고 그 값을 제거해주는 방법으로 불필요한 데이터를 삭제하는 방법이 있다.

## 참고
[개발자-소들이](https://babbab2.tistory.com/84)
