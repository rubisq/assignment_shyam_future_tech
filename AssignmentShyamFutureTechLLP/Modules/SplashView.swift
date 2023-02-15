//
//  SplashView.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 13/02/23.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Image(uiImage: UIImage(named: "logo")!)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                Router.showMain()
            })
        })
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
