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
