//
//  ContentView.swift
//  TCA_2
//
//  Created by 성재 on 6/17/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher
import Combine

@Reducer
struct Dog {
    @ObservableState
    struct State: Equatable {
        var dogImages: [DogImage] = []
    }
    
    enum Action {
        case fetchDogImagesResponse(Result<[DogImage], Error>)
        case DogImagerButtonTapped
    }

    @Dependency(\.dogAPI) var dogAPI
    private enum CancelID { case doggy }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchDogImagesResponse(.success(let dogimage)):
//                print(dogimage)
                state.dogImages = dogimage
                return .none
            case .fetchDogImagesResponse(.failure):
                state.dogImages = []
                return .none
            case .DogImagerButtonTapped:
//                guard !state.dogImages.isEmpty else {
//                    print("HERE")
//                    return .none
//                }
                return .run { send in
                    print("HERE2")
                    await send(
                        .fetchDogImagesResponse(
                            Result { try await self.dogAPI.dogimage() }
                        )
                    )
                }
                .cancellable(id: CancelID.doggy)
            }
        }
    }
}

struct ContentView: View {
    @Bindable var store: StoreOf<Dog>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Fetch Dog Images") {
               store.send(.DogImagerButtonTapped)
           }
           .padding()
            List {
                ForEach(store.dogImages, id: \.id) { dogImage in
                    VStack(alignment: .leading) {
//                        AsyncImage(url: URL(string: dogImage.url)) { image in
//                            image
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 200)
//                                .cornerRadius(10)
//                                .padding()
//                        } placeholder: {
//                            ProgressView()
//                        }
                        KFImage(URL(string: dogImage.url))
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                        

                        if let breed = dogImage.breeds.first {
                            Text(breed.name)
                                .font(.headline)
                            Text("Weight: \(breed.weight.metric) kg")
                            Text("Height: \(breed.height.metric) cm")
                        }
                    }
                }
            }
        }
//        .onAppear {
//            store.send(.DogImagerButtonTapped)
//        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
