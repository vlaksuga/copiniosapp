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
            HStack {
                Circle()
                    .trim(from: 0.3, to: 1)
                    .stroke(Color.orange, lineWidth: 5)
                    .frame(width: 30, height: 30)
                    .padding(.all, 10)
                    .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
                    .onAppear {
                        self.spinCircle = true
                    }
            }
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
