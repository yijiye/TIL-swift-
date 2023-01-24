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
