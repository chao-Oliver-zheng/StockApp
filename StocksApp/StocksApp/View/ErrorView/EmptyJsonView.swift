//
//  EmptyJsonView.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import SwiftUI

struct EmptyJsonView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("The page was not found")
                .foregroundColor(.white)
        }
    }
}

struct EmptyJsonView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyJsonView()
    }
}
