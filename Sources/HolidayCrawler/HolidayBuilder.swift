import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import Common

enum HolidayBuilder {}

extension HolidayBuilder {
    static func build(_ holidays: [Holiday]) -> any SyntaxProtocol {
        SourceFileSyntax {
            for name in ["Foundation", "Common"] {
                ImportDeclSyntax(
                    path: ImportPathComponentListSyntax {
                        ImportPathComponentSyntax(name: .identifier(name))
                    }
                )
            }

            VariableDeclSyntax(
                leadingTrivia: [.newlines(2)],
                modifiers: [
                    // DeclModifierSyntax(name: .keyword(.public))
                ],
                .let,
                name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("holidays"))),
                type: TypeAnnotationSyntax(type: DictionaryTypeSyntax(key: TypeSyntax("String"), value: TypeSyntax("Holiday"))),
                initializer: InitializerClauseSyntax(value: elements(holidays))
            )
        }
    }
}

private extension HolidayBuilder {
    static func elements(_ holidays: [Holiday]) -> some ExprSyntaxProtocol {
        DictionaryExprSyntax(rightSquare: .rightSquareToken(leadingTrivia: .newline)) {
            DictionaryElementListSyntax { holidays.map(element(_:)) }
        }
    }

    static func element(_ holiday: Holiday) -> DictionaryElementSyntax {
        DictionaryElementSyntax(
            leadingTrivia: .newline,
            key: StringLiteralExprSyntax(
                openingQuote: .stringQuoteToken(),
                segments: [
                    .stringSegment(
                        StringSegmentSyntax(
                            content: .identifier(holiday.date),
                            trailingTrivia: [.spaces(0)]
                        )
                    )
                ],
                closingQuote: .stringQuoteToken()
            ),
            value: FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("Holiday"))) {
                LabeledExprSyntax(
                    label: "year",
                    expression: IntegerLiteralExprSyntax(literal: .integerLiteral("\(holiday.year)"))
                )
                LabeledExprSyntax(
                    label: "month",
                    expression: IntegerLiteralExprSyntax(literal: .integerLiteral("\(holiday.month)"))
                )
                LabeledExprSyntax(
                    label: "day",
                    expression: IntegerLiteralExprSyntax(literal: .integerLiteral("\(holiday.day)"))
                )
                LabeledExprSyntax(
                    label: "name",
                    expression: StringLiteralExprSyntax(
                        openingQuote: .stringQuoteToken(),
                        segments: [
                            .stringSegment(
                                StringSegmentSyntax(
                                    content: .identifier(holiday.name),
                                    trailingTrivia: [.spaces(0)]
                                )
                            )
                        ],
                        closingQuote: .stringQuoteToken()
                    )
                )
            }
        )
    }
}

