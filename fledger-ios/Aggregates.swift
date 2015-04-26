//
//  Aggregates.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class Aggregates {
    
    private static let items = DatabaseService.main.items
    private static let groups = DatabaseService.main.groups
    private static let types = DatabaseService.main.types
    private static let accounts = DatabaseService.main.accounts
    
    private static let accountId = accounts[Fields.id]
    private static let groupId = groups[Fields.id]
    private static let typeId = types[Fields.id]
    private static let name = Fields.name
    private static let priority = Fields.priority
    private static let inactive = Fields.inactive
    
    private static let accountName = accounts[name]
    private static let groupName = groups[name]
    private static let typeName = types[name]
    private static let groupTypeName = groupName + " - " + typeName
    
    private static let sumAmount = Expressions.sumAmount
    
    private static let allQuery = items
        .select(sumAmount)
    
    private static let accountsQuery = accounts
        .select(accountId, accountName, sumAmount, inactive)
        .join(.LeftOuter, items, on: Fields.accountId == accountId)
        .group(accountId)
        .order(inactive, priority, collate(.Nocase, accountName))
    
    private static let groupsQuery = groups
        .select(groupId, groupName, sumAmount)
        .join(.LeftOuter, types, on: Fields.groupId == groupId)
        .join(.LeftOuter, items, on: Fields.typeId == typeId)
        .group(groupId)
        .order(collate(.Nocase, groupName))
    
    private static let typesQuery = types
        .select(typeId, groupTypeName, sumAmount)
        .join(.LeftOuter, items, on: Fields.typeId == typeId)
        .join(.LeftOuter, groups, on: Fields.groupId == groupId)
        .group(typeId)
        .order(collate(.Nocase, groupName), collate(.Nocase, typeName))
    
    private static func aggregate(model: ModelType, query: Query, id: Expression<Int64>, name: Expression<String>, checkActive: Bool = false) -> [Aggregate] {
        var result: [Aggregate] = []
        for row in query {
            var active = true
            if checkActive {
                active = !row.get(inactive)
            }
            result.append(Aggregate(model: model, id: row.get(id), name: row.get(name), value: row.get(sumAmount) ?? 0, active: active))
        }
        return result
    }
    
    static func getAll() -> [Aggregate] {
        return [Aggregate(model: nil, id: nil, name: "all", value: allQuery.first?.get(sumAmount) ?? 0)]
    }
    
    static func getAccounts() -> [Aggregate] {
        return aggregate(ModelType.Account, query: accountsQuery, id: accountId, name: name, checkActive: true)
    }
    
    static func getGroups() -> [Aggregate] {
        return aggregate(ModelType.Group, query: groupsQuery, id: groupId, name: name)
    }
    
    static func getTypes() -> [Aggregate] {
        return aggregate(ModelType.Typ, query: typesQuery, id: typeId, name: groupTypeName)
    }
    
}