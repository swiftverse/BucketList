//
//  EditView.swift
//  BucketList
//
//  Created by Amit Shrivastava on 08/01/22.
//

import SwiftUI

enum LoadingData {
    case loading, loaded, failed
}

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State  var descriptionLocation: String
    @State  var nameLocation: String
    @State var loadingState = LoadingData.loaded
    @State var pages = [Page]()
    var save:(Location) -> Void
    var location: Location
    init(location: Location, save: @escaping (Location) -> Void) {
        self.location = location
        self.save = save
        _nameLocation = State(initialValue: location.name)
        _descriptionLocation = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of location", text: $nameLocation)
                    TextField("Description", text: $descriptionLocation)
                }
                
                Section("Near by places...") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) {
                            page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                    case .loading:
                        Text("Loading...")
                        
                    case .failed:
                        Text("please try again later")
                        
                    }
                }
            }
            .task {
                await nearByPlaces()
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                  //  try this once ViewModel is created
                 //   location.name = nameLocation
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = nameLocation
                    newLocation.description = descriptionLocation
                    save(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    func nearByPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("no file at \(urlString)")
            return
        }
        
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        }
        
        catch {
            loadingState = .failed
        }
    }
}

struct EditView_Previews: PreviewProvider {
    //use the struct name itself when calling it
    static var previews: some View {
        EditView(location: Location.example) {
            _ in
        }
    }
}
