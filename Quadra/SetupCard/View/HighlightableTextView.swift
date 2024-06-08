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
    let palette = SettingsManager.shared.highliterPalette
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack() {
                UITextViewRepresentable(
                    text: $text,
                    pallete: palette,
                    calculatedHeight: $dynamicHeight)
                .padding(.leading, 16)
                .padding(.trailing, 32)
                .background(
                    Color.element
                        .shadow(.inner(color: .highlight, radius: 3, x: -3, y: -3))
                        .shadow(.inner(color: .shadow, radius: 3, x: 3, y: 3))
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
        }
    }
}

fileprivate struct UITextViewRepresentable: UIViewRepresentable {
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
    }
}

fileprivate class HighlightableUITextView: UITextView {
    var palette: HighlighterPalette
    
    init(palette: HighlighterPalette = .pale) {
        self.palette = palette
        super.init(frame: .zero, textContainer: nil)
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.autocorrectionType = .no
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
            #selector(UIResponderStandardEditActions.paste(_:)),
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
                handler: { [weak self] action in
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
                    if let delegate = self.delegate {
                        delegate.textViewDidChange?(self)
                    }
                })
        }
        
        let clearAction = UIAction(title: "Clear Formatting") { [weak self] action in
            guard
                let self = self,
                let range = self.nsRange(from: textRange)
            else { return }
            
            let updatedAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor.clear,
                .font: UIFont.systemFont(ofSize: 18)
            ]
            
            self.textStorage.beginEditing()
            self.textStorage.setAttributes(updatedAttributes, range: range)
            self.textStorage.endEditing()
            if let delegate = self.delegate {
                delegate.textViewDidChange?(self)
            }
        }
        
        actions += colorActions
        actions.append(clearAction)
        actions += suggestedActions
        
        return UIMenu(children: actions)
    }
}
