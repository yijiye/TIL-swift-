# 큐 
> 시간복잡도 문제 해결

- 배열의 특성상 큐는 먼저 들어온 값이 먼저 나가게 되고 그러면 한칸씩 앞으로 당겨져야 한다 이때 시간 복잡도는 ```O(n)```이 된다.
- 이러한 문제를 해결하기 위해 자주 사용되는 2가지 방법이 있다.

### 1. 커서큐

```swift
struct Queue<T> {
    var queue: [T?] = []
    var head: Int = 0
    
    mutating func dequeue() -> T? {
        guard head <= queue.count, let element = queue[head] else { return nil }
        queue[head] = nil
        head += 1
        
        if head > 50 { // nil로 반환된 값을 삭제해주는 기준
            queue.removeFirst(head)
            head = 0
        }
        return element
    }
```

- 값을 하나씩 당겨줄 필요 없이 ```head``` 포인터를 이용하여 위치를 입력해 주어 해결하는 방법이다.
- head가 큐배열의 수보다 작고 head의 위치에 있는 큐배열의 값이 존재하면 그 값은 nil로 반환하고 head는 +1을 해서 옆으로 이동시켜 준다.
- 계속해서 반복하면 nil이 남아있게 되므로 50개를 기준으로 nil을 모두 삭제해주고 head도 다시 0으로 초기화 시켜주어 문제를 해결

### 2. 더블스택큐

```swift
struct DoubleStackQueue<T> {
    var input: [T] = []
    var output: [T] = []
    var isEmpty : Bool {
        return input.isEmpty && output.isEmpty
    }
    
    var count: Int {
        return input.count + output.count
    }
    
    mutating func enqueue(_ data: T) {
        input.append(data)
    }
    
    mutating func dequeue() -> T? {
        if output.isEmpty {
            output = input.reversed()
            input.removeAll() // 중복값으로 들어가지 않게 해주려고 input.removeAll을 한다.
        }
        return output.removeLast()
    }
}
```
- 두개의 빈 배열을 만들어 주고 enqueue로 값을 넣어주고 그 값을 ```reversed```해주어 값을 반대로 뒤집은 다음 마지막 값을 제거하여 반환하여 시간복잡도가 그대로 O(1)로 해결해 줄 수 있는 방법이 있다.

## 참고
[개발자아라찌](https://apple-apeach.tistory.com/8)
[개발자소들이](https://babbab2.tistory.com/84)
[dudu-velog](https://velog.io/@aurora_97/Swift-큐)

