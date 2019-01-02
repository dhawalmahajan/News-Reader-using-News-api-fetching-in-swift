//
//  MenuManager.swift
//  NewsApi
//
//  Created by Dhawal Mahajan on 22/12/18.
//  Copyright © 2018 Dhawal Mahajan. All rights reserved.
//

import UIKit

class MenuManager: NSObject {
    let blackView = UIView()
    let menuTableView = UITableView()
    var mainVC: ViewController?
    let arrayOfSources = ["TechCrunch", "TechRadar"]
    public func openMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu(recognizer:))))
            let height: CGFloat = 100
            let y: CGFloat = window.frame.height - height
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
                self.menuTableView.frame.origin.y = y
            }
            menuTableView.tableFooterView = UIView()
        }
    }
    
    @objc public func dismissMenu(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.menuTableView.frame.origin.y = window.frame.height
            }
        }
    }
    
    override init() {
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        menuTableView.separatorInset = .zero
        menuTableView.register(BaseCell.classForCoder(), forCellReuseIdentifier: "CellId")
    }
}
extension MenuManager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! BaseCell
        cell.textLabel?.text = arrayOfSources[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC  {
            vc.source = arrayOfSources[indexPath.row].lowercased()
            vc.fetchData(fromSource: arrayOfSources[indexPath.item].lowercased())
            let guesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu(recognizer:)))
            dismissMenu(recognizer: guesture)
        }
    }
    
    
}

