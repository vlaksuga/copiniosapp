//
//  Loader.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI

struct Loader: View {
    @State var spinCircle = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 100)
                .background(Color.white).cornerRadius(8).opacity(0.7)
                .shadow(color: .black, radius: 16)
                .padding()
            HStack {
                Circle()
                    .trim(from: 0.3, to: 1)
                    .stroke(Color.red, lineWidth: 5)
                    .frame(width: 30, height: 30)
                    .padding(.all, 10)
                    .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
                    .onAppear {
                        self.spinCircle = true
                    }
            
                Text("Please wait! This may take a moment.")
                    .foregroundColor(.white)
            }
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
