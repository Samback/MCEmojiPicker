//
//  EmojiView.swift
//  iOS Example App
//
//  Created by Max Tymchii on 03.11.2023.
//

import SwiftUI
import MCEmojiPicker

@available(iOS 14.0, *)
struct EmojiView: View {
    @State var selectedEmoji = "🙋🏻‍♂️"

    var body: some View {
        VStack {
            EmojiViewControllerRepresentable( selectedEmoji: $selectedEmoji)
                .onChange(of: selectedEmoji, perform: { value in
                    print("New value \(value)")
                })
        }
    }

}


@available(iOS 14.0, *)
#Preview {
        EmojiView()
}
