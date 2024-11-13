import SwiftUI
import Combine

// ViewModel
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var weather: Weather? = nil
    @Published var isLoading = false
    private var debounceTimer: AnyCancellable?
    
    init() {
        debounceText()
    }

    private func debounceText() {
        debounceTimer = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] debouncedText in
                // Avoid calling search when the text is empty
                guard !debouncedText.isEmpty else {
                    self?.weather = nil
                    return
                }
                
                // Start loading and call search when the text is not empty
                self?.isLoading = true
                
                // Ensure the async search function is called properly
                Task {
                    do {
                        try await self?.search(with: debouncedText)
                    } catch {
                        print("Search error: \(error)")
                    }
                }
            }
    }
    
    @MainActor
    private func search(with text: String) async throws {
        let geocodingClient = GeocodingClient()
        let weatherClient = WeatherClient()
        
        do {
            let location = try await geocodingClient.coordinateByCity(text)
            if let location = location {
                let fetchedWeather = try await weatherClient.fetchWeather(location: location)
                
                // Convert temperature to Celsius
                self.weather = Weather(
                    temp: fetchedWeather.temp
                )
            } else {
                self.weather = nil
                print("Location not found.")
            }
        } catch {
            self.weather = nil
            print("Error fetching data: \(error)")
        }
        
        // Stop loading once the request is completed
        self.isLoading = false
    }
}

// ContentView
struct ContentView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                TextField("Search Location", text: $viewModel.searchText)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal, 5)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
            
            // Display message when search text is empty
            if viewModel.searchText.isEmpty {
                Text("Enter a location to search")
                    .foregroundColor(.gray)
                    .padding()
            }
            // Show loading indicator or weather information
            else if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let weather = viewModel.weather {
                VStack {
                    Text("Weather for \(viewModel.searchText)")
                        .font(.title)
                    Text("Temperature: \(MeasurementFormatter.temparature(value: weather.temp))")
                }
                .padding()
            } else {
                Text("No weather data available")
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

// Preview
#Preview {
    ContentView()
}
