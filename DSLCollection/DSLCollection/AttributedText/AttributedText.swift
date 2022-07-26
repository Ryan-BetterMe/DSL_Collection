//
//  AttributedString.swift
//  DSLCollection
//
//  Created by Ryan on 2022/7/26.
//

import Foundation
import UIKit

typealias Font = UIFont
typealias Color = UIColor
typealias Attributes = [NSAttributedString.Key: Any]
typealias AText = AttributedText

protocol TextComponent {
    var string: String { get }
    var attributes: Attributes { get }
    var attributedText: NSAttributedString { get }
}

extension TextComponent {
    var attributedText: NSAttributedString {
        return NSAttributedString.init(string: string, attributes: attributes)
    }
}

struct AttributedText: TextComponent {
    var string: String
    var attributes: Attributes
    
    init(_ text: String, _ attributes: Attributes = [:]) {
        self.string = text
        self.attributes = attributes
    }
}



@resultBuilder
enum AttributedTextBuilder {
    static func buildBlock(_ components: [TextComponent]...) -> [TextComponent] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [TextComponent]?) -> [TextComponent] {
        return component ?? []
    }
    
    static func buildEither(first component: [TextComponent]) -> [TextComponent] {
        return component
    }
    
    static func buildEither(second component: [TextComponent]) -> [TextComponent] {
        return component
    }
    
    static func buildExpression(_ expression: TextComponent) -> [TextComponent] {
        return [expression]
    }
    
    static func buildArray(_ components: [[TextComponent]]) -> [TextComponent] {
        return components.flatMap { $0 }
    }
    
    static func buildLimitedAvailability(_ component: [TextComponent]) -> [TextComponent] {
        return component
    }
    
    static func buildFinalResult(_ component: [TextComponent]) -> NSAttributedString {
        let mas = NSMutableAttributedString(string: "")
        component.forEach {
            mas.append($0.attributedText)
        }
        return mas
    }
}

extension NSAttributedString {
    convenience init(@AttributedTextBuilder _ builder: () -> NSAttributedString) {
        self.init(attributedString: builder())
    }
}

// 扩充基本的富文本方法
enum Ligature: Int {
    case none = 0
    case `default` = 1
}

extension TextComponent {
    private func addAttribute(_ attribute: [NSAttributedString.Key: Any]) -> TextComponent {
        var newAttributes = self.attributes
        for (key, value) in attribute {
            newAttributes[key] = value
        }
        return AttributedText(string, newAttributes)
    }
    
    func backgroundColor(_ color: Color) -> TextComponent {
        addAttribute([.backgroundColor: color])
    }
    
    func foregroundColor(_ color: Color) -> TextComponent {
        addAttribute([.foregroundColor: color])
    }
    
    func font(_ font: Font) -> TextComponent {
        addAttribute([.font: font])
    }
    
    func baselineOffset(_ baselineOffset: CGFloat) -> TextComponent {
        addAttribute([.baselineOffset: baselineOffset])
    }
    
    func expansion(_ expansion: CGFloat) -> TextComponent {
        addAttribute([.expansion: expansion])
    }
    
    func kerning(_ kern: CGFloat) -> TextComponent {
        addAttribute([.kern: kern])
    }
    
    func ligature(_ ligature: Ligature) -> TextComponent {
        addAttribute([.ligature: ligature.rawValue])
    }
    
    func obliquness(_ obliqueness: Float) -> TextComponent {
        addAttribute([.obliqueness: obliqueness])
    }
    
    func shadow(color: Color? = nil, radius: CGFloat, x: CGFloat, y: CGFloat) -> TextComponent {
        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowBlurRadius = radius
        shadow.shadowOffset = .init(width: x, height: y)
        return addAttribute([.shadow: shadow])
    }
    
    func strikethrough(style: NSUnderlineStyle, color: Color? = nil) -> TextComponent {
        if let color = color {
            return addAttribute([.strikethroughStyle: style.rawValue,
                               .strikethroughColor: color])
        } else {
            return addAttribute([.strikethroughStyle: style.rawValue])
        }
    }
    
    func stroke(width: CGFloat, color: Color? = nil) -> TextComponent {
        if let color = color {
            return addAttribute([.strokeWidth: width,
                               .strokeColor: color])
        } else {
            return addAttribute([.strokeWidth: width])
        }
    }
    
    func underline(_ style: NSUnderlineStyle, color: Color? = nil) -> TextComponent {
        if let color = color {
            return addAttribute([.underlineStyle: style.rawValue,
                               .underlineColor: color])
        } else {
            return addAttribute([.underlineStyle: style.rawValue])
        }
    }

    func writingDirection(_ writingDirection: NSWritingDirection) -> TextComponent {
        addAttribute([.writingDirection: writingDirection.rawValue])
    }
}

extension TextComponent {
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> TextComponent {
        addAttribute([.paragraphStyle: paragraphStyle])
    }

    func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> TextComponent {
        addAttribute([.paragraphStyle: paragraphStyle])
    }

    private func getMutableParagraphStyle() -> NSMutableParagraphStyle {
        if let mps = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            return mps
        } else if let ps = attributes[.paragraphStyle] as? NSParagraphStyle,
                  let mps = ps.mutableCopy() as? NSMutableParagraphStyle
        {
            return mps
        } else {
            return NSMutableParagraphStyle()
        }
    }

    func alignment(_ alignment: NSTextAlignment) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return self.paragraphStyle(paragraphStyle)
    }

    func firstLineHeadIndent(_ indent: CGFloat) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func headIndent(_ indent: CGFloat) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.headIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func tailIndent(_ indent: CGFloat) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.tailIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func lineBreakeMode(_ lineBreakMode: NSLineBreakMode) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return self.paragraphStyle(paragraphStyle)
    }

    func  lineHeight(multiple: CGFloat = 0, maximum: CGFloat = 0, minimum: CGFloat) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = multiple
        paragraphStyle.maximumLineHeight = maximum
        paragraphStyle.minimumLineHeight = minimum
        return self.paragraphStyle(paragraphStyle)
    }

    func lineSpacing(_ spacing: CGFloat) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        return self.paragraphStyle(paragraphStyle)
    }

    func paragraphSpacing(_ spacing: CGFloat, before: CGFloat = 0) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        paragraphStyle.paragraphSpacingBefore = before
        return self.paragraphStyle(paragraphStyle)
    }

    func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.baseWritingDirection = baseWritingDirection
        return self.paragraphStyle(paragraphStyle)
    }

    func hyphenationFactor(_ hyphenationFactor: Float) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = hyphenationFactor
        return self.paragraphStyle(paragraphStyle)
    }

    @available(iOS 9.0, tvOS 9.0, watchOS 2.0, OSX 10.11, *)
    func allowsDefaultTighteningForTruncation() -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        return self.paragraphStyle(paragraphStyle)
    }

    func tabsStops(_ tabStops: [NSTextTab], defaultInterval: CGFloat = 0) -> TextComponent {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.tabStops = tabStops
        paragraphStyle.defaultTabInterval = defaultInterval
        return self.paragraphStyle(paragraphStyle)
    }
}

struct LinkText: TextComponent {
    var string: String
    var attributes: Attributes
    let url: URL
    
    init(_ string: String, url: URL, attributes: Attributes = [:]) {
        self.string = string
        self.url = url
        self.attributes = attributes
        self.attributes[.link] = url
    }
    
    var attributedText: NSAttributedString {
        NSAttributedString(string: string, attributes: attributes)
    }
}

struct ImageText: TextComponent {
    var string: String = ""
    var attributes: Attributes = [:]
    fileprivate let attachment: NSTextAttachment
    
    init(_ image: UIImage, _ bounds: CGRect? = nil) {
        let attachment = NSTextAttachment()
        attachment.image = image
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        self.attachment = attachment
    }
    
    var attributedText: NSAttributedString {
        NSAttributedString(attachment: attachment)
    }
}

extension TextComponent where Self == ImageText {
    func bounds(_ bounds: CGRect) -> TextComponent {
        return ImageText.init(self.attachment.image!, bounds)
    }
}

