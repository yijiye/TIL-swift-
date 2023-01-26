# remove method 

### 1. last 
> 마지막 값을 삭제하지 않고 반환한다. 옵셔널이기 때문에 빈 배열일 경우 nil을 반환한다.

```swift!
var array: [Int] = [1, 2, 3, 4, 5]

array.last // 5
print(array) // [1, 2, 3, 4, 5]
```
### 2. dropLast(Int)
> 뒤에서 Int 만큼 값을 제외하고 나머지 값을 반환한다. 이때 제외한 값은 삭제되지 않는다.

```swift
array.dropLast(2) // [1, 2, 3]
print(array) // [1, 2, 3, 4, 5]
```
### 3. popLast()
> 마지막 값을 삭제하고 반환한다. 옵셔널이기 때문에 빈 배열일 경우 nil을 반환한다.

```swift
array.popLast() // 5
print(array) // [1, 2, 3, 4]
```
### 4. removeLast()
> 마지막 값을 삭제하고 반환한다. 값이 늘 있어야 하므로 배열이 비어있으면 오류가 발생한다.

```swift
array.removeLast() // 4
print(array) // [1, 2, 3]
```
### 5. removeLast(Int)
> 뒤에서 Int 만큼 값을 제외하고 나머지 값을 반환한다. 이때 제외한 값은 삭제된다.
```swift
array.removeLast(2) // [1]
print(array) // [1]
```
