//
//  DeletedModel.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/14/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse


class DeletedModel: PFObjectConvertible {
    
    let id: Int64
    let parseId: String
    let modelType: ModelType
    
    required init(id: Int64, parseId: String, modelType: ModelType) {
        self.id = id
        self.parseId = parseId
        self.modelType = modelType
    }
    
    func toPFObject() -> PFObject? {
        let pf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: parseId)
        pf["deleted"] = true
        return pf
    }
    
}