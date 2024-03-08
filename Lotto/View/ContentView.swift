//
//  ContentView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isBottomSheetOpen = false
    @State private var dimOpacity: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GenerateNumberView()
                
                Color.black.opacity(self.dimOpacity)
                    .onTapGesture {
                        self.isBottomSheetOpen = false
                        self.dimOpacity = 0
                    }
                    .ignoresSafeArea()
                
                BottomSheetView(
                    isOpen: $isBottomSheetOpen,
                    dimOpacity: $dimOpacity,
                    maxHeight: geometry.size.height * 0.9,
                    content: RecentLottoView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                )
                
                
                .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    ContentView()
}
