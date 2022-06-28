//
//  ContentView.swift
//  pomodoro
//
//  Created by Alan Chiem on 6/7/22.
//

import SwiftUI
import AVKit



let defaultTimeRemaining: CGFloat = 10//1800
let breakTime: CGFloat = 3//300
let lineWidth: CGFloat = 7
let radius: CGFloat = 150

// adding comment to test commit again 41
let breakColor: Color = Color.init(red: 249/255, green: 235/255, blue: 122/255)
let workColor: Color = Color.init(red: 101/255, green: 252/255, blue: 244/255)
let buttonColor: Color = Color.init(red: 1, green: 1, blue: 1)



class SoundManager {
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "bell", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player?.play()
        } catch let error {
            print("Error with sound .\(error.localizedDescription)")
        }
        
            
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    
    @State private var isActive = false
    @State private var timeRemaining: CGFloat = defaultTimeRemaining
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
                    Color.black.ignoresSafeArea() // 1
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .stroke(timeRemaining > breakTime ? Color.black : breakColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: ((defaultTimeRemaining - timeRemaining) / defaultTimeRemaining))
                    // change color 22:50
                    .stroke(timeRemaining > breakTime ? workColor : Color.black, style: StrokeStyle(lineWidth: timeRemaining > breakTime ? lineWidth : lineWidth + 1, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)


               
            }.frame(width: radius * 2, height: radius * 2, alignment: .center)
                
        
            HStack(spacing: 25){
                Label("Pause/Play", systemImage: "\(isActive ? "pause.fill" : "play.fill")")
                    .foregroundColor(buttonColor)
                    .onTapGesture(perform: {isActive.toggle()})
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(alignment: .center)

                Label("Reset", systemImage: "backward.fill")
                    .foregroundColor(buttonColor)
                    .onTapGesture(perform: {isActive = false
                    timeRemaining = defaultTimeRemaining})
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(alignment: .center)
                
            }.frame(alignment: .center)
        }
        .onReceive(timer, perform: { _ in guard isActive else {return}
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timeRemaining = defaultTimeRemaining
                
            }
//            if breakTime == timeRemaining || timeRemaining == 0 {
//                SoundManager.instance.playSound()
//            }
            
        })
        }
        .statusBar(hidden: true)


    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
        }
    }
}
