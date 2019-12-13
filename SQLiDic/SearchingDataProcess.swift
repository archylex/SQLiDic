//
//  SearchingDataProcess.swift
//  SQliDic
//
//  Created by Archylex on 23/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import Foundation
import SQLite

func pathDB() -> String {
    guard let path = Bundle.main.path(forResource: "jpru", ofType: "sqlite") else {return ""}
    return path
}

func SearchingDataProcess(myWord: String, agressive: Bool, translateCell: Bool, maxresult: Int) -> Array<Item> {    
    var sqlTransact = ""
    let inputText = myWord.lowercased()
    var database: Connection!
    var results = Array<Item>()    

    do {
        database = try Connection(pathDB())   
    } catch {
        print(error)
    }
    
    var mtrs = RegularExpression(for: "[\u{4E00}-\u{9FAF}]", in: inputText)
    
    if (mtrs.isEmpty) {
        mtrs = RegularExpression(for: "[\u{3040}-\u{309F}\u{30A0}-\u{30FF}]", in: inputText)
        
        if(mtrs.isEmpty) {
            mtrs = RegularExpression(for: "[а-яА-Я]", in: inputText)

            if(mtrs.isEmpty) {
                let hiragana = toHiragana(sentence: inputText, language: "en")

                if (agressive) {
                    sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '" + hiragana + "' OR kana LIKE '" + hiraganaToKatakana(sentence: hiragana) + "'"
                } else {
                    sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '%" + hiragana + "%' OR kana LIKE '%" + hiraganaToKatakana(sentence: hiragana) + "%'"
                }
            } else {
                if (translateCell) {
                    sqlTransact = "SELECT * FROM warodai WHERE trans LIKE '%" + inputText + "%'"
                } else {
                    let hiragana = toHiragana(sentence: inputText, language: "ru")

                    if (agressive) {
                        sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '" + hiragana + "' OR kana LIKE '" + hiraganaToKatakana(sentence: hiragana) + "'"
                    } else {
                        sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '%" + hiragana + "%' OR kana LIKE '%" + hiraganaToKatakana(sentence: hiragana) + "%'"
                    }
                }
            }
        } else {
            if (agressive) {
                sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '" + inputText + "'"
            } else {
                sqlTransact = "SELECT * FROM warodai WHERE kana LIKE '%" + inputText + "%'"
            }
        }
    } else {
        if (agressive) {
            sqlTransact = "SELECT * FROM warodai WHERE kanji LIKE '" + inputText + "'"
        } else {
            sqlTransact = "SELECT * FROM warodai WHERE kanji LIKE '%" + inputText + "%'"
        }
    }
    
    do {
        var count = 0
        
        for row in try database.prepare(sqlTransact) {            
            var kana = row[2] as! String

            if(row[1] as! String != "") {
                kana = "[\(row[2] as! String)]"
            }

            let newItem = Item(kanji: row[1] as! String, kana: kana, translate: row[3] as! String)
            
            results.append(newItem)
            
            count = count + 1
            
            if count >= maxresult {
                break
            }
        }
    } catch {
        print(error)
    }
    
    return results
}

func SearchingDataProcess(text: String, numRow: Int, count: Int) -> Array<String>  {
    var database: Connection!
    
    do {
        database = try Connection(pathDB())        
    } catch {
        print(error)
    }
    
    var results = Array<String>()

    do {
        var sqlTransact = String()
        
        if numRow == 1 {
            sqlTransact = "SELECT kanji FROM warodai WHERE kanji LIKE '" + text + "%'"
        } else if numRow == 2 {
            sqlTransact = "SELECT kana FROM warodai WHERE kana LIKE '" + text + "%'"
        }
        
        var num = 0

        for row in try database.prepare(sqlTransact) {
            results.append(row[0] as! String)
            num = num + 1
            if num > count {
                break
            }
        }
    } catch {
        print(error)
    }
    
    return results
}