//
//  ItemAccountEditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AccountSelectionViewController: AppUIViewController {
    
    @IBOutlet var table: AccountsTableView!
    
    var accountId: Int64?
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
        accountId.map { table.setAccount($0) }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? AccountEditViewController {
            let currentHandler = dest.editHandler
            dest.editHandler = { accountId in
                currentHandler(accountId)
                accountId.map { self.table.selectHandler!($0) }
            }
        }
    }

}
