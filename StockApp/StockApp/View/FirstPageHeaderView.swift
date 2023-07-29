//
//  FirstPageHeaderView.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import SwiftUI

struct FirstPageHeaderView: View {
    @Binding var isTextFieldVisible: Bool
    @Binding var textValue: String
    var body: some View {
        ZStack{
            Color.black
                .frame(width: UIScreen.main.bounds.width, height: 80)
            VStack{
                HStack{
                    Button(action: { print("Pressed profile") })
                    {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40 )
                        
                    }
                    Spacer()
                    Button(action: {
                        isTextFieldVisible.toggle()
                        
                    })
                    {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40 )
                    }
                }
                if isTextFieldVisible {
                    CustomSearchTextField(searchText: $textValue)
                }
            }
            .padding(.horizontal)
        }
      
       
        
    }
}
struct CustomSearchTextField: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search", text: $searchText)
                .padding(.vertical, 10)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                })
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}
//struct FirstPageHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstPageHeaderView()
//    }
//}
