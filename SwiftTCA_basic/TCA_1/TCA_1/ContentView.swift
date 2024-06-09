//
//  ContentView.swift
//  TCA_1
//
//  Created by 성재 on 6/9/24.
//

import SwiftUI
import ComposableArchitecture


// 랜덤 데이터 추가하기

enum Animal: String, Equatable {
    case dog = "Dog"
    case cat = "Cat"
}

@Reducer
struct RanAni {
    @ObservableState
    struct State: Equatable {
        var dogcnt: Int = 0
        var catcnt: Int = 0
    }
    
    enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case addcntButtonTapped(Animal)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addcntButtonTapped(let animal):
                switch animal {
                case .dog:
                    state.dogcnt += 1
                case .cat:
                    state.catcnt += 1
                }
                return .none
            case .binding:
                return .none
            }
        }
    }
}


struct ContentView: View {
    
    @Bindable var store: StoreOf<RanAni>
    
    var body: some View {
        VStack {
            
            HStack {
                VStack {
                    Text("DOG")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(store.dogcnt)")
                        .font(.title)
                }
                .padding()
                
                VStack {
                    Text("CAT")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(store.catcnt)")
                        .font(.title)
                }
                .padding()

            }
            .padding()
            
            Text("which is better?")
            
            HStack {
                Button(action: {
                    store.send(.addcntButtonTapped(.dog))
                }, label: {
                    Text("Dog")
                })
                .padding()
                
                Button(action: {
                    store.send(.addcntButtonTapped(.cat))
                }, label: {
                    Text("Cat")
                })
                .padding()

            }
        }
        .padding()
    }
}
