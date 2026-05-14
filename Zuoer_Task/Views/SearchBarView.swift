//
//  SearchBarView.swift
//  Zuoer_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @StateObject private var speech = SpeechRecognizer()
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused || !text.isEmpty ? .primary : Color(.tertiaryLabel))
                .font(.system(size: 16))

            TextField("Search", text: $text)
                .focused($isFocused)
                .font(.system(size: 16))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                    speech.stop()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.tertiaryLabel))
                        .font(.system(size: 16))
                }
            }

//            Divider()
//                .frame(height: 20)

            Button {
                isFocused = false
                speech.toggleListening { result in
                    text = result
                }
            } label: {
                Image(systemName: speech.isListening ? "waveform" : "mic")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(speech.isListening ? .red : .primary)
                    .scaleEffect(speech.isListening ? 1.15 : 1.0)
                    .opacity(speech.isListening ? 0.7 : 1.0)
                    .animation(
                        speech.isListening
                            ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                            : .default,
                        value: speech.isListening
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.accentColor : Color(.separator), lineWidth: isFocused ? 1.5 : 1)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
        .background(Color(.systemGroupedBackground))
}
