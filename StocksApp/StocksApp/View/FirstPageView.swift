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
    @State var screenCover: Bool = false
    @State private var scrollPosition: CGFloat = 0.0
    
    
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
                        FirstPageHeaderView(screenCover: $screenCover, isTextFieldVisible: $isTextFieldVisible, textValue: $textValue, viewModel: viewModel, path: $path)
                     
                            ScrollView(showsIndicators: false){
                                
                                VStack(alignment: .leading){
                                    Text("Investing")
                                        .font(.system(size: 30).bold())
                                        .padding(.horizontal)    
                                    Text("$ " + viewModel.totalPrice())
                                        .font(.system(size: 30).bold())
                                        .padding()
                                    Text("Stocks")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    ForEach(viewModel.filteredData(), id:\.self) { stock in
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
                                .background(GeometryReader {
                                                Color.clear.preference(key: ViewOffsetKey.self,
                                                    value: -$0.frame(in: .named("scroll")).origin.y)
                    
                                            })
                                .onPreferenceChange(ViewOffsetKey.self) { [self] newValue in
                                    DispatchQueue.main.async {
                                        isTextFieldVisible = ( newValue > -42)
                                    }
                                }
                            }
                        FirstPageFooterView()
                    }
                    
                    .background(.black)
                    .foregroundColor(.white)
                }
                
            }
        }
        .onAppear{viewModel.getData()}
    }
   
    
   
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView()
    }
}
