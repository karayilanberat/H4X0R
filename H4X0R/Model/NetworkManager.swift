//
//  NetworkManager.swift
//  H4X0R
//
//  Created by berat on 20.07.2024.
//

import Foundation

class NetworkManager: ObservableObject {
    
    var optionalStoryIDs: [Int]?

    @Published var stories = [Story]()
    
    func fetchData() {
        
        let urlForID = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
        
        guard let urlForID = urlForID else {
            print("Invalid URL")
            return
        }
        
        // Fetch the story IDs
        getData(url: urlForID, decodingType: [Int].self) { result in
            switch result {
            case .success(let storyIDs):
                print(storyIDs)
                // Fetch the stories after getting the story IDs
                self.fetchStories(for: Array(storyIDs.prefix(50))) { stories in
                    DispatchQueue.main.async {
                        self.stories = stories
                    }
                }
            case .failure(let error):
                print("Failed to fetch data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchStories(for ids: [Int], completion: @escaping ([Story]) -> Void) {
        var stories: [Story] = []
        let group = DispatchGroup()
        var fetchError: Error? = nil

        for id in ids {
            guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty") else {
                print("Invalid URL")
                continue
            }
            
            group.enter()
            
            getData(url: url, decodingType: Story.self) { result in
                switch result {
                case .success(let story):
                    stories.append(story)
                case .failure(let error):
                    fetchError = error
                    print("Failed to fetch story \(id): \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                print("Failed to fetch some stories: \(error.localizedDescription)")
            }
            completion(stories)
        }
    }
    
    func getData<T: Decodable>(url: URL, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(decodingType, from: safeData)
                    completion(.success(decodedData))
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
