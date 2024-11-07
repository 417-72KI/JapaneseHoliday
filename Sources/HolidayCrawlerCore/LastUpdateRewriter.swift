import Foundation
import SwiftSyntax
import SwiftParser

package func rewrite(file: URL, withLastUpdate lastUpdate: Date) throws {
    let syntax = Parser.parse(source: String(decoding: try Data(contentsOf: file), as: UTF8.self))
    let rewrited = LastUpdateRewriter(lastUpdate: lastUpdate).visit(syntax)
    try Data(rewrited.formatted().description.utf8).write(to: file)
}

private final class LastUpdateRewriter: SyntaxRewriter {
    let lastUpdate: Date

    init(lastUpdate: Date, viewMode: SyntaxTreeViewMode = .sourceAccurate) {
        self.lastUpdate = lastUpdate
        super.init(viewMode: viewMode)
    }

    override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        if var binding = node.bindings.first,
           binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "lastUpdate" {
            binding.initializer = InitializerClauseSyntax(
                value: FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: "Date")) {
                    LabeledExprSyntax(
                        label: "timeIntervalSince1970",
                        expression: FloatLiteralExprSyntax(literal: .floatLiteral("\(lastUpdate.timeIntervalSince1970)"))
                    )
                }
            )
            var node = node
            node.bindings = [binding]
            return DeclSyntax(node)
        }
        return super.visit(node)
    }
}
