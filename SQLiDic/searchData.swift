//
//  searchData.swift
//  SQliDic
//
//  Created by Archylex on 22/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import Foundation

public struct Item {
    var kanji: String
    var kana: String
    var translate: String
    
    public init(kanji: String, kana: String, translate: String) {
        self.kanji = kanji
        self.kana = kana
        self.translate = translate
    }
}

public struct Section {
    var name: String
    var word: [Item]
    var collapsed: Bool
    var special: Bool
    
    public init(name: String, word: [Item], collapsed: Bool, special: Bool) {
        self.name = name
        self.word = word
        self.collapsed = collapsed
        self.special = special
    }
}

public var pTip: String = "main"

public struct sItem {
    var name: String
    var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

public struct sSection {
    var name: String
    var items: [sItem]
    var collapsed: Bool
    var field: String
    
    public init(name: String, items: [sItem], collapsed: Bool = false, field: String) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
        self.field = field
    }
}

public var sectionsData: [sSection] = [
    sSection(name: "Search", items: [
        sItem(name: "Word", detail: "approximate"),
        ], collapsed: true, field: "check"),
    sSection(name: "Font Size", items: [
        sItem(name: "Kanji", detail: "16"),
        sItem(name: "Kana", detail: "16"),
        sItem(name: "Translate", detail: "12"),
        sItem(name: "AutoComplete", detail: "16")
        ], collapsed: true, field: "text"),
    sSection(name: "Font Color", items: [
        sItem(name: "Kanji", detail: "              "),
        sItem(name: "Kana", detail: "              "),
        sItem(name: "Translate", detail: "              "),
        sItem(name: "AutoComplete", detail: "              "),
        sItem(name: "Header", detail: "              "),
        sItem(name: "Button", detail: "              "),
        sItem(name: "Search Field", detail: "              "),
        sItem(name: "Title", detail: "              ")
        ], collapsed: true, field: "color"),
    sSection(name: "Color", items: [
        sItem(name: "Background", detail: "              "),
        sItem(name: "Main Header", detail: "              "),
        sItem(name: "Header", detail: "              "),
        sItem(name: "Button", detail: "              "),
        sItem(name: "Search Field", detail: "              "),
        sItem(name: "AutoComplete", detail: "              "),
        sItem(name: "Title", detail: "              "),
        sItem(name: "Navigation", detail: "              ")
        ], collapsed: true, field: "color"),
    sSection(name: "Maximum", items: [
        sItem(name: "Results", detail: "1000"),
        sItem(name: "AutoComplete", detail: "0")
        ], collapsed: true, field: "text"),
    sSection(name: "Dictionaries", items: [
        sItem(name: "[JP-RU] warodai", detail: "▣"),
        sItem(name: "[EN-RU] Dictionary", detail: "▢")
        ], collapsed: true, field: "check")
]