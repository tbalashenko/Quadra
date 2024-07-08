//
//  TextView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/04/2024.
//

import SwiftUI

struct HighlightableTextView: View {
    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = true
    @Binding var text: AttributedString
    var error: String
    let palette = SettingsService.highliterPalette
    var pasteButtonAction: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    UITextViewRepresentable(
                        text: $text,
                        pallete: palette,
                        calculatedHeight: $dynamicHeight
                    )
                    .padding(.leading, 16)
                    .padding(.trailing, 32)
                    .background(
                        Color.element
                            .shadow(.inner(color: .highlight, radius: 3, x: -3, y: -3))
                            .shadow(.inner(color: .shadow, radius: 3, x: 3, y: 3))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
                    .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
                    if !text.characters.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(NeuButtonStyle())
                        }
                        .padding(.horizontal, 4)
                        .zIndex(1)
                    }
                }
                PasteButton { pasteButtonAction?($0) }
            }
            ErrorView(error: error)
        }
    }
}

private struct UITextViewRepresentable: UIViewRepresentable {
    @Binding var text: AttributedString
    @Binding var calculatedHeight: CGFloat
    let textView = HighlightableUITextView()
    let pallete: HighlighterPalette

    init(text: Binding<AttributedString>, pallete: HighlighterPalette, calculatedHeight: Binding<CGFloat>) {
        self._text = text
        self._calculatedHeight = calculatedHeight
        textView.palette = pallete
        self.pallete = pallete
    }

    func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        textView.palette = pallete
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = NSAttributedString(text)
        UITextViewRepresentable.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: AttributedString
        @Binding var calculatedHeight: CGFloat

        init(text: Binding<AttributedString>, height: Binding<CGFloat>) {
            self._text = text
            self._calculatedHeight = height
        }

        func textViewDidChange(_ textView: UITextView) {
            _text.wrappedValue = AttributedString(textView.attributedText)
            UITextViewRepresentable.recalculateHeight(view: textView, result: $calculatedHeight)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            _text.wrappedValue = AttributedString(textView.attributedText)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }

            if let pasteboardString = UIPasteboard.general.string, text == pasteboardString {
                let plainText = NSMutableAttributedString(string: pasteboardString)
                let updatedAttributes: [NSAttributedString.Key: Any] = [
                    .backgroundColor: UIColor.clear,
                    .font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor.black
                ]

                let fullRange = NSRange(location: 0, length: plainText.length)
                plainText.addAttributes(updatedAttributes, range: fullRange)

                let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
                mutableAttributedText.replaceCharacters(in: range, with: plainText)
                textView.attributedText = mutableAttributedText

                _text.wrappedValue = AttributedString(plainText)
                UITextViewRepresentable.recalculateHeight(view: textView, result: $calculatedHeight)

                return false
            }
            return true
        }
    }
}

private class HighlightableUITextView: UITextView {
    var palette: HighlighterPalette

    init(palette: HighlighterPalette = .pale) {
        self.palette = palette
        super.init(frame: .zero, textContainer: nil)
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.autocorrectionType = .no
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.returnKeyType = .done
#warning("change when I will be doing something with font")
        self.font = .systemFont(ofSize: 18)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let actions: [Selector] = [
            #selector(UIResponderStandardEditActions.copy(_:)),
            #selector(UIResponderStandardEditActions.cut(_:)),
            #selector(UIResponderStandardEditActions.paste(_:))
        ]
        return actions.contains(action)
    }

    override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        var actions: [UIMenuElement] = []

        let colorActions = palette.colors.map { color in
            let conf = UIImage.SymbolConfiguration(paletteColors: [color])
                .applying(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))

            return UIAction(
                image: UIImage(named: "highlighter", in: nil, with: conf),
                handler: { [weak self] _ in
                    guard
                        let self = self,
                        let range = self.nsRange(from: textRange)
                    else { return }

                    let updatedAttributes: [NSAttributedString.Key: Any] = [
                        .backgroundColor: color,
                        .font: UIFont.systemFont(ofSize: 18)
                    ]

                    self.textStorage.beginEditing()
                    self.textStorage.setAttributes(updatedAttributes, range: range)
                    self.textStorage.endEditing()
                    if let delegate {
                        delegate.textViewDidChange?(self)
                    }
                })
        }

        let clearAction = UIAction(title: "Clear Formatting") { [weak self] _ in
            guard
                let self = self,
                let range = self.nsRange(from: textRange)
            else { return }

            let updatedAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor.clear,
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]

            self.textStorage.beginEditing()
            self.textStorage.setAttributes(updatedAttributes, range: range)
            self.textStorage.endEditing()
            if let delegate {
                delegate.textViewDidChange?(self)
            }
        }

        actions += colorActions
        actions.append(clearAction)
        actions += suggestedActions

        return UIMenu(children: actions)
    }
}
