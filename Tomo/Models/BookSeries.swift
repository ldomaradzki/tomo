import Foundation

/// A book's membership in a published series. Position remains text so EPUB
/// numbering such as `2.2.1` is preserved exactly as supplied.
nonisolated struct BookSeries: Codable, Hashable, Sendable {
    var name: String
    var position: String?

    /// Natural numeric comparison for EPUB group positions. Non-numeric
    /// positions sort after numeric ones; missing positions always sort last.
    static func positionComesBefore(
        _ lhs: String?,
        _ rhs: String?,
        ascending: Bool = true
    ) -> Bool {
        let left = normalizedPosition(lhs)
        let right = normalizedPosition(rhs)
        if left == nil { return false }
        if right == nil { return true }
        guard let left, let right else { return false }

        let leftNumbers = numericComponents(left)
        let rightNumbers = numericComponents(right)
        if let leftNumbers, let rightNumbers {
            for (x, y) in zip(leftNumbers, rightNumbers) where x != y {
                return ascending ? x < y : x > y
            }
            if leftNumbers.count != rightNumbers.count {
                return ascending
                    ? leftNumbers.count < rightNumbers.count
                    : leftNumbers.count > rightNumbers.count
            }
            return false
        }
        if leftNumbers != nil { return true }
        if rightNumbers != nil { return false }

        let result = left.localizedStandardCompare(right)
        return ascending ? result == .orderedAscending : result == .orderedDescending
    }

    private static func normalizedPosition(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func numericComponents(_ value: String) -> [Int]? {
        let components = value.split(separator: ".", omittingEmptySubsequences: false)
        guard !components.isEmpty else { return nil }
        let numbers = components.compactMap { Int($0) }
        guard numbers.count == components.count, numbers.allSatisfy({ $0 >= 0 }) else {
            return nil
        }
        return numbers
    }

    static func isStandardPosition(_ value: String) -> Bool {
        guard let normalized = normalizedPosition(value) else { return false }
        return numericComponents(normalized) != nil
    }
}
