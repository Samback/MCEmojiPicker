//
//  File.swift
//  
//
//  Created by Max Tymchii on 03.11.2023.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct EmojiViewControllerRepresentable: UIViewControllerRepresentable {

    // MARK: - Public Properties

    /// Observed value which is updated by the selected emoji.
    @Binding var selectedEmoji: String

    ///
    /// The default value of this property is `nil`.
    public var customHeight: CGFloat?

    /// Inset from the sourceView border.
    ///
    /// The default value of this property is `0`.
    public var horizontalInset: CGFloat?


    /// Color for the selected emoji category.
    ///
    /// The default value of this property is `.systemBlue`.
    public var selectedEmojiCategoryTintColor: UIColor?

    /// Feedback generator style. To turn off, set `nil` to this parameter.
    ///
    /// The default value of this property is `.light`.
    public var feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle?

    // MARK: - Initializers

    public init(
        selectedEmoji: Binding<String>,
        customHeight: CGFloat? = nil,
        horizontalInset: CGFloat? = nil,
        selectedEmojiCategoryTintColor: UIColor? = nil,
        feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil
    ) {
        self._selectedEmoji = selectedEmoji
        self.customHeight = customHeight
        self.horizontalInset = horizontalInset
        self.selectedEmojiCategoryTintColor = selectedEmojiCategoryTintColor
        self.feedBackGeneratorStyle = feedBackGeneratorStyle
    }

    // MARK: - Public Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> EmojiViewController {
        return EmojiViewController()
    }

    public func updateUIViewController(_ representableController: EmojiViewController, context: Context) {
        guard !context.coordinator.isNewEmojiSet else {
            context.coordinator.isNewEmojiSet.toggle()
            return
        }
        
        representableController.delegate = context.coordinator
        if let customHeight { representableController.customHeight = customHeight }
        if let horizontalInset { representableController.horizontalInset = horizontalInset }
        if let selectedEmojiCategoryTintColor {
            representableController.selectedEmojiCategoryTintColor = selectedEmojiCategoryTintColor
        }
        if let feedBackGeneratorStyle { representableController.feedBackGeneratorStyle = feedBackGeneratorStyle }
    }
}

// MARK: - Coordinator

@available(iOS 13.0, *)
extension EmojiViewControllerRepresentable {
    public class Coordinator: NSObject, MCEmojiPickerDelegate {

        public var isNewEmojiSet = false

        private var representableController: EmojiViewControllerRepresentable

        init(_ representableController: EmojiViewControllerRepresentable) {
            self.representableController = representableController
        }

        public func didGetEmoji(emoji: String) {
            isNewEmojiSet.toggle()
            representableController.selectedEmoji = emoji
        }

    }
}
