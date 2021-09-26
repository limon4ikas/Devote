//
//  BlankView.swift
//  Devote
//
//  Created by Cat on 26.09.2021.
//

import SwiftUI

struct BlankView: View {
    // MARK: - PROPERTES

    // MARK: - BODY

    var body: some View {
        VStack(content: {
            Spacer()
        }) //: VSTACK
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.black)
            .opacity(0.5)
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - PREVIEW

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView()
    }
}
