//
//  settingsTableVC.swift
//  SQliDic
//
//  Created by Archylex on 22/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

class settingsTableVC: UITableViewController {    
    var ssections = sectionsData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateDataTable()
        
        self.title = "Settings"
        
        let buttonL = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(settingsTableVC.nextVC))
        self.navigationItem.leftBarButtonItem = buttonL
        
        self.tableView.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = hexToUIColor(hex: "#000000", alfa: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @objc func nextVC() {
        let newViewController = searchTableVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func updateDataTable () {
        for (indexA, section) in ssections.enumerated() {
            for (indexB, row) in section.items.enumerated() {
                var key = row.name + section.name
                key = key.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if UserDefaults.standard.object(forKey: key) != nil {
                    ssections[indexA].items[indexB].detail = UserDefaults.standard.object(forKey: key) as! String
                }
            }
        }
    }    
}

extension settingsTableVC {    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ssections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ssections[section].collapsed ? 0 : ssections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: settingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? settingsTableViewCell ??
            settingsTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item: sItem = ssections[indexPath.section].items[indexPath.row]
        
        if ssections[indexPath.section].field == "color" {
            cell.nameLabel.text = item.name
            cell.detailLabel.text = "              "
            cell.detailLabel.backgroundColor = hexToUIColor(hex: ssections[indexPath.section].items[indexPath.row].detail, alfa: 1.0)
        } else {
            cell.nameLabel.text = item.name
            cell.detailLabel.text = item.detail
            cell.detailLabel.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if ssections[indexPath.section].name == "Search" {
            if ssections[indexPath.section].items[indexPath.row].detail == "approximate" {
                UserDefaults.standard.set("accurate", forKey: "WordSearch")
                ssections[indexPath.section].items[indexPath.row].detail = "accurate"
            } else {
                UserDefaults.standard.set("approximate", forKey: "WordSearch")
                ssections[indexPath.section].items[indexPath.row].detail = "approximate"
            }
            tableView.reloadData()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
        if ssections[indexPath.section].name != "Dictionaries" && ssections[indexPath.section].name != "Search" {
            let myTitle = ssections[indexPath.section].items[indexPath.row].name + " " + ssections[indexPath.section].name
            let alert = CustomAlert(title: myTitle, field: ssections[indexPath.section].field)
            alert.delegate = self as! customAlertDelegate
            alert.show(animated: true)
        }        
    }    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? settingsTableViewHeader ?? settingsTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = ssections[section].name
        header.arrowLabel.text = "▶"
        header.setCollapsed(ssections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }    
}

extension settingsTableVC: settingsTableViewHeaderDelegate {    
    func toggleSection(_ header: settingsTableViewHeader, section: Int) {
        let collapsed = !ssections[section].collapsed
        
        ssections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }    
}

extension settingsTableVC: customAlertDelegate{
    func okButtonPressed(_ customAlert: CustomAlert) {
        updateDataTable()
        tableView.reloadData()
    }
}