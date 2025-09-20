//
//  PaywallReviewVMTests.swift
//  QRScannerTests
//
//  Created by George Popkich on 7.08.24.
//

//import XCTest
//import StoreKitTest
//
//@testable import QRScanner
//class PaywallReviewVMTests: XCTestCase {
//    
//    var adaptyService: AdaptyService!
//    var session: SKTestSession!
//    var coordinator: MockCoordinator!
//    var viewModel: PaywallReviewVM!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        session = try SKTestSession(configurationFileNamed: "StoreKitTests")
//        session.disableDialogs = true
//        session.clearTransactions()
//        
//        adaptyService = AdaptyService()
//        coordinator = MockCoordinator()
//        viewModel = PaywallReviewVM(coordinator: coordinator, timer: Timer())
//    }
//    
//    override func tearDownWithError() throws {
//        session = nil
//        adaptyService = nil
//        viewModel = nil
//        coordinator = nil
//        try super.tearDownWithError()
//    }
//    
//    func testContinueButtonWithTrial() throws {
//        let expectation = self.expectation(description: "Purchase with trial should succeed")
//        
//        viewModel.continueButtonDidTap(true)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            XCTAssertTrue(self.coordinator.didProceedWithTrial)
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testContinueButtonWithoutTrial() throws {
//        let expectation = self.expectation(description: "Purchase without trial should succeed")
//        
//        viewModel.continueButtonDidTap(false)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            XCTAssertTrue(self.coordinator.didProceedWithoutTrial)
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    class MockCoordinator: PaywallReviewCoordinatorProtocol {
//        var didProceedWithTrial = false
//        var didProceedWithoutTrial = false
//        var didFinish = false
//        
//        func nextStepWithTrial() {
//            didProceedWithTrial = true
//        }
//        
//        func nextStepWithoutTrial() {
//            didProceedWithoutTrial = true
//        }
//        
//        func finish() {
//            didFinish = true
//        }
//    }
//}
