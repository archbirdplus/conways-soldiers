
extension Collection {
    func minValue<V>(by f: (Element) -> V) -> V where V: Comparable {
        return self.dropFirst().reduce(f(self.first!)) { r, x in Swift.min(r, f(x)) }
    }
    func maxValue<V>(by f: (Element) -> V) -> V where V: Comparable {
        return self.dropFirst().reduce(f(self.first!)) { r, x in Swift.max(r, f(x)) }
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    static var dirs: [Point] = [Point(-1, 0), Point(0, -1), Point(1, 0), Point(0, 1)]

    static func +(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    var neighbors: [Point] {
        [Point(x-1, y), Point(x, y-1), Point(x+1, y), Point(x, y+1)]
    }
}

class Board {
    var pieces: Set<Point>

    init(_ pieces: Set<Point>) { self.pieces = pieces }

    static func random() -> Board {
        var pieces: Set<Point> = [Point(0, -1)]
        var iter_max = 100
        outer: while iter_max > 0 && pieces.count < 6 {
            let a = pieces.randomElement()!
            iter_max -= 1
            for d in Point.dirs {
                guard !pieces.contains(a + d) && !pieces.contains(a + d + d) && a.y + d.y*2 > 0
                    else { continue }
                pieces.remove(a)
                pieces.insert(a + d)
                pieces.insert(a + d + d)
                continue outer
            }
        }
        return Board(pieces)
    }

    func render(highlight: Point? = nil) -> String {
        var str = ""
        let minX = pieces.minValue { p in p.x }
        let maxX = pieces.maxValue { p in p.x }
        let minY = pieces.minValue { p in p.y }
        let maxY = pieces.maxValue { p in p.y }
        str += "\n"
        str += "\tABCDEFGHJIKLMNOPQRSTUVWXYZ"
        for y in minY...maxY {
            str += "\n\(y)\t"
            for x in minX...maxX {
                let a = Point(x, y)
                str += a == highlight ? "*" : pieces.contains(a) ? "X" : " "
            }
        }
        return str
    }

    func move(_ x: Int, _ y: Int, _ d: Int) -> Bool {
        let minX = pieces.minValue { p in p.x }

        let old = Point(x+minX, y)
        let dir = Point.dirs[d]
        let mid = old + dir
        let new = mid + dir
        guard   pieces.contains(old) &&
                pieces.contains(mid) &&
                !pieces.contains(new) else {
            print(render(highlight: old))
            return false
        }
        pieces.remove(old)
        pieces.remove(mid)
        pieces.insert(new)
        return true
    }
}

