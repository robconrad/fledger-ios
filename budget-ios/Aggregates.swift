//
//  Aggregates.swift
//  budget-ios
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
    
    private static let accountId = Fields.accountId
    private static let groupId = Fields.groupId
    private static let typeId = Fields.typeId
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
    
    private static let accountsQuery = items
        .select(accountId, accountName, sumAmount)
        .join(accounts, on: accountId == accounts[Fields.id])
        .filter(inactive == false)
        .group(accountId)
        .order(priority)
    
    private static let groupsQuery = items
        .select(groupId, groupName, sumAmount)
        .join(types, on: typeId == types[Fields.id])
        .join(groups, on: groupId == groups[Fields.id])
        .group(groupId)
        .order(groupName)
    
    private static let typesQuery = items
        .select(typeId, groupTypeName, sumAmount)
        .join(types, on: typeId == types[Fields.id])
        .join(groups, on: groupId == groups[Fields.id])
        .group(typeId)
        .order(groupName, typeName)
    
    private static func aggregate(model: ModelType, query: Query, id: Expression<Int64>, name: Expression<String>) -> [Aggregate] {
        var result: [Aggregate] = []
        for row in query {
            result.append(Aggregate(model: model, id: row.get(id), name: row.get(name), value: row.get(sumAmount)!))
        }
        return result
    }
    
    static func getAll() -> [Aggregate] {
        return [Aggregate(model: nil, id: nil, name: "all", value: allQuery.first!.get(sumAmount)!)]
    }
    
    static func getAccounts() -> [Aggregate] {
        return aggregate(ModelType.Account, query: accountsQuery, id: accountId, name: name)
    }
    
    static func getGroups() -> [Aggregate] {
        return aggregate(ModelType.Group, query: groupsQuery, id: groupId, name: name)
    }
    
    static func getTypes() -> [Aggregate] {
        return aggregate(ModelType.Typ, query: typesQuery, id: typeId, name: groupTypeName)
    }
    
}