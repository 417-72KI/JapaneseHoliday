import Foundation
import SwiftSyntax
import SwiftBasicFormat

final class Format: BasicFormat {
    override func requiresIndent(_ node: some SyntaxProtocol) -> Bool {
        if node.is(DictionaryExprSyntax.self),
           let parent = node.parent,
           parent.is(DictionaryElementSyntax.self) {
            return false
        }
        return super.requiresIndent(node)
    }
}
