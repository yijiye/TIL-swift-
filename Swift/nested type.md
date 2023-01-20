# Nested Types
> class, struct, enumeration 은 중첩하여 사용할 수 있다.

```swift

struct BlackjackCard {

    // 중첩타입 enum Suit
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    // 중첩타입 enum Rank
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values { // enum Rank의 중첩타입 struct Values
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }

    // BlackjackCard 구조체의 프로퍼티
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}
let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades) // memberwise initializer 
print("theAceOfSpades: \(theAceOfSpades.description)")
// Prints "theAceOfSpades: suit is ♠, value is 1 or 11"


//BlackjackCard의 heartSymbol에 접근하는 방법 => rawValue 이용
let heartSymbol = BlackjackCard.Suit.hearts.rawValue
// heartsSymbol is "♡"
```
- 정의된 문맥 밖에서 중첩타입의 값에 접근하려면 rawValue를 이용할 수 있다.
- struct 에서는 memberwise initializer 기능이 구현되어 따로 initializer를 생성해 주지 않아도 자동으로 생성한다. 
- class 에서는 이니셜라이저를 정의해주어야 한다.

## 📚 참고

[중첩타입 공식문서](https://docs.swift.org/swift-book/LanguageGuide/NestedTypes.html)
