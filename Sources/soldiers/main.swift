// The Swift Programming Language
// https://docs.swift.org/swift-book

var board = Board.random()

print("Welcome to Conway's Soldiers!")
print("Move a piece by specifying the coordinates x (letter), y (number), and direction (hjkl), e.g. 'A1l'.")
print("Try to reduce the board to a single piece as high as possible!")

print(board.render())

while let line = readLine() {
    var err = true

    defer {
        if err {
            print("invalid move!")
        }
    }

    let alpha = "abcdefghijklmnopqrstuvwxyz"
    let hklj = "hklj"

    let xIndex: String.Index
    let x: Int
    do {
        // uncaught !
        xIndex = alpha.firstIndex(of: line.first!.lowercased().first!)!
        x = alpha.distance(from: alpha.startIndex, to: xIndex)
    } catch {
        continue
    }
    guard let y = Int(line.dropFirst().prefix(while: { x in x.isNumber }))
        else { continue }
    guard let dirIndex = hklj.firstIndex(of: line.last!)
        else { continue }
    let dir = alpha.distance(from: alpha.startIndex, to: dirIndex)
    print("moving \(alpha[xIndex]):\(y) in direction \(hklj[dirIndex])")
    guard board.move(x, y, dir) else {
        continue
    }

    err = false

    print(board.render())
}

