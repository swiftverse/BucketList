//
//  ContentView.swift
//  BucketList
//
//  Created by Amit Shrivastava on 06/01/22.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct BucketList: View {
    //    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    //    @State private var locations = [Location]()
    //    @State private var selectedPlace: Location?
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        //nice trick below
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    //                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            //                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: viewModel.mapRegion.center.latitude, longitude: viewModel.mapRegion.center.longitude)
                            //                        viewModel.locations.append(newLocation)
                            viewModel.addLocations()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                        
                    }
                }
                
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                Text(place.name)
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            //---
            .alert(isPresented: $viewModel.showPrivacyAlert) {
                Alert (title: Text("Acces to FaceCam is required to face cam setting"),
                       message: Text("Go to Settings?"),
                       primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                       secondaryButton: .default(Text("Cancel")))
            }
            //---
        }
    }
}




struct BucketList_Previews: PreviewProvider {
    static var previews: some View {
        BucketList()
    }
}
