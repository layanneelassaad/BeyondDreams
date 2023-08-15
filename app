//
//  ContentView.swift
//  BeyondDreams
//
//  Created by Layanne El Assaad on 8/10/23.
//

import SwiftUI

import Foundation

class DreamManager: ObservableObject {
    @Published var dreams: [Dream] = []

    func addDream(text: String, moodIndex: Int, doodleData: Drawing) {
           let doodle = doodleData.dataRepresentation()
           let newDream = Dream(text: text, moodIndex: moodIndex, doodleData: doodle)
           dreams.append(newDream)
       }

    func updateDoodleData(for dreamIndex: Int, with drawing: Drawing) {
          if dreamIndex >= 0 && dreamIndex < dreams.count {
              let doodleData = drawing.dataRepresentation() // Convert Drawing to Data
              dreams[dreamIndex].doodleData = doodleData
          }
      }
}


struct Dream: Identifiable, Codable {
    var id = UUID()
    var text: String
    var moodIndex: Int
    var doodleData: Data? // Store doodle as Drawing
    var moodEmoji: String {
        if moodIndex < moods.count {
            return moods[moodIndex]
        } else {
            return ""
        }
    }

    private var moods: [String] = ["😔", "😕", "😐", "🙂", "😀", "😃", "😄", "😁", "😆", "😇"]
    
    init(text: String, moodIndex: Int, doodleData: Data? = nil) {
        self.text = text
        self.moodIndex = moodIndex
        self.doodleData = doodleData
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, text, moodIndex, doodleData
    }
    
    func doodleDrawing() -> Drawing? {
        if let doodleData = doodleData {
            return Drawing.fromData(data: doodleData)
        } else {
            return nil
        }
    }

    var doodleImage: UIImage? {
          if let doodleData = doodleData {
              return UIImage(data: doodleData)
          } else {
              return nil
          }
      }
}






struct ContentView: View {
    @StateObject var dreamManager = DreamManager()

    var body: some View {
        NavigationView {
            WelcomeView(dreamManager: dreamManager)
        }
    }
}


struct WelcomeView: View {
    @State private var isRecordDreamViewPresented = false
    @ObservedObject var dreamManager: DreamManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Welcome to BeyondDreams")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                        .padding(.top, 100)
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: RecordDreamView(dreamManager: dreamManager, isPresented: $isRecordDreamViewPresented)) {
                            Text("Start Recording Dream")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.purple)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                        }
                        
                        NavigationLink(destination: DreamLibraryView(dreamManager: dreamManager)) {
                            Text("Dream Library")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}



struct SettingsView: View {
    @State private var showNotifications = true
    @State private var selectedTheme = 0
    @State private var selectedFontSize = 1
    @State private var selectedLanguage = 0

    let themes = ["Light", "Dark"]
    let fontSizes = ["Small", "Medium", "Large"]
    let languages = ["English", "Spanish", "French", "German"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)

                Toggle("Notifications", isOn: $showNotifications)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)

                Picker("Theme", selection: $selectedTheme) {
                    ForEach(0..<themes.count, id: \.self) { index in
                        Text(self.themes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 10)

                Picker("Font Size", selection: $selectedFontSize) {
                    ForEach(0..<fontSizes.count, id: \.self) { index in
                        Text(self.fontSizes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(0..<languages.count, id: \.self) { index in
                        Text(self.languages[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 10)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


class DreamAnalyzer {
    func analyzeDreamText(_ text: String) -> String {
        let commonDreams: [String: String] = [
            "flying": "Dreaming of flying often represents a desire for freedom or a sense of empowerment. It can also indicate a need to escape from a challenging situation.",
            "falling": "Dreaming of falling may symbolize a loss of control or a sense of insecurity. It can also reflect feelings of failure or a fear of losing one's footing in life.",
            "being chased": "Being chased in a dream can signify anxiety or a sense of being pursued by a problem or challenge. It may also reflect a need to confront or address something you've been avoiding.",
            "naked": "Dreaming of being naked can represent vulnerability, exposure, or a fear of being judged. It may also indicate a desire to reveal your true self or embrace authenticity.",
            "teeth falling out": "Dreaming of teeth falling out can symbolize concerns about appearance, communication issues, or feelings of powerlessness. It may reflect a fear of aging or a loss of confidence.",
            "falling behind": "Dreaming of falling behind may suggest feelings of inadequacy or a fear of not meeting expectations. It could also indicate a need to catch up in some aspect of your life.",
            "exams or tests": "Dreaming of taking exams or tests often relates to feelings of stress, preparedness, or self-evaluation. It may indicate a fear of failure or a desire to prove yourself.",
            "being late": "Dreaming of being late can represent anxiety about missing out on opportunities or a fear of not meeting deadlines. It may reflect a need for better time management.",
            "water": "Dreaming of water can have various meanings, such as emotions, subconscious thoughts, or change. Calm water may represent tranquility, while turbulent water can signify emotional turmoil.",
            "being trapped": "Dreaming of being trapped or confined can reflect a sense of being stuck in a situation or feeling limited in your choices. It may suggest a need to break free from constraints.",
            // Add more dream meanings here
            "fire": "Fire in dreams can symbolize transformation, passion, or destruction. It may indicate a desire for change or a need to address intense emotions.",
            "falling teeth": "Dreaming of falling teeth can reflect concerns about appearance, self-image, or communication. It may also symbolize a fear of embarrassment or loss of personal power.",
            "drowning": "Dreaming of drowning can represent overwhelming emotions or a fear of being overwhelmed by a situation. It may suggest a need to confront your feelings.",
            "failing a test": "Failing a test in a dream may indicate self-doubt, fear of failure, or anxiety about performance. It could also suggest a need to evaluate your goals and expectations.",
            "flying without control": "Dreaming of flying uncontrollably can represent feelings of instability or a lack of control in your waking life. It may suggest a need to regain control over a situation.",
            "mirrors": "Mirrors in dreams can symbolize self-reflection, self-perception, or a desire to understand oneself better. It may indicate a need for self-exploration.",
            "falling from a height": "Dreaming of falling from a height can symbolize insecurity, fear of failure, or a loss of status. It may suggest a need to address feelings of vulnerability.",
            "being lost": "Dreaming of being lost can reflect feelings of confusion, uncertainty, or a fear of losing direction in life. It may suggest a need to find your path or make decisions.",
            "animals": "Animals in dreams often have specific meanings. For example, a cat can represent independence, while a dog may symbolize loyalty. Consider the characteristics of the animal for interpretation.",
            "being unprepared": "Dreaming of being unprepared for an important event can suggest feelings of inadequacy or a fear of not being up to the task. It may indicate a need for better preparation.",
            // Add more dream meanings here
        ]
        
        var dreamAnalysis = ""
        let words = text.lowercased().split(separator: " ")
        
        for word in words {
            if let meaning = commonDreams[String(word)] {
                dreamAnalysis += "You dreamt about \(word). \(meaning) "
            }
        }
        
        if dreamAnalysis.isEmpty {
            dreamAnalysis = "No specific dream themes detected."
        }
        
        return dreamAnalysis
    }
}


struct DreamLibraryView: View {
    @ObservedObject var dreamManager: DreamManager

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Dream Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                    
                    List(dreamManager.dreams) { dream in
                        NavigationLink(destination: DreamDetailView(dream: dream, dreamManager: dreamManager)) {
                            VStack(alignment: .leading) {
                                Text(dream.text)
                                    .foregroundColor(.black) // Set text color to black
                                    .font(.headline)
                                
                                Text("Mood: \(dream.moodIndex)")
                                    .foregroundColor(.black) // Set text color to black
                                    .font(.subheadline)
                                
                                Text("Date: \(formattedDate(from: dream.id))")
                                    .foregroundColor(.black) // Set text color to black
                                    .font(.subheadline)
                            }
                        }
                    }
                    .foregroundColor(.white) // Set list text color to white
                    
                    NavigationLink(destination: WelcomeView(dreamManager: dreamManager)) {
                        Text("Back to Welcome")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.purple)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                            .padding(.top, 20)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    }
    
    func formattedDate(from uuid: UUID) -> String {
        let timestampBytes = uuid.uuid
        let timestamp = (UInt64(timestampBytes.0) << 56)
            | (UInt64(timestampBytes.1) << 48)
            | (UInt64(timestampBytes.2) << 40)
            | (UInt64(timestampBytes.3) << 32)
            | (UInt64(timestampBytes.4) << 24)
            | (UInt64(timestampBytes.5) << 16)
            | (UInt64(timestampBytes.6) << 8)
            | (UInt64(timestampBytes.7))
        
        let timestampInterval = TimeInterval(timestamp) / 10_000_000 - 978_307_200
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: Date(timeIntervalSince1970: timestampInterval))
}





extension UUID {
    var uuidDate: Date {
        var bytes = self.uuid
        let timestampBytes = withUnsafeBytes(of: &bytes.0) { Data($0) }
        let timestamp = timestampBytes.withUnsafeBytes { $0.load(as: UInt64.self) }
        let timestampInterval = TimeInterval(timestamp) / 10_000_000 - 978_307_200
        return Date(timeIntervalSince1970: timestampInterval)
    }
}

struct DreamDetailView: View {
    var dream: Dream
    @State private var drawing: Drawing = Drawing(points: [])
    @State private var selectedColor: Color = .black
    @State private var isDoodleViewPresented = false
    @ObservedObject var dreamManager: DreamManager

    var dreamIndex: Int {
        dreamManager.dreams.firstIndex(where: { $0.id == dream.id }) ?? 0
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Dream Detail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)

                Text("Dream Text:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(dream.text)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                Text("Mood:")
                    .font(.headline)
                    .foregroundColor(.white)
                if let moodEmoji = dream.moodEmoji {
                    Text(moodEmoji)
                        .font(.largeTitle)
                }

                if let doodleImage = dream.doodleImage { // Display doodle image if available
                    Image(uiImage: doodleImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 20)
                }

                Button(action: {
                    drawing = dream.doodleDrawing() ?? Drawing(points: [])
                    isDoodleViewPresented = true
                }) {
                    Text("View Doodle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.top, 20)

                NavigationLink(destination: AnalyzeDreamView(dream: dream)) {
                    Text("Analyze")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(Color.green)
                        .cornerRadius(20)
                }

            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isDoodleViewPresented, content: {
            DoodleView(isDoodleViewPresented: $isDoodleViewPresented, drawing: $drawing, selectedColor: $selectedColor)
        })
    }
}















struct AnalyzeDreamView: View {
    var dream: Dream
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Analyze Dream")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                
                Text("Dream Text:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(dream.text)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Text("Mood:")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecordDreamView: View {
    @State private var dreamText = ""
    @State private var selectedMoodIndex = 5 // Default mood index
    @ObservedObject var dreamManager: DreamManager
    @Binding var isPresented: Bool // Binding to control presentation
    @State private var drawing = Drawing(points: [])
    @State private var selectedColor: Color = .black
    @State private var isDoodleViewPresented = false

    var moods: [String] = ["😔", "😕", "😐", "🙂", "😀", "😃", "😄", "😁", "😆", "😇"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    NavigationLink(destination: WelcomeView(dreamManager: dreamManager)) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    .padding(.horizontal)

                    Text("Record Your Dream")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)

                    TextEditor(text: $dreamText)
                        .font(.body)
                        .frame(height: 100)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding()

                    Text("How was your mood waking up?")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 5)

                    Picker("Mood", selection: $selectedMoodIndex) {
                        ForEach(0..<moods.count, id: \.self) { index in
                            Text(self.moods[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 30)

                    ColorPicker("Select Color", selection: $selectedColor)
                        .padding(.horizontal)

                    Canvas(drawing: $drawing, selectedColor: $selectedColor)
                        .frame(width: 300, height: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 10)

                    HStack(spacing: 20) {
                        Button(action: {
                            let doodle = Drawing(points: drawing.points)
                            dreamManager.addDream(text: dreamText, moodIndex: selectedMoodIndex, doodleData: doodle) // Corrected argument label
                            isPresented = false // Dismiss the view
                        }) {
                            Text("Save Recording")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 40)
                                .background(Color.green)
                                .cornerRadius(20)
                        }


                        NavigationLink(destination: DreamLibraryView(dreamManager: dreamManager)) {
                            Text("Dream Library")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 40)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                    }

                }

                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}








struct Drawing: Shape, Codable {
    var points: [CGPoint]

    init(points: [CGPoint] = []) {
        self.points = points
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }

    func dataRepresentation() -> Data {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            return Data()
        }
    }

    static func fromData(data: Data) -> Drawing {
        let decoder = JSONDecoder()
        do {
            let drawing = try decoder.decode(Drawing.self, from: data)
            return drawing
        } catch {
            return Drawing(points: [])
        }
    }
}




struct DoodleView: View {
    @Binding var isDoodleViewPresented: Bool
    @Binding var drawing: Drawing
    @Binding var selectedColor: Color

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("View/Edit Doodle")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                
                ColorPicker("Select Color", selection: $selectedColor)
                    .padding(.horizontal)
                
                Canvas(drawing: $drawing, selectedColor: $selectedColor)
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Button(action: {
                    isDoodleViewPresented = false
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



  


struct Canvas: View {
    @Binding var drawing: Drawing
    @Binding var selectedColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            Drawing(points: drawing.points) // Use the Drawing shape here
                .stroke(selectedColor, lineWidth: 2)
                .background(Color.white)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged { value in
                            let currentPoint = value.location
                            if drawing.points.isEmpty {
                                drawing.points.append(currentPoint)
                            } else {
                                drawing.points.append(currentPoint)
                            }
                        }
                        .onEnded { _ in
                            drawing.points.append(.zero) // Append a point to signal the end of the stroke
                        }
                )
        }
    }
}




struct Line {
    let color: Color
    var points: [CGPoint]
    
    init(color: Color, points: [CGPoint]) {
        self.color = color
        self.points = points
    }
}




extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = UIColor.clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

