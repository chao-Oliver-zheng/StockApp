//
//  FirstPageView.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import SwiftUI

struct FirstPageView: View {
    
    @StateObject var viewModel = StockServerMode()
    @State private var path = NavigationPath()
    @State private var isTextFieldVisible = false
    @State private var textValue = ""
    
    var body: some View {
        
        NavigationStack(path: $path){
            VStack{
                if !viewModel.errorMessage.isEmpty{
                    DecodingErrorView()
                } else if viewModel.isLoading {
                    LoadingView()
                }  else if viewModel.stocks.count == 0 {
                    EmptyJsonView()
                }else {
                    VStack{
                        FirstPageHeaderView(isTextFieldVisible: $isTextFieldVisible, textValue: $textValue)
                        ScrollView(showsIndicators: false){
                            VStack(alignment: .leading){
                                Text("Investing")
                                    .font(.system(size: 30).bold())
                                
                                    .padding(.horizontal)
                                
                                Text("$ \(total)")
                                    .font(.system(size: 30).bold())
                                    .padding()
                                
                                Text("Stocks")
                                    .font(.headline)
                                    .padding(.horizontal)
                                ForEach(SearchData, id:\.self) { stock in
                                    NavigationLink(value: stock){
                                        if let hold = stock.quantity {
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    Text(stock.ticker)
                                                        .font(.headline)
                                                    Text("\(hold) shares")
                                                        .font(.subheadline)
                                                        .opacity(0.9)
                                                }
                                                Spacer()
                                                HStack{
                                                    Text(stock.currency)
                                                    Text("\(String(format: "%.2f", (Double(Double(stock.current_price_cents)/100))))")
                                                        .font(.subheadline)
                                                }
                                                .frame(width: 120, height: 35, alignment: .center)
                                                .background(.green)
                                                .cornerRadius(10)
                                            }
                                            
                                        } else{
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    Text(stock.ticker)
                                                        .font(.headline)
                                                    Text(stock.name)
                                                        .frame(maxWidth: 150, alignment: .leading)
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                        .font(.subheadline)
                                                        .opacity(0.9)
                                                }
                                                Spacer()
                                                HStack{
                                                    Text(stock.currency)
                                                    Text("\(String(format: "%.2f", (Double(Double(stock.current_price_cents)/100))))")
                                                        .font(.subheadline)
                                                }
                                                .frame(width: 120, height: 35, alignment: .center)
                                                .background(.green)
                                                .cornerRadius(10)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .navigationDestination(for: Stocks.self){ item in
                                    SecondPageView(stocks: item, path: $path, viewModel: viewModel)
                                }
                                .listStyle(.grouped)
                            }
                        }
                        FirstPageFooterView()
                    }
                    .background(.black)
                    .foregroundColor(.white)
                }
                   
            }
        }
    }
    
    private var SearchData: [Stocks] {
        if textValue.isEmpty{
            return filteredData
        }else{
            return filteredData.filter{$0.ticker.lowercased().contains(textValue.lowercased())}
        }
    }
    
    private var filteredData: [Stocks] {
        let sortedData = viewModel.stocks.sorted{ stock1, stock2 in
            
            if let quant1 = stock1.quantity, let quant2 = stock2.quantity {
                return quant1 < quant2
            }
            return stock1.quantity != nil
        }
        return sortedData
    }
    
    private var total: String {
        var cur: Double = 0.0
        for obj in  viewModel.stocks{
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
struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView()
    }
}
