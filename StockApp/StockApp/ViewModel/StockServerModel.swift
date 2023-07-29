//
//  StockServerModel.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import Foundation
import Combine

class StockServerMode: ObservableObject {
    
    @Published var stocks: [Stocks] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    let service: StockServerProtocol
    
    init(service: StockServerProtocol = StockServer()) {
        self.service = service
        Task {
            await getData()
        }
    }
    
    @MainActor func getData() {
        isLoading = true
        Task {
            do{
                let stocks: [Stocks] = try await service.fetchData()
                self.stocks = stocks
                isLoading = false
            } catch {
                if  let error = error as? APIError  {
                    print(error.description)
                    errorMessage = error.description
                } else {
                    print(error)
                    errorMessage = error.localizedDescription
                }
            }
            
        }
    }
    
}
