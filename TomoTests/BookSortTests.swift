import Foundation
import Testing

@testable import Tomo

@MainActor
@Suite("BookSort")
struct BookSortTests {

    @Test
    func seriesSortGroupsByNameThenNaturalPosition() {
        let seriesTen = makeBook("Saga Ten", series: [BookSeries(name: "Saga", position: "10")])
        let seriesTwo = makeBook("Saga Two", series: [BookSeries(name: "Saga", position: "2")])
        let seriesOne = makeBook("Saga One", series: [BookSeries(name: "Saga", position: "1")])
        let otherSeries = makeBook("Chronicle Three", series: [BookSeries(name: "Chronicle", position: "3")])
        let noSeries = makeBook("Unsorted")

        let sorted = [seriesTen, noSeries, seriesTwo, otherSeries, seriesOne]
            .sorted(by: .series, ascending: true)

        #expect(sorted.map(\.title) == [
            "Chronicle Three",
            "Saga One",
            "Saga Two",
            "Saga Ten",
            "Unsorted",
        ])
    }

    @Test
    func seriesSortMenuNamesPositionOrdering() {
        #expect(BookSort.series.label == "Series + Order")
    }

    private func makeBook(_ title: String, series: [BookSeries] = []) -> Book {
        Book(
            id: UUID(),
            title: title,
            authors: ["Author"],
            series: series,
            year: nil,
            locale: "und",
            coverPath: nil,
            dateAdded: Date(timeIntervalSince1970: 0),
            fileURL: URL(fileURLWithPath: "/library/author/\(title).epub")
        )
    }
}
