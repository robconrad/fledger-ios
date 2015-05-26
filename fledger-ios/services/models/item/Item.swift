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
            id: row.get(DatabaseSvc().items[Fields.id]),
            accountId: row.get(Fields.accountId),
            typeId: row.get(Fields.typeId),
            locationId: row.get(Fields.locationId),
            amount: row.get(Fields.amount),
            date: row.get(Fields.date),
            comments: row.get(Fields.comments))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Item) }?.modelId,
            accountId: ParseSvc().withParseId(pf["accountId"] as! String, ModelType.Account)!.modelId,
            typeId: ParseSvc().withParseId(pf["typeId"] as! String, ModelType.Typ)!.modelId,
            locationId: (pf["locationId"] as? String).map { ParseSvc().withParseId($0, ModelType.Location)!.modelId },
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
        if let myId = id,
            parseAccountId = account().parse()!.parseId,
            parseTypeId = type().parse()!.parseId {
            let myLocation = location()
            let parseLocationId = myLocation.flatMap { $0.parse()!.parseId }
            if myLocation != nil && parseLocationId == nil {
                return nil
            }
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["accountId"] = parseAccountId
            npf["typeId"] = parseTypeId
            npf["locationId"] = parseLocationId ?? NSNull()
            npf["amount"] = amount
            npf["date"] = date
            npf["comments"] = comments
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
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
    
    func withId(id: Int64?) -> Item {
        return Item(
            id: id,
            accountId: accountId,
            typeId: typeId,
            locationId: locationId,
            amount: amount,
            date: date,
            comments: comments)
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
        return AccountSvc().withId(accountId)!
    }
    
    func type() -> Type {
        return TypeSvc().withId(typeId)!
    }
    
    func group() -> Group {
        return GroupSvc().withTypeId(typeId)!
    }
    
    func location() -> Location? {
        return locationId.flatMap { LocationSvc().withId($0) }
    }
    
    func isTransfer() -> Bool {
        return typeId == TypeSvc().transferId
    }
    
}
