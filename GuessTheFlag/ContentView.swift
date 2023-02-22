//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Justin Hold on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var questionCounter = 1
	
	// alert variables
    @State private var showingScore = false
	@State private var scoreTitle = ""
	
	// end game results variable
    @State private var showingResults = false
    
    @State private var scoreNumber = 0
    @State private var selectedFlag = -1
    @State private var countries = allCountries.shuffled()
	@State private var correctAnswer = Int.random(in: 0...2)
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    var body: some View {
        ZStack {
			LinearGradient(colors: [.red, .red, .white, .blue, .blue], startPoint: .top, endPoint: .bottom)
				.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
					.foregroundStyle(.primary)
                    .font(.largeTitle.bold())
				Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the country of")
                            .foregroundStyle(.primary)
                            .font(.subheadline.weight(.heavy))
							.padding(7)
                        Text(countries[correctAnswer])
							.foregroundStyle(.primary)
							.font(.title.weight(.semibold)).italic()
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                                .animation(.default, value: selectedFlag)
                                .accessibilityLabel(labels[countries[number], default: "Unknown Flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text("Score: \(scoreNumber)")
					.foregroundStyle(.primary)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(scoreNumber)")
        }
        .alert("Game Over!", isPresented: $showingResults) {
            Button("Start Over", action: newGame)
        } message: {
            Text("Your final score was \(scoreNumber)")
        }
    }
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreNumber += 1
        } else {
            let needsThe = ["US", "UK"]
            let theirAnswer = countries[number]
            if needsThe.contains(theirAnswer) {
                scoreTitle = "False, that's the flag of the \(countries[number])."
            } else {
                scoreTitle = "False, that's the flag of \(countries[number])."
            }
            if scoreNumber > 0 {
                scoreNumber -= 1
            }
        }
        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    func newGame() {
        questionCounter = 0
        scoreNumber = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
 }
