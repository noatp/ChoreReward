//
//  UserDatabaseTest.swift
//  ChoreRewardTests
//
//  Created by Toan Pham on 5/20/22.
//

import XCTest
import Combine
@testable import ChoreReward

class UserDatabaseTest: XCTestCase {
    let testUser = User(email: "test1@gmail.com", name: "test123456", role: .parent)
    var userDatabase : MockUserDatabase?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userDatabase = MockUserDatabase(mockUser: testUser)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReadUser() async throws {
        let expectation = XCTestExpectation(description: "listen to a user record from firestore")
        var testResult: User? = nil
        userDatabase?.resetPublisher()
        let currentUserSubscription = userDatabase?.userPublisher.eraseToAnyPublisher()
            .sink(receiveValue: { receivedUser in
                testResult = receivedUser
                expectation.fulfill()
            })
        userDatabase?.readUser(userId: "testUserId")
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(testResult)
        currentUserSubscription?.cancel()
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
