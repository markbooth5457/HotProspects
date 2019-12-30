//
//  ContentView.swift
//  HotProspects
//
//  Created by Mark Booth on 28/12/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI
import UserNotifications

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}
struct EditView: View {
    @EnvironmentObject var user : User
    var body: some View {
        TextField("name", text: $user.name)
    }
}
struct DisplayView: View {
    @EnvironmentObject var user: User
    var body: some View {
        VStack {
            Text(user.name)
            Button("request permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
                    success, error in
                    if success {
                        print("all set")
                    } else if let error = error {
                        print(error.localizedDescription )
                    }
                }
            }
            Button("schedule notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "it looks hungry"
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
enum NetworkError : Error {
    case badURL, requestFailed, unknown
}
struct ContentView: View {
    var prospects = Prospects()
    @State private var selectedTab = "everyone"
    
    var body: some View {
        TabView(selection: $selectedTab){
            ProspectsView(filter: .none)
                .tabItem{
                    Image(systemName: "person.3")
                    Text("Everyone")
            }
            .tag("everyone")
            ProspectsView(filter: .contacted )
                .onTapGesture {
                    self.selectedTab = "everyone"
            }
            .tabItem{
                Image(systemName: "checkmark.circle")
                Text("Contacted")
            }
            .tag("contacted")
            ProspectsView(filter: .uncontacted)
                .tabItem{
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
            }
            .tag("uncontacted")
            MeView()
                .tabItem{
                    Image(systemName: "person.crop.square")
                    Text("Me")
            }
            .tag("me")
            .onAppear{
                self.fetchData(from: "https://www.apple.com") { result in
                    switch result {
                    case .success(let str):
                        print(str)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Bad URL")
                        case .unknown:
                            print("Unknown error")
                        }
                    }
                }
            }
            } .environmentObject(prospects)
    }
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
