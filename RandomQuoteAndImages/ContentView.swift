//
//  ContentView.swift
//  RandomQuoteAndImages
//
//  Created by Henri on 12.12.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var randomImageListVM = RandomImageListViewModel()
    
    var body: some View {
        NavigationView {
            List(randomImageListVM.randomImages) { randomImage in
                HStack {
                    randomImage.image.map {
                        Image(uiImage: $0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    VStack(spacing: 20) {
                        Text(randomImage.quote)
                        Text("-\(randomImage.author)")
                    }
                }
            }
            .task {
                await randomImageListVM.getRandomImages(ids: Array(100...200))
            }
            .navigationTitle("Random Images/Quotes")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    await randomImageListVM.getRandomImages(ids: Array(100...200))
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
