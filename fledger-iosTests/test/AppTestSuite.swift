//
// Created by Robert Conrad on 5/10/15.
// Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import FledgerCommon
import Parse

class AppTestSuite: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        // reinitialize all services on test suite initialization
        ServiceBootstrap.preRegister()
        PFUser.logInWithUsername("test", password: "test")
        ServiceBootstrap.register()
    }

}
