# 고차함수 (map, filter, reduce) 함수로 직접 구현해보기

- 예시를 작성하여 그 타입으로 만들어 보기

각 고차함수가 어떤식으로 기능을 하는지 예시를 들어 확인해보면서 작성해보았다.
```swift
extension Array {
    func myMap(_ transform: (Int) -> Int) -> [Int] {
        
        var result: [Int] = []
        
        for num in self {
            let value = transform(num as! Int)
            result.append(value)
        }
        return result
    }
    
    func myFilter(_ transform: (String) -> Bool) -> [String] {
        
        var filterResult: [String] = []
        
        for word in self {
            let validValue = transform(word as! String)
            if validValue {
                filterResult.append(word as! String)
            }
        }
        return filterResult
    }
    
    func myReduce(_ firstTransform: Int, _ secondTransform: (Int, Int) -> Int) -> Int {
        var result: Int = firstTransform
        
        //[1,2,3] -> 0+1, 1+2, 3+3
        for num in self {
            result = secondTransform(result, num as! Int)
        }
        return result
    }


}

let numberArray: [Int] = [1,2,3,4,5]
let mapNumberArray = numberArray.myMap { $0 + 1}
print(mapNumberArray)

//filter 예시
let someString: [String] = ["one", "two", "three", "four"]
let threeWords: [String] = someString.filter { $0.count < 4}
print(threeWords)
// myFilterTest
let testThreeWords: [String] = someString.myFilter { $0.count < 4}
print(testThreeWords)

//reduce 예시: 요소를 결합한 결과를 반환
let array: [Int] = [1,2,3]
var sum = array.reduce(0, +)
print(sum)
//myReduceTest
var testSum = array.myReduce(0, { $0 + $1 } )
print(testSum)
```


- 제네릭을 이용한 방법
```swift
extension Array {
    func myMap<T>(_ transform: (Self.Element) -> T) -> [T] {
        
        var result: [T] = []
        
        for num in self {
            let value = transform(num)
            result.append(value)
        }
        return result
    }
    
    func myFilter(_ transform: (Self.Element) -> Bool) -> [Self.Element] {
        
        var filterResult: [Self.Element] = []
        
        for word in self {
            guard transform(word) else { continue }
            filterResult.append(word)
        }
        return filterResult
    }
    
    func myReduce<T>(_ firstTransform: T, _ secondTransform: (T, T) -> T) -> T {
        var result: T = firstTransform
        
        //[1,2,3] -> 0+1, 1+2, 3+3
        for num in self {
            result = secondTransform(result, num as! T)
        }
        return result
    }


}

let array = [1,2,3,4,5,10]
let stringArray = array.myMap{ String($0) }
print(stringArray)

let filteredArray = array.myFilter{ $0 % 2 == 0 }
print(filteredArray)

let reduceArray = array.myReduce(0, +)
print(reduceArray)

```

- transform의 Self.Element란?
transform 메서드가 실행되는 collection에 저장된 element의 유형을 나타낸다. `self`키워드는 collection의 실제 유형을 나타내고 `Element`는 collection이 가지고 있는 요소의 유형에 대한 type alias 이다. 즉, Self.Element란 transform에 의해 변환되어 반환될 요소의 유형을 나타내는 것!


