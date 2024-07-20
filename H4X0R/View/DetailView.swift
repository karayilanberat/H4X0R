//
//  DetailView.swift
//  H4X0R
//
//  Created by berat on 20.07.2024.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
        
    var body: some View {
        WebView(urlString: url)
    }
}


#Preview {
    DetailView(url: "https://www.google.com")
}
