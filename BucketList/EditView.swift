//
//  EditView.swift
//  BucketList
//
//  Created by Amit Shrivastava on 08/01/22.
//

import SwiftUI


struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    @State private var loadingState = LoadingState.loading
    @State private var name: String
    @State private var description: String
    @State private var pages = [Page]()
    var onSave: (Location) -> Void
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id:\.pageid) {
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
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            
            .task {
                await fetchNearbyPlaces()
            }
        }
        
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        
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


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) {
            newlocation in
        }
    }
}
