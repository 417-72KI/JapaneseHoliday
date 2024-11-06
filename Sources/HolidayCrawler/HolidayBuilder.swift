import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import Common

enum HolidayBuilder {}

extension HolidayBuilder {
    static func build(_ holidays: [Holiday], flatten: Bool = false) -> any SyntaxProtocol {
        SourceFileSyntax {
            for name in ["Foundation", "Common"] {
                ImportDeclSyntax(
                    path: ImportPathComponentListSyntax {
                        ImportPathComponentSyntax(name: .identifier(name))
                    }
                )
            }
            if flatten {
                VariableDeclSyntax(
                    leadingTrivia: [.newlines(2)],
                    modifiers: [
                        // DeclModifierSyntax(name: .keyword(.public))
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("Holidays"))),
                    type: TypeAnnotationSyntax(type: DictionaryTypeSyntax(key: TypeSyntax("String"), value: TypeSyntax("Holiday"))),
                    initializer: InitializerClauseSyntax(value: dictionary(holidays))
                )
            } else {
                VariableDeclSyntax(
                    leadingTrivia: [.newlines(2)],
                    modifiers: [
                        // DeclModifierSyntax(name: .keyword(.public))
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("Holidays"))),
                    type: TypeAnnotationSyntax(
                        type: DictionaryTypeSyntax(
                            key: TypeSyntax("Int"),
                            value: DictionaryTypeSyntax(
                                key: TypeSyntax("Int"),
                                value: DictionaryTypeSyntax(
                                    key: TypeSyntax("Int"),
                                    value: TypeSyntax("Holiday")
                                )
                            )
                        )
                    ),
                    initializer: InitializerClauseSyntax(value: dictionary(Dictionary(grouping: holidays, by: \.year)))
                )
            }
        }
    }
}

private extension HolidayBuilder {
    static func dictionary(_ holidaysByYear: [Int: [Holiday]]) -> some ExprSyntaxProtocol {
        DictionaryExprSyntax(rightSquare: .rightSquareToken(leadingTrivia: .newline)) {
            DictionaryElementListSyntax {
                for year in holidaysByYear.keys.sorted() {
                    DictionaryElementSyntax(
                        leadingTrivia: .newline,
                        key: IntegerLiteralExprSyntax(integerLiteral: year),
                        value: dictionary(holidaysByMonth: Dictionary(grouping: holidaysByYear[year]!, by: \.month))
                    )
                }
            }
        }
    }

    static func dictionary(holidaysByMonth: [Int: [Holiday]]) -> some ExprSyntaxProtocol {
        DictionaryExprSyntax(rightSquare: .rightSquareToken(leadingTrivia: .newline)) {
            DictionaryElementListSyntax {
                for month in holidaysByMonth.keys.sorted() {
                    DictionaryElementSyntax(
                        leadingTrivia: .newline,
                        key: IntegerLiteralExprSyntax(integerLiteral: month),
                        value: dictionary(holidaysByDay: holidaysByMonth[month]!)
                    )
                }
            }
        }
    }

    static func dictionary(holidaysByDay: [Holiday]) -> some ExprSyntaxProtocol {
        DictionaryExprSyntax(rightSquare: .rightSquareToken(leadingTrivia: .newline)) {
            DictionaryElementListSyntax {
                for holiday in holidaysByDay {
                    DictionaryElementSyntax(
                        leadingTrivia: .newline,
                        key: IntegerLiteralExprSyntax(integerLiteral: holiday.day),
                        value: element(holiday)
                    )
                }
            }
        }
    }
}

private extension HolidayBuilder {
    static func dictionary(_ holidays: [Holiday]) -> some ExprSyntaxProtocol {
        DictionaryExprSyntax(rightSquare: .rightSquareToken(leadingTrivia: .newline)) {
            DictionaryElementListSyntax { holidays.map(dictonaryElement(_:)) }
        }
    }

    static func dictonaryElement(_ holiday: Holiday) -> DictionaryElementSyntax {
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
            value: element(holiday)
        )
    }
}

private extension HolidayBuilder {
    static func element(_ holiday: Holiday) -> some ExprSyntaxProtocol {
        FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("Holiday"))) {
            LabeledExprSyntax(
                label: "year",
                expression: IntegerLiteralExprSyntax(integerLiteral: holiday.year)
            )
            LabeledExprSyntax(
                label: "month",
                expression: IntegerLiteralExprSyntax(integerLiteral: holiday.month)
            )
            LabeledExprSyntax(
                label: "day",
                expression: IntegerLiteralExprSyntax(integerLiteral: holiday.day)
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
    }
}

