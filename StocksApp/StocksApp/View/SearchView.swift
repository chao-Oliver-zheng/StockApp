//
//  SearchView.swift
//  StocksApp
//
//  Created by Oliver Zheng on 7/29/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: StockServerMode
    @Binding var textValue: String
    @Binding var screenCover: Bool
    @Binding var path: NavigationPath
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    SearchBarTextField(searchText: $textValue)
                    ScrollView{
                        ForEach(viewModel.SearchData(textValue), id:\.self) { stock in
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
                        .padding()
                        .navigationDestination(for: Stocks.self){ item in
                            SecondPageView(stocks: item, path: $path, viewModel: viewModel)
                        }
                    }
                    .background(Color.black)
                    .listStyle(.plain)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(
                                action:
                                    {
                                        screenCover = false
                                        path = NavigationPath()
                                    }){
                                        Text("< Back")
                                            .foregroundColor(.blue)
                                    }
                        }
                    }
                    
                }
                .background(Color.black)
            }
            }
           
        }
}

struct SearchBarTextField: View {
    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(height: 36)
               
                

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Search", text: $searchText)
                    .padding(7)
                    .padding(.leading, -7)
                    .foregroundColor(.white)
                    .onTapGesture {
                        isEditing = true
                    }

                if isEditing {
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    })
                }
            }
        }
        .padding(.horizontal)
    }
}
