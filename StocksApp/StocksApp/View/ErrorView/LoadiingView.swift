//
//  LoadingView.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("Loading...")
                .foregroundColor(.white)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
