//
//  ContentView.swift
//  DeveloperExtraTool
//
//  Created by Adam Dovciak on 18/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fileEnvirnonment = FileEnvirnonment()
    @State private var isOn = true
    @State private var extendPath = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("/Library Frameworks")
                        .bold()
                    Spacer()
                    TextField("Search...", text: $fileEnvirnonment.searchText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                List {
                    ForEach(fileEnvirnonment.filteredLibDir, id: \.self) { file in
                        HStack {
                            Text(file.name)
                            Spacer()
                            Text(extendPath ? file.fullPath : "Show Full Path").onTapGesture {
                                extendPath = !extendPath ? true : false
                            }
                        }
                  }
                }
                HStack {
                    Text("/System Frameworks")
                        .bold()
                    Spacer()
                }
                List {
                    ForEach(fileEnvirnonment.filteredSystemDir, id: \.self) { file in
                        HStack{
                            Text(file.name)
                            Spacer()
                            Text(extendPath ? file.fullPath : "Show Full Path").onTapGesture {
                                extendPath = !extendPath ? true : false
                            }
                        }
                  }
                }
            }
            .padding()
        }
        .onAppear {
            do {
                fileEnvirnonment.files = try FileManagement().getFrameworksFromRootDirs()
            } catch {
                print(error)
            }
        }
        .environment(fileEnvirnonment)
    }
}

#Preview {
    ContentView()
}
