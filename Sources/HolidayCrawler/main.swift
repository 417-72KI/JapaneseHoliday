#!/usr/bin/env swift

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Common

let url = URL(string: "https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv")!
let data = try Data(contentsOf: url)

// Linuxだとshift-jisが直接使えないのでiconvで変換する
// guard let csv = String(data: data, encoding: .shiftJIS) else { 
//     print("Failed to convert data to string")
//     exit(1)
// }
let tmpDirectoryPath = NSTemporaryDirectory()
let tmpDirectory = URL(fileURLWithPath: tmpDirectoryPath)

let csvFile = tmpDirectory.appending(path: "holiday.csv")

try data.write(to: csvFile)

do {
    let iconv = Process()
    let stdout = Pipe()
    iconv.executableURL = URL(fileURLWithPath: "/usr/bin/iconv")
    iconv.arguments = ["-f", "shift-jis", "-t", "utf-8", csvFile.path]
    iconv.standardOutput = stdout
    try iconv.run()
    try stdout.fileHandleForReading.readDataToEndOfFile().write(to: csvFile)
} catch {
    print("Failed to convert csv file: \(error)")
    exit(1)
}

let sourceDir = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appending(path: "JapaneseHoliday", directoryHint: .isDirectory)

let convertedData = try Data(contentsOf: csvFile)
let csv = String(decoding: convertedData, as: UTF8.self)

let holidays = try csv.split(separator: "\r\n").lazy.dropFirst()
    .map(Holiday.init)
let outputFile = sourceDir.appending(path: "Holidays.generated.swift")

let source = HolidayBuilder.build(holidays)
try Data(source.formatted(using: Format()).description.utf8).write(to: outputFile)

let lastUpdateFile = sourceDir.appending(path: "LastUpdate.swift")
try rewrite(file: lastUpdateFile, withLastUpdate: Date())
