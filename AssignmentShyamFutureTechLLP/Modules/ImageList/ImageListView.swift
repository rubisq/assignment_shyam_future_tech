//
//  ImageListView.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 13/02/23.
//

import SwiftUI

struct ImageListView: View {
    @StateObject private var viewModel = ImageListViewModel()
    @State private var selectedItem: ImageItem!
    @State private var isAlertShowing: Bool = false
    
    var body: some View {
        NavigationView {
            ActivityIndicatorView(isShowing: .constant(viewModel.loading), content: {
                GeometryReader { reader in
                    List {
                        ForEach(viewModel.imageList) { imageItem in
                            VStack(alignment: .leading, spacing: 0) {
                                RemoteImageView(urlString: imageItem.downloadURL, size: CGSize(width: reader.size.width - 20, height: (reader.size.width - 20) * (CGFloat(imageItem.height) / CGFloat(imageItem.width))))
                                    .cornerRadius(5)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                Text("Author: \(imageItem.author)")
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            }
                            .onTapGesture {
                                selectedItem = imageItem
                                isAlertShowing = true
                            }
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentItem: imageItem)
                            }
                        }
                    }
                    .alert(isPresented: $isAlertShowing) {
                        Alert(
                            title: Text("Author"),
                            message: Text(selectedItem.author),
                            dismissButton: .default(Text("Ok"))
                        )
                    }
                    .onAppear {
                        UITableView.appearance().separatorColor = .clear
                    }
                    .listStyle(.grouped)
                }
            })
            .navigationBarTitle("Image List", displayMode: .large)
            .navigationBarItems(trailing: Button {
                viewModel.getImages(refresh: true)
            } label: {
                Image(uiImage: UIImage(named: "refresh")!.withTintColor(.black))
                    .resizable()
                    .frame(width: 20, height: 20)
            })
        }
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ImageListView()
    }
}
