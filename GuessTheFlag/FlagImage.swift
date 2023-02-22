//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Justin Hold on 2/22/23.
//

import SwiftUI

struct FlagImage: View {
	let name: String
	
    var body: some View {
        Image(name)
			.renderingMode(.original)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.shadow(radius: 20)
			.padding(10)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
		FlagImage(name: "US")
    }
}
