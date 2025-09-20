//
//  AdaptyServiceTests.swift
//  QRScannerTests
//
//  Created by George Popkich on 7.08.24.
//

import XCTest

@testable import QRScanner
final class AdaptyServiceTests: XCTestCase {

    var adaptyService: AdaptyService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        adaptyService = AdaptyService()
    }
    
    override func tearDownWithError() throws {
        adaptyService = nil
        try super.tearDownWithError()
    }
       
    func testExample() throws {
           XCTAssertTrue(true, "This test should always succeed")
       }

}
