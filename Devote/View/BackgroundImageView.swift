//
//  BackgroundImageView.swift
//  Devote
//
//  Created by Cat on 25.09.2021.
//

import SwiftUI

struct BackgroundImageView: View {
    // MARK: - PROPERTIES

    // MARK: - BODY

    var body: some View {
        Image("rocket")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
    }
}

// MARK: - PREVIEW

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
