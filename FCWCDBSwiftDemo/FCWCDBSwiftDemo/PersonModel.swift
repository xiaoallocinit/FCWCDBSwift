//
//  PersonModel.swift
//  FCWCDBSwiftDemo
//
//  Created by 肖志斌 on 2021/9/14.
//

import UIKit
import WCDBSwift

class PersonModel: TableCodable {
    var identifier: Int? = nil
    var title: String? = nil
    var num: Int? = nil
    var newName: String? = nil
    /// 对应数据库表名
    static var tableName: String { "PersonModel" }

    enum CodingKeys: String, CodingTableKey {
        typealias Root = PersonModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case title
        case num
//        case name
        case newName = "name"
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true)
            ]
        }
        static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
            return [
                "_index": IndexBinding(indexesBy: title)
            ]
        }
    }
    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值

    // MARK: model保存
    static func save(title: String, num: Int) {
        let model = PersonModel()
        model.title = title
        model.num = num
        model.newName = "jack"
        WCDBDataBaseManager.shared.insertOrReplaceToDb(object: model, table: PersonModel.tableName)
    }
}

