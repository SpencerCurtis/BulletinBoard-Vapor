//
//  BulletinBoardContexts.swift
//  App
//
//  Created by Spencer Curtis on 2/12/20.
//

import Foundation
import Plot
import Vapor

typealias BodyContext = Plot.Node<HTML.BodyContext>
typealias HeadContext = Plot.Node<HTML.HeadContext>

final class BulletinBoardContexts {
    
    static let dateFormatter: DateFormatter = {
        
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    static func fullPageWith(title: String, uniqueHeadContent: [HeadContext] = [], uniquePageContent: [BodyContext]) -> HTML {
        
        return HTML(
            .head(
                .title(title),
                .forEach(uniqueHeadContent, { $0 }),
                .stylesheet("reset.css"),
                .stylesheet("styling.css"),
                .stylesheet("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")
                //                          .stylesheet("https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"),
            ),
            .body(.forEach(uniquePageContent) { $0 })
        )
    }
    
    
    static func mainBulletinBoardPage(with bulletins: [Bulletin]) -> HTML {
        
        return fullPageWith(title: "Lambda Bulletin Board", uniquePageContent: [
            .nav(
                .class("navigation"),
                .h1(
                    .class("headerText"),
                    .text("Lambda Bulletin Board")
                )
            ),
            .main(
                .table(
                    .tr(
                        .class("tableHeader"),
                        .th(.h1("Bulletin")),
                        .th(.h1("Poster")),
                        .th(.h1("Post Date")),
                        .th()
                    ),
                    .forEach(bulletins) {
                        .tr(
                            .td(.text($0.content)),
                            .td(.text($0.poster)),
                            .td(.text(dateFormatter.string(from: $0.timestamp))),
                            .td(deleteButton(for: $0))
                        )
                    }
                )
            )
        ])
    }
    
    static func deleteButton(for bulletin: Bulletin) -> BodyContext {
        .form(
            .action("/"),
            .attribute(named: "method", value: "post"),
            .button(
                .id("identifier"),
                .name("identifier"),
                .value(bulletin.id?.uuidString ?? ""),
                .attribute(named: "type", value: "submit"),
                .class("btn"),
                .i(.class("fa fa-trash"))
            )
        )
    }
}

extension Node where Context: HTML.BodyContext {
    
    //    static func someHTML() -> Self {
    //        return .
    //    }
    
}
