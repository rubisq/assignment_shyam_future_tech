//
//  ActivityIndicator.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 15/02/23.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .white
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicatorView<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: 100, height: 100)
                .background(Color.gray)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
    
}
