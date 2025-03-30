# JapaneseHoliday
[![Actions Status](https://github.com/417-72KI/JapaneseHoliday/workflows/Test/badge.svg)](https://github.com/417-72KI/JapaneseHoliday/actions)
[![GitHub release](https://img.shields.io/github/release/417-72KI/JapaneseHoliday/all.svg)](https://github.com/417-72KI/JapaneseHoliday/releases)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-6.0-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F417-72KI%2FJapaneseHoliday%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/417-72KI/JapaneseHoliday)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F417-72KI%2FJapaneseHoliday%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/417-72KI/JapaneseHoliday)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/417-72KI/JapaneseHoliday/master/LICENSE)

A library for calculating Japanese holidays.

It crawls [the official website of the Japanese government](https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv) and extracts the data of the holidays.

See also https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html

> [!NOTE]
> Date caculation is based on **Japanese Standard Time (JST)**.

## Installation

Set

```swift
.package(url: "https://github.com/417-72KI/JapaneseHoliday.git", from: "1.2.0"),
```

in package dependencies and

```swift
"JapaneseHoliday",
```

in target dependencies.

## Usage

```swift
import JapaneseHoliday

let holiday = JapaneseHoliday.holiday(ofDate: .now)

print("Today is \(holiday?.name ?? "not a holiday")")
```

### Add a custom holiday

```swift
import JapaneseHoliday

JapaneseHoliday.addCustomHoliday(forMonth: 1, day: 2, named: "三が日")
JapaneseHoliday.addCustomHoliday(forMonth: 1, day: 3, named: "三が日")

let holiday = JapaneseHoliday.holiday(ofDate: Date(timeIntervalSince1970: 1735743600)) // 2025-01-02 00:00:00 GMT+9
print("2025-01-02 is \(holiday?.name ?? "not a holiday")")
```

## Author
[417-72KI](https://github.com/417-72KI)
