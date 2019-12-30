//
//  MeView.swift
//  HotProspects
//
//  Created by Mark Booth on 29/12/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Mark Booth"
    @State private var emailAddress = "mark@markandpol.com"
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationView{
            VStack {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                    .padding([.horizontal, .bottom])
                Image(uiImage: generateQRCodde(from: "\(name)\n\(emailAddress)"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
                Spacer()
            }
        .navigationBarTitle("Your Code")
        }
    }
    func generateQRCodde(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
