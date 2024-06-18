//
//  SamplePhrasesViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import Foundation
import Combine

final class SamplePhrasesViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var samples = [String]()
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .sink { [weak self] value in
                if value.replacingOccurrences(of: " ", with: "").isEmpty {
                    self?.samples.removeAll()
                    self?.showError = false
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchDefinition() {
        guard let formattedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        var urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/"
        urlString.append(formattedSearchText)
        
        NetworkService.shared.request(urlString: urlString) { (result: Result<[DictionaryResponse], APIError>) in
            DispatchQueue.main.async { [ weak self ] in
                guard let self = self else { return }
                switch result {
                    case .success(let response):
                        showError = false
                        prepareSamples(for: response)
                    case .failure(let error):
                        print("Failed to fetch definition: \(error)")
                        showError = true
                }
            }
        }
    }
    
    func prepareSamples(for response: [DictionaryResponse]) {
        samples.removeAll()
        response.forEach { response in
            response.meanings.forEach { meaning in
                meaning.definitions.forEach { definition in
                    if let example = definition.example {
                        samples.append(example)
                    }
                }
            }
        }
        if samples.isEmpty {
            showError = true
        }
    }
}
