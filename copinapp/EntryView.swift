//
//  EntryView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/26.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image("logo")
                .resizable()
                .frame(width: 120, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
