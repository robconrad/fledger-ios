//
//  AccountEditViewControllerSuite.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import fledger_ios


class AccountEditViewControllerSuite: AppTestSuite {

    var vc: AccountEditViewController!
    let account = Account(id: 1, name: "name", priority: 1, inactive: true)

    override func setUp() {
        super.setUp()

        Services.register(AccountService.self, AccountServiceMock())

        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("AccountEditViewController") as! AccountEditViewController
        vc.viewDidLoad()
    }

    func testViewWillAppear() {
        XCTAssertEqual(vc.nameLabel.text!, "Name:")
        XCTAssertEqual(vc.name.text!, "")

        // appear without account
        vc.account = nil
        vc.viewWillAppear(true)
        XCTAssertEqual(vc.title!, "Add Account")
        XCTAssertEqual(vc.name.text!, "")
        XCTAssert(vc.active.on)

        // appear with account
        vc.account = account
        vc.viewWillAppear(true)
        XCTAssertEqual(vc.title!, "Edit Account")
        XCTAssertEqual(vc.name.text, account.name)
        XCTAssert(vc.active.on == !account.inactive)
    }

    func testSave() {
        // save new account
        vc.account = nil
        vc.save(self)

        // save existing account
        vc.account = account
    }

    func testCheckErrors() {

        checkErrors(false, vc.nameLabel) {
            self.vc.name.text = "valid name"
        }

        checkErrors(true, vc.nameLabel) {
            self.vc.name.text = ""
        }

        checkErrors(true, vc.nameLabel) {
            self.vc.name.text = nil
        }
    }

    private func checkErrors(error: Bool, _ item: UILabel, setup: () -> ()) {
        vc.errors = false
        setup()
        vc.checkErrors()
        XCTAssertEqual(vc.errors, error)
        XCTAssertEqual(item.textColor, error ? AppColors.textError() : AppColors.text())
    }
    
}