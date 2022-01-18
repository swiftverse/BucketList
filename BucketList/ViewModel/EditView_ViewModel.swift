//
//  EditView_ViewModel.swift
//  BucketList
//
//  Created by Amit Shrivastava on 12/01/22.
//

import Foundation
import MapKit
import SwiftUI

enum LoadingState {
    case loading, loaded, failed
}


extension EditView {
    @MainActor class EditViewModel: ObservableObject {
        @Published  var loadingState = LoadingState.loading
        @Published  var name: String
        @Published  var description: String
        @Published  var pages = [Page]()
        @ObservedObject var contentMain = BucketList.ViewModel()
//        var location = Location(id: UUID(), name: "", description: "", latitude: 0.0, longitude: 0.0)
        init() {
          //  self.location = location
            _name = Published(initialValue: "")
            _description = Published(initialValue: "")
        }
        
        func nearByPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(contentMain.mapRegion.center.latitude)%7C\(contentMain.mapRegion.center.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            
            guard let url = URL(string: urlString) else {
                print("Bad url: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                
                //   pages = items.query.pages.values.sorted { $0.title < $1.title }
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            }
            catch {
                loadingState = .failed
            }
            
        }
        
        
        
    }
}
