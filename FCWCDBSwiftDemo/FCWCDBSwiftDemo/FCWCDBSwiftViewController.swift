//
//  FCWCDBSwiftViewController.swift
//  FCWCDBSwiftDemo
//
//  Created by 肖志斌 on 2021/9/14.
//

import UIKit
import WCDBSwift

class FCWCDBSwiftViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    private lazy var addBut: UIButton = {
        let btn = UIButton()
        btn.setTitle("插入数据", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(addData), for: .touchUpInside)
        return btn
    }()
    private lazy var clearBut: UIButton = {
        let btn = UIButton()
        btn.setTitle("清除所有数据库", for: .normal)
        btn.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width/2, height: 100)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        return btn
    }()
    private lazy var sortBut: UIButton = {
        let btn = UIButton()
        btn.setTitle("排序", for: .normal)
        btn.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width/2, height: 100)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(getDataSorted), for: .touchUpInside)
        return btn
    }()
    /// 保存从数据库中查询出来的结果集
    var dataArr = [PersonModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WCDBSwift"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addBut)
        self.view.addSubview(tableView)
        self.view.addSubview(clearBut)
        self.view.addSubview(sortBut)
        createData()
        getData()
    }

    /// 新建数据
    private func createData() {
        WCDBDataBaseManager.shared.createTable(table: PersonModel.tableName, of: PersonModel.self)
         //查询
        self.dataArr = WCDBDataBaseManager.shared.qureyObjectsFromDb(fromTable: PersonModel.tableName)! as [PersonModel]
        //已经有记录的话就不插入了
        if self.dataArr.count > 0 {
            return
        }
        PersonModel.save(title: "香蕉", num: 5)
        PersonModel.save(title: "苹果", num: 55)
        PersonModel.save(title: "哈密瓜", num: 88)
        PersonModel.save(title: "猕猴桃", num: 35)
        PersonModel.save(title: "菠萝", num: 68)
        let model = PersonModel()
        model.isAutoIncrement = false
        WCDBDataBaseManager.shared.insertOrReplaceToDb(object: model, table: PersonModel.tableName)
    }
    // MARK: 查
    private func getData() {
        self.dataArr.removeAll()
        self.dataArr = WCDBDataBaseManager.shared.qureyObjectsFromDb(fromTable: PersonModel.tableName)! as [PersonModel]
        self.tableView.reloadData()
    }
    // MARK: 主键查询
    private func getDataFromPromaykey() {
        do {
            self.dataArr.removeAll()
            self.dataArr = try WCDBDataBaseManager.defaultDatabase.getObjects(fromTable: PersonModel.tableName,
            where: PersonModel.Properties.identifier < 6 && PersonModel.Properties.identifier > 3)
            self.tableView.reloadData()
        } catch  {
            print("查询失败：\(error.localizedDescription)")
        }

    }
    // MARK: 数据排序
    @objc private func getDataSorted() {
        self.dataArr.removeAll()
        self.dataArr = WCDBDataBaseManager.shared.qureyObjectsFromDb(fromTable: PersonModel.tableName, orderBy: [PersonModel.Properties.num.asOrder(by: .ascending)])!
        self.tableView.reloadData()

    }
    // MARK: 增
    @objc private func addData() {
        let num = Int(arc4random_uniform(100))
        PersonModel.save(title: "丰巢大西瓜\(num)", num: num)
        getData()
    }
    // MARK: 更新(通过"with object" 接口更新)
    @objc private func updateSingleData(_ indexPath: IndexPath, _ identifier: Int) {
        let model = self.dataArr[indexPath.row]
        model.num = 999
        WCDBDataBaseManager.shared.updateToDb(table: PersonModel.tableName, on: PersonModel.Properties.all, with: model, where: PersonModel.Properties.identifier == identifier)
        getData()
    }
    // MARK: 更新(通过"with row" 接口更新)
    private func updateWithRowData(_ indexPath: IndexPath, _ identifier: Int) {
        do {
            let row = [self.dataArr[indexPath.row].title!] as [ColumnEncodable]
            try WCDBDataBaseManager.defaultDatabase.update(table: PersonModel.tableName, on: PersonModel.Properties.title, with: row, where: PersonModel.Properties.identifier == identifier)
            self.getData()
        } catch  {
            print("查询失败：\(error.localizedDescription)")
        }
    }
    // MARK: 删（清空本地所有数据）
    @objc private func clearData() {
        WCDBDataBaseManager.shared.deleteFromDb(fromTable: PersonModel.tableName)
        self.dataArr.removeAll()
        self.tableView.reloadData()

    }
    // MARK: 删（删除指定类型的数据）
    private func clearSingleData(identifier: Int) {
        WCDBDataBaseManager.shared.deleteFromDb(fromTable: PersonModel.tableName, where: PersonModel.Properties.identifier == identifier)
        getData()
    }
    // MARK: 删（多种情况的删除）
   @objc private func clearOtherData() {

        // 删除 PersonModel 中 按 identifier 升序排列后的前 4 行的后 2 行数据
        WCDBDataBaseManager.shared.deleteFromDb(fromTable: PersonModel.tableName, orderBy: [PersonModel.Properties.num.asOrder(by: .ascending)], limit: 2, offset: 4)
        getData()
    }
}

extension FCWCDBSwiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "MyCell")
        cell.textLabel?.text = "ID\(dataArr[indexPath.row].identifier ?? 1)" + "+\(dataArr[indexPath.row].title ?? "")"
        cell.detailTextLabel?.text = "\(dataArr[indexPath.row].num ?? 1)个"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let modification = UITableViewRowAction.init(style: .normal, title: "修改名称") { (action, indexPath) in
            self.modificationAction(indexPath)

            tableView.setEditing(false, animated: true)
        }
        modification.backgroundColor = .red

        // MARK: 删
        let delete = UITableViewRowAction.init(style: .normal, title: "删除") { (action, indexPath) in
            self.clearSingleData(identifier: self.dataArr[indexPath.row].identifier ?? 1)
            tableView.setEditing(false, animated: true)
        }
        delete.backgroundColor = .systemBlue
        return [modification, delete]
    }
}
extension FCWCDBSwiftViewController {
    // MARK: 改
    private func modificationAction(_ indexPath: IndexPath){
      let alertController = UIAlertController(title: "修改",message: "输入名称", preferredStyle: .alert)
      alertController.addTextField {
          (textField: UITextField!) -> Void in
          textField.placeholder = "请输入名称"
      }
      let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
      let okAction = UIAlertAction(title: "确认", style: .default, handler: {
          action in
        self.dataArr[indexPath.row].title = alertController.textFields!.first!.text!
        self.updateSingleData(indexPath, self.dataArr[indexPath.row].identifier ?? 1)
//        self.updateWithRowData(indexPath, self.dataArr[indexPath.row].identifier ?? 1)
      })
      alertController.addAction(cancelAction)
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
}
