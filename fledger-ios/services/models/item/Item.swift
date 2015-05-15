//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
import Parse


func ==(a: Item, b: Item) -> Bool {
    return a.id == b.id
        && a.accountId == b.accountId
        && a.typeId == b.typeId
        && a.locationId == b.locationId
        && a.locationId == b.locationId
        && a.amount == b.amount
        && a.date == b.date
        && a.comments == b.comments
}

class Item: Model, Printable {
    
    let modelType = ModelType.Item
    
    let id: Int64?
    let accountId: Int64
    let typeId: Int64
    let locationId: Int64?
    let amount: Double
    let date: NSDate
    let comments: String
    
    let pf: PFObject?
    
    var description: String {
        return "Item(id: \(id), accountId: \(accountId), typeId: \(typeId), locationId: \(locationId), amount: \(amount), date: \(date), comments: \(comments), pf: \(pf))"
    }
    
    required init(id: Int64?, accountId: Int64, typeId: Int64, locationId: Int64?, amount: Double, date: NSDate, comments: String, pf: PFObject? = nil) {
        self.id = id
        self.accountId = accountId
        self.typeId = typeId
        self.locationId = locationId
        self.amount = amount
        self.date = date
        self.comments = comments
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(DatabaseServiceImpl.main.items[Fields.id]),
            accountId: row.get(Fields.accountId),
            typeId: row.get(Fields.typeId),
            locationId: row.get(Fields.locationId),
            amount: row.get(Fields.amount),
            date: row.get(Fields.date),
            comments: row.get(Fields.comments))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { Services.get(ParseService.self).withParseId($0, ModelType.Item) }?.modelId,
            accountId: Services.get(ParseService.self).withParseId(pf["accountId"] as! String, ModelType.Account)!.modelId,
            typeId: Services.get(ParseService.self).withParseId(pf["typeId"] as! String, ModelType.Typ)!.modelId,
            locationId: (pf["locationId"] as? String).map { Services.get(ParseService.self).withParseId($0, ModelType.Location)!.modelId },
            amount: pf["amount"] as! Double,
            date: pf["date"] as! NSDate,
            comments: pf["comments"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.accountId <- accountId,
            Fields.typeId <- typeId,
            Fields.locationId <- locationId,
            Fields.amount <- amount,
            Fields.date <- date,
            Fields.comments <- comments
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["accountId"] = account().parse()!.parseId!
            npf["typeId"] = type().parse()!.parseId!
            npf["locationId"] = location().map { $0.parse()!.parseId! } ?? NSNull()
            npf["amount"] = amount
            npf["date"] = date
            npf["comments"] = comments
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { Services.get(ParseService.self).withModelId($0, modelType) }
    }
    
    func copy(accountId: Int64? = nil, typeId: Int64? = nil, locationId: Int64? = nil, amount: Double? = nil, date: NSDate? = nil, comments: String? = nil) -> Item {
        return Item(
            id: id,
            accountId: accountId ?? self.accountId,
            typeId: typeId ?? self.typeId,
            locationId: locationId ?? self.locationId,
            amount: amount ?? self.amount,
            date: date ?? self.date,
            comments: comments ?? self.comments)
    }
    
    func clear(locationId: Bool = false) -> Item {
        return Item(
            id: id,
            accountId: accountId,
            typeId: typeId,
            locationId: locationId ? nil : self.locationId,
            amount: amount,
            date: date,
            comments: comments)
    }
    
    func account() -> Account {
        return Services.get(AccountService.self).withId(accountId)!
    }
    
    func type() -> Type {
        return Services.get(TypeService.self).withId(typeId)!
    }
    
    func group() -> Group {
        return Services.get(GroupService.self).withTypeId(typeId)!
    }
    
    func location() -> Location? {
        return locationId.flatMap { Services.get(LocationService.self).withId($0) }
    }
    
    func isTransfer() -> Bool {
        return typeId == Services.get(TypeService.self).transferId
    }
    
}
