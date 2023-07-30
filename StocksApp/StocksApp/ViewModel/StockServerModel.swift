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
    
    func filteredData() -> [Stocks] {
        let sortedData = stocks.sorted{ stock1, stock2 in
            
            if let quant1 = stock1.quantity, let quant2 = stock2.quantity {
                return quant1 < quant2
            }
            return stock1.quantity != nil
        }
        return sortedData
    }
    
    func SearchData(_ value: String) -> [Stocks] {
        if value.isEmpty{
            return []
        }else{
            return filteredData().filter{$0.ticker.lowercased().contains(value.lowercased())}
        }
    }
    
    func totalPrice() -> String {
        var cur: Double = 0.0
        for obj in stocks {
            if let qua = obj.quantity {
                cur += (Double(obj.current_price_cents) * Double(qua))
            }else{ }
        }
        cur = Double(cur/100)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: cur))!
    }
}
