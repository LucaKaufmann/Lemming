//
//  DesignSystemPreview.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI

struct DesignSystemPreview: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Text("This is the text color on background")
                .foregroundColor(Color.LemmingColors.text)
            Group {
                Rectangle()
                    .overlay {
                        Text("This is the text color on orange")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingOrange"))
                Rectangle()
                    .overlay {
                        Text("This is the text color on green")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingGreen"))
                Rectangle()
                    .overlay {
                        Text("This is the text color on blue")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingBlue"))
                Rectangle()
                    .overlay {
                        Text("This is the text color on beige")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingBeige"))
                Rectangle()
                    .overlay {
                        Text("This is the text color on gray")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingGray"))
                Rectangle()
                    .overlay {
                        Text("This is the text color on brown")
                            .foregroundColor(Color.LemmingColors.text)
                    }
                    .frame(height: 50)
                    .foregroundColor(Color("lemmingBrown"))
            }
            Spacer()
            Button("Primary button") {
                
            }.buttonStyle(LemmingButton(style: .primary))
            Button("Primary button") {
                
            }.buttonStyle(LemmingButton(style: .primary, iconName: "powersleep"))
            Button("Secondary button") {
                
            }.buttonStyle(LemmingButton(style: .secondary))
            
            Button("Secondary button") {
                
            }.buttonStyle(LemmingButton(style: .destruction))
            Spacer()
        }
        .padding()
        .background {
            Color.LemmingColors.background.ignoresSafeArea()
        }
    }
}

struct DesignSystemPreview_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystemPreview()
    }
}
