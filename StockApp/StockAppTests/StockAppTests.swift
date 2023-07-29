//
//  StockAppTests.swift
//  StockAppTests
//
//  Created by Oliver Zheng on 7/28/23.
//

import XCTest
@testable import StockApp
import Combine

final class StockAppTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GetStockApp_Success() async throws {
        
        let viewModel = StockServerMode(service: MockService(fileName: .getStockAppSuccess))
        let expection = XCTestExpectation(description: "StockApp fetch successfully")
        await viewModel.getData()
        
        viewModel.$stocks
            .dropFirst()
            .sink{ stock in
                XCTAssertFalse(stock.isEmpty, "Stocks should not be empty")
                let first = stock.first!
                XCTAssertEqual(first.ticker, "^GSPC")
                expection.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expection], timeout: 5)
    }
    
    func test_GetStockApp_Fail() async throws {
        
        let viewModel = StockServerMode(service: MockService(fileName: .getStockAppFail))
        let expection = XCTestExpectation(description: "StockApp fetch fail")
        await viewModel.getData()
        
        viewModel.$stocks
            .dropFirst()
            .sink{ stock in
                XCTAssertTrue(stock.isEmpty, "Stocks should be empty")
                expection.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expection], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

enum FileName: String {
    case getStockAppSuccess, getStockAppFail
}

class MockService: StockServerProtocol {
    
    let fileName: FileName
    
    init(fileName: FileName) {
        self.fileName = fileName
    }
    private func load(_ fileName: String) -> URL? {
        return  Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")
    }
    func fetchData() async throws -> [Stocks] {
        guard let url  = load(fileName.rawValue) else { throw APIError.invalidUrl}
        let data = try! Data(contentsOf: url)
        do{
            let res = try JSONDecoder().decode(StocksResponse.self, from: data)
            return res.stocks
        }catch {
            return []
        }
    }
    
}

