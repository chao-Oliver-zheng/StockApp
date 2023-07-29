//
//  DecodingErrorView.swift
//  StockApp
//
//  Created by Oliver Zheng on 7/28/23.
//

import SwiftUI

struct DecodingErrorView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("Something is wrong with the server, please try again later. ")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

struct DecodingErrorView_Previews: PreviewProvider {
    static var previews: some View {
        DecodingErrorView()
    }
}
