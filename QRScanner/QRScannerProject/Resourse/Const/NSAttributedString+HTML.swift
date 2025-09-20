//
//  NSAttributedString+HTML.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension NSAttributedString {
    
    static func parse(html: String, font: UIFont, fontWeight: CGFloat) -> NSAttributedString? {
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize
        if
            let data = "<span style=\"font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)px; font-weight: \(fontWeight)\">\(html)</span>"
                .data(using: .utf8) {
            return try? NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                           documentAttributes: nil)
        }
        return nil
    }
    
    static func parse(html: String, font: UIFont) -> NSAttributedString? {
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize
        if
            let data = "<span style=\"font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)\">\(html)</span>"
                .data(using: .utf8) {
            return try? NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                           documentAttributes: nil)
        }
        return nil
    }
    
    static func parse(font: UIFont) -> NSAttributedString? {
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize
        if
            let data = "<span style=\"font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)\"></span>"
                .data(using: .utf8) {
            return try? NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                           documentAttributes: nil)
        }
        return nil
    }
    
}


extension String {
    static func parse(html: String, font: UIFont, fontWeight: CGFloat) -> String? {
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize

        let htmlTemplate = """
        <span style="font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)px; font-weight: \(fontWeight);">
        \(html)
        </span>
        """

        if let data = htmlTemplate.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(data: data,
                                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                                              documentAttributes: nil) {
                return attributedString.string
            }
        }
        return nil
    }
}

extension String {
    static func parse(html: String) -> String? {
        // Convert the HTML string to Data
        if let data = html.data(using: .utf8) {
            // Try to create an NSAttributedString from the HTML data
            if let attributedString = try? NSAttributedString(data: data,
                                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                                              documentAttributes: nil) {
                // Return the plain string
                return attributedString.string
            }
        }
        return nil
    }
}
