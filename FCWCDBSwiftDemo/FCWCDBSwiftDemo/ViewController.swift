//
//  ViewController.swift
//  FCWCDBSwiftDemo
//
//  Created by 肖志斌 on 2021/9/14.
//

import UIKit

class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    var dataArr = ["WCDBSwift"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "FCWCDBSwiftDemo"
        self.view.addSubview(tableView)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "MyCell")
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(FCWCDBSwiftViewController(), animated: true)
        }
    }
}



