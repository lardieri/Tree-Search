struct Node {
    let tag: Int
    let name: String
    var children: [Node] = []

    init(_ tag: Int, name: String) {
        self.tag = tag
        self.name = name
    }

    enum SearchStrategy {
        case breadthFirst
        case depthFirst
    }

    func findNodeByTag(_ tag: Int, using strategy: SearchStrategy) -> Node? {
        let node: Node?
        switch strategy {
            case .breadthFirst:
                node = breadthFirst(tag)

            case .depthFirst:
                node = depthFirst(tag)
        }

        return node
    }

    private func depthFirst(_ tag: Int) -> Node? {
        if self.tag == tag {
            return self
        }

        for child in children {
            let result = child.depthFirst(tag)
            if result != nil {
                return result
            }
        }

        return nil
    }

    private func breadthFirst(_ tag: Int) -> Node? {
        var level = 0
        var node: Node? = nil
        var keepGoing = true
        repeat {
            (node, keepGoing) = breadthFirstWorker(tag, level: level)
            level += 1
        } while node == nil && keepGoing

        return node
    }


    private func breadthFirstWorker(_ tag: Int, level: Int) -> (node: Node?, keepGoing: Bool) {
        if level == 0 {
            if self.tag == tag {
                return (self, false)
            }

            return (nil, children.count > 0)
        }

        let newLevel = level - 1
        var childSaysKeepGoing = false
        for child in children {
            let (node, keepGoing) = child.breadthFirstWorker(tag, level: newLevel)
            childSaysKeepGoing = childSaysKeepGoing || keepGoing
            if node != nil {
                return (node, childSaysKeepGoing)
            }
        }

        return (nil, childSaysKeepGoing)
    }

}

var node1 = Node(1, name: "node1")
var node2 = Node(2, name: "node2")
var node3B = Node(3, name: "node3 Broad")
var node3D = Node(3, name: "node3 Deep")
var node4 = Node(4, name: "node4")
var node5 = Node(5, name: "node5")

// Old Crusty says: order is important here!
// Assign children before assigning to parent,
// otherwise you're not modifying the struct that you think you are.
node3B.children = [node5]
node2.children = [node3D]
node1.children = [node2, node3B, node4]

let strategy: Node.SearchStrategy = .breadthFirst

print("Tag 1: \(node1.findNodeByTag(1, using: strategy)?.name ?? "nil")")
print("Tag 2: \(node1.findNodeByTag(2, using: strategy)?.name ?? "nil")")
print("Tag 3: \(node1.findNodeByTag(3, using: strategy)?.name ?? "nil")")
print("Tag 4: \(node1.findNodeByTag(4, using: strategy)?.name ?? "nil")")
print("Tag 5: \(node1.findNodeByTag(5, using: strategy)?.name ?? "nil")")
print("Tag 6: \(node1.findNodeByTag(6, using: strategy)?.name ?? "nil")")
