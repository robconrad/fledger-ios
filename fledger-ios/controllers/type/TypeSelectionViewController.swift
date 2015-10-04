//
//  Item    EditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class TypeSelectionViewController: AppUIViewController {
    
    @IBOutlet var table: TypesTableView!
    
    var typeId: Int64?
    var selectHandler: SelectIdHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.selectHandler = { id in
            self.selectHandler?(id)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
        typeId.map { table.setType($0) }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TypeEditViewController {
            let currentHandler = dest.editHandler
            dest.editHandler = { typeId in
                currentHandler(typeId)
                typeId.map { self.table.selectHandler!($0) }
            }
        }
    }

}
