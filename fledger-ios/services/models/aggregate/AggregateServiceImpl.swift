//
//  Aggregates.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class AggregateServiceImpl: AggregateService {
    
    private let items: Query
    private let groups: Query
    private let types: Query
    private let accounts: Query
    
    private let accountId: Expression<Int64>
    private let groupId: Expression<Int64>
    private let typeId: Expression<Int64>
    private let name: Expression<String>
    private let priority: Expression<Int>
    private let inactive: Expression<Bool>
    
    private let accountName: Expression<String>
    private let groupName: Expression<String>
    private let typeName: Expression<String>
    
    private let sumAmount = Expressions.sumAmount
    
    private let allQuery: Query
    private let accountsQuery: Query
    private let groupsQuery: Query
    private let typesQuery: Query
    
    required init() {
        items = DatabaseSvc().items
        groups = DatabaseSvc().groups
        types = DatabaseSvc().types
        accounts = DatabaseSvc().accounts
        
        accountId = accounts[Fields.id]
        groupId = groups[Fields.id]
        typeId = types[Fields.id]
        name = Fields.name
        priority = Fields.priority
        inactive = Fields.inactive
        
        accountName = accounts[name]
        groupName = groups[name]
        typeName = types[name]
        
        allQuery = items
            .select(sumAmount)
        
        accountsQuery = accounts
            .select(accountId, accountName, sumAmount, inactive)
            .join(.LeftOuter, items, on: Fields.accountId == accountId)
            .group(accountId)
            .order(inactive, priority, collate(.Nocase, accountName))
        
        groupsQuery = groups
            .select(groupId, groupName, sumAmount)
            .join(.LeftOuter, types, on: Fields.groupId == groupId)
            .join(.LeftOuter, items, on: Fields.typeId == typeId)
            .group(groupId)
            .order(collate(.Nocase, groupName))
        
        typesQuery = types
            .select(typeId, typeName, groupName, sumAmount)
            .join(.LeftOuter, items, on: Fields.typeId == typeId)
            .join(.LeftOuter, groups, on: Fields.groupId == groupId)
            .group(typeId)
            .order(collate(.Nocase, groupName), collate(.Nocase, typeName))
    }
    
    private func aggregate(model: ModelType, query: Query, id: Expression<Int64>, name: Expression<String>, checkActive: Bool = false) -> [Aggregate] {
        var result: [Aggregate] = []
        for row in query {
            var active = true
            if checkActive {
                active = !row.get(inactive)
            }
            var section: String?
            if model == ModelType.Typ {
                section = row.get(groupName)
            }
            result.append(Aggregate(model: model, id: row.get(id), name: row.get(name), value: row.get(sumAmount) ?? 0, active: active, section: section))
        }
        return result
    }
    
    func getAll() -> [Aggregate] {
        return [Aggregate(model: nil, id: nil, name: "all", value: allQuery.first?.get(sumAmount) ?? 0)]
    }
    
    func getAccounts() -> [Aggregate] {
        return aggregate(ModelType.Account, query: accountsQuery, id: accountId, name: name, checkActive: true)
    }
    
    func getGroups() -> [Aggregate] {
        return aggregate(ModelType.Group, query: groupsQuery, id: groupId, name: name)
    }
    
    func getTypes() -> [Aggregate] {
        return aggregate(ModelType.Typ, query: typesQuery, id: typeId, name: typeName)
    }
    
}