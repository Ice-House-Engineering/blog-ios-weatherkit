//
//  ContentView.swift
//  weatherdemo
//
//  Created by Eibiel Sardjanto on 20/06/22.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {

	@State var temperature: String?
	@State var uvIndex: UVIndex?
	@State var symbol: String?
	@State var status: String?

	var body: some View {
		VStack(spacing: 10) {
			Image(systemName: symbol ?? "")
			Text("Jakarta")
				.font(.title2)
			Text(status ?? "Getting current weather status")
				.font(.title3)
			Text(temperature ?? "Getting current temperature")
			Text("UV Index: " + String(uvIndex?.value ?? 0))
			Text(uvIndex?.category.rawValue ?? "Nan")
		}
		.onAppear {
			Task {
				await getWeather()
			}
		}
	}
}

extension ContentView {

	func getWeather() async {

		let weatherService = WeatherService()

		let jakarta = CLLocation(latitude: -6.2, longitude: 106.8)

		let weather = try! await weatherService.weather(for: jakarta)

		temperature = weather.currentWeather.temperature
			.converted(to: .celsius)
			.formatted(.measurement(usage: .asProvided))


		uvIndex = weather.currentWeather.uvIndex

		symbol = weather.currentWeather.symbolName

		status = weather.currentWeather.condition.rawValue

	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
