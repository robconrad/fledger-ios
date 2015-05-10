//
//  Item    EditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class GroupSelectionViewController: AppUIViewController {
    
    @IBOutlet var table: GroupsTableView!
    
    var groupId: Int64?
    var selectHandler: SelectIdHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.selectHandler = { id in
            self.navigationController?.popViewControllerAnimated(true)
            self.selectHandler?(id)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
        groupId.map { table.setGroup($0) }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? GroupEditViewController {
            let currentHandler = dest.editHandler
            dest.editHandler = { groupId in
                currentHandler(groupId)
                groupId.map { self.table.selectHandler!($0) }
            }
        }
    }

}
