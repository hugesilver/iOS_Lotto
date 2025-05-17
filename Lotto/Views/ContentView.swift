//
//  ContentView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                GenerateNumberView()
                    .onAppear {
                        isPresented = true
                    }
                    .onDisappear {
                        isPresented = false
                    }
                
                HStack(spacing: 16) {
                    NavigationLink(destination: MapView()) {
                        Image(systemName: "map")
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        isPresented = false
                    })
                    
                    NavigationLink(destination: ScannerView()) {
                        Image(systemName: "qrcode")
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        isPresented = false
                    })
                }
                .padding(28)
            }
        }
        .sheet(isPresented: $isPresented) {
            RecentLottoView()
                .interactiveDismissDisabled(true)
                .presentationDetents([.fraction(0.15), .fraction(0.75)])
                .presentationBackgroundInteraction(
                    .enabled(upThrough: .fraction(0.15))
                )
                .presentationCornerRadius(16)
        }
    }
}

#Preview {
    ContentView()
}
