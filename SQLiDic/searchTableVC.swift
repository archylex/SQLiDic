//
//  searchTableVC.swift
//  SQLiDic
//
//  Created by Archylex on 27/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

class searchTableVC: UITableViewController, searchTableViewHeaderDelegate, inputTableViewCellDelegate {    
    var mainSection = Section(name: "main", word: [Item(kanji: "", kana: "", translate: "")], collapsed: false, special: true)
    var sections = Array<Section>()
    var maxResults = Int()
    var Agressive = Bool()
    var buttonL = UIBarButtonItem()
    var rus = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rus = false
        maxResults = defaultOrMemory(key: "ResultsMaximum", center: 1000)
        
        sections.append(mainSection)
        tableView.estimatedRowHeight = 42.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        self.title = "SQLiDic"
        
        let buttonSettings = UIBarButtonItem(image: UIImage(named: "settings.png"), style: .plain, target: self, action: #selector(searchTableVC.nextVC))
        
        self.navigationItem.rightBarButtonItem  = buttonSettings
        buttonL = UIBarButtonItem(image: UIImage(named: "a1.png"), style: .plain, target: self, action: #selector(searchTableVC.changeLang))
        self.navigationItem.leftBarButtonItem = buttonL
 
        navigationController?.navigationBar.tintColor = defaultOrMemory(key: "NavigationColor", center: "FFFFFF", alpha: 1.0)
        self.tableView.backgroundColor = defaultOrMemory(key: "BackgroundColor", center: "FFFFFF", alpha: 1.0)
        navigationController?.navigationBar.barTintColor = defaultOrMemory(key: "TitleColor", center: "000000", alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: defaultOrMemory(key: "TitleFontColor", center: "FFFFFF", alpha: 1.0)]
    }
   
    @objc func nextVC() {
        let newViewController = settingsTableVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func changeLang() {
        if rus {
            rus = false
            buttonL.image = UIImage(named: "a1.png")
        } else {
            rus = true
            buttonL.image = UIImage(named: "a2.png")
        }
    }    
    
    func toggleSection(_ header: searchTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
          
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
             
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func searchButtonPressed(_ header: inputTableViewCell) {        
        var searchQuery: String
        
        if UserDefaults.standard.object(forKey: "searchQuery") == nil {
            searchQuery = ""
        } else {
            searchQuery = UserDefaults.standard.object(forKey: "searchQuery") as! String
        }
        
        if UserDefaults.standard.object(forKey: "WordSearch") == nil {
            Agressive = false
            UserDefaults.standard.set("approximate", forKey: "WordSearch")
        } else {
            if UserDefaults.standard.object(forKey: "WordSearch") as! String == "accurate" {
                Agressive = true
            } else {
                Agressive = false
            }
        }
        
        sections = Array<Section>()
        sections.append(mainSection)
        let newSection = Section(name: "warodai", word: SearchingDataProcess(myWord: searchQuery, agressive: Agressive, translateCell: rus, maxresult: maxResults), collapsed: false, special: false)
        
        sections.append(newSection)
        
        tableView.reloadData()
        for n in stride(from: 0, to: sections.count, by: 1) {
            tableView.reloadSections(IndexSet(integer: n), with: .automatic)
        }
    }
}

extension searchTableVC {    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].word.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let word: Item = sections[indexPath.section].word[indexPath.row]

        if sections[indexPath.section].name != "main" {
            let cell: searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? searchTableViewCell ??
                    searchTableViewCell(style: .default, reuseIdentifier: "cell")

            cell.kanjiLabel.text = word.kanji
            cell.kanaLabel.text = word.kana
            cell.translateLabel.text = word.translate.html2String
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell: inputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? inputTableViewCell ??
                inputTableViewCell(style: .default, reuseIdentifier: "cell")
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? searchTableViewHeader ?? searchTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = "▶"
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        
        return header        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 42.0
        } else {
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }    
}

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}