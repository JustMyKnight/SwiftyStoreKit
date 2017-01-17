//
// PaymentQueueControllerTests.swift
// SwiftyStoreKit
//
// Copyright (c) 2017 Andrea Bizzotto (bizz84@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
import SwiftyStoreKit
import StoreKit

extension PaymentQueueController.Payment {
    public init(product: SKProduct, atomically: Bool, applicationUsername: String, callback: @escaping (PaymentQueueController.TransactionResult) -> ()) {
        self.product = product
        self.atomically = atomically
        self.applicationUsername = applicationUsername
        self.callback = callback
    }
}

class PaymentQueueControllerTests: XCTestCase {

    class TestProduct: SKProduct {
        
        var _productIdentifier: String = ""
        
        override var productIdentifier: String {
            return _productIdentifier
        }
        
        init(productIdentifier: String) {
            _productIdentifier = productIdentifier
            super.init()
        }
    }
    
    // MARK: init/deinit
    func testInit_registersAsObserver() {
        
        let spy = PaymentQueueSpy()
        
        let paymentQueueController = PaymentQueueController(paymentQueue: spy)
        
        XCTAssertTrue(spy.observer === paymentQueueController)
    }
    
    func testDeinit_removesObserver() {
        
        let spy = PaymentQueueSpy()
        
        let _ = PaymentQueueController(paymentQueue: spy)
        
        XCTAssertNil(spy.observer)
    }
    
    // MARK: Start payment
    
    func testStartTransaction_QueuesOnePayment() {
        
        let spy = PaymentQueueSpy()
        
        let paymentQueueController = PaymentQueueController(paymentQueue: spy)

        let product = TestProduct(productIdentifier: "com.SwiftyStoreKit.product1")
        let payment = PaymentQueueController.Payment(product: product, atomically: true, applicationUsername: "", callback: { result in })

        paymentQueueController.startPayment(payment)
        
        XCTAssertEqual(spy.payments.count, 1)
    }
}
