# Type Casting

> 인스턴스의 타입을 확인하는 용도
부모 혹은 자식 클래스의 타입으로 사용할 수 있는지 확인하는 용도

- 주로 클래스 인스턴스에서 많이 사용
- 딕셔너리, Any, AnyObject 에서 많이 사용
- 타입캐스팅의 종류
  - is : 타입을 확인할때 사용
  - as? : 자식 클래스의 인스턴스로 사용할 수 있도록 컴파일러에게 확인
  - as! : 강제다운캐스팅

### Defining a Class Hierarchy for Type Casting

```swift
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
```
- library 는 Movie와 Song의 인스턴스를 가지고 있지만 타입은 한가지의 값으로 확인할 수 있기 때문에 Movie와 Song의 공통이 되는 부모클래스인 MediaItem을 추론하고 있다.
- native type에 접근하고 싶으면 다운캐스팅으로 확인이 필요함!

### is (타입이 맞는지 확인하는 방법)

```swift
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("movieCount: \(movieCount), songCount: \(songCount)") // movieCount: 2, songCount: 3
```
library 를 for문을 돌려서 내부를 확인할때 Movie가 맞으면 movieCount의 수를 올리고, Song이 맞으면 songCount를 올리게끔 만든 코드

### as? as! (다운캐스팅)

> 부모클래스의 타입을 자식클래스의 타입으로 캐스팅하는 것

MediaItem을 상속받은 Movie, Song 의 프로퍼티값에 접근하기 위해 사용
```swift
for item in library { 
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}
```
- 현재 item 은 MediaItem의 인스턴스이기 때문에 Moive 일수도 있고 Song 일수도 있고 MediaItem 일수도 있다.
- Movie의 프로퍼티 director에 접근하려고 하면 as? 를 사용해서 안전하게 값을 추출한다 (옵셔널)
- as! 는 강제추출이라고 볼 수 있다. (값이 확실할때만 사용)
  - as? 는 실패시 nil을 반환하지만 as! 는 런타임 오류 발생
- 캐스팅은 원래의 값을 바꾸거나 인스턴스를 수정할 수 없다. 단지 값에 접근만 할 뿐!!

### as
- 캐스팅하려는 타입이 같은 타입이거나 부모클래스 타입이라는 것을 아는 경우는 항상 성공하는 다운캐스팅으로 사용할 수 있다.

### Type Casting for Any and AnyObject

- Any : 함수 타입을 포함한 모든 타입 가능
- AnyObject : 모든 클래스 타입

**그러나 늘 구체적으로 타입을 명시해주는 것이 좋다**

- things 라는 Any 타입의 빈 배열은 어떤 타입이든 넣어줄 수 있다.
```swift
var things: [Any] = []

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })
```

- switch 문으로 case를 넣어주고 그 안에서 is, as 로 타입을 확인하면 맞다면 case 문이 실행되도록 구현

```swift
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
```
## 📚 참고
[타입캐스팅 공식문서](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html)
