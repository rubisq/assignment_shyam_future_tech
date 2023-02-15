//
//  ImageListViewModel.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 14/02/23.
//

import Foundation
import Combine

@MainActor
final class ImageListViewModel: ObservableObject {
    
    // MARK: Published
    @Published var imageList: Array<ImageItem> = []
    @Published var errorMessage = ""
    @Published var loading = false
    @Published var loadingMore = false
    
    private var cancellable = Set<AnyCancellable>()
    private var page: Int = 1
    private let limit: Int = 10
    private var isLoading: Bool = false
    
    init() {
        getImages()
    }
    
    // MARK: Utils
    func loadMoreContentIfNeeded(currentItem item: ImageItem?) {
        guard let item = item else {
            getImages()
            return
        }
        
        let thresholdIndex = imageList.index(imageList.endIndex, offsetBy: -2)
        if imageList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            getImages()
        }
    }
    
    func getImages(refresh: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        if refresh {
            page = 1
            loading = true
        }
        if page == 1 {
            loading = true
            imageList = []
        } else {
            loadingMore = true
        }
        NetworkManager().fetchData(endpoint: "list?page=\(page)&limit=\(limit)", responseDecoder: [ImageItem].self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] received in
                guard let self = self else { return }
                self.isLoading = false
                switch received {
                case .finished:
                    debugPrint("Done")
                case .failure(let e):
                    self.errorMessage = e.localizedDescription
                    debugPrint(e.localizedDescription)
                }
            } receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                self.imageList.append(contentsOf: receivedValue)
                self.page += 1
                self.loading = false
                self.loadingMore = false
            }
            .store(in: &cancellable)
    }
    
}
