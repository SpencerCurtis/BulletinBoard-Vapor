//
//  HTML+ResponseEncodable.swift
//  App
//
//  Created by Spencer Curtis on 2/12/20.
//

import Vapor
import Plot

/// Used to allow Plot-created HTML to be rendered using Leaf.
extension HTML: ResponseEncodable {
  public func encode(for req: Request) throws -> EventLoopFuture<Response> {
    let res = Response(http: .init(headers: ["content-type": "text/html; charset=utf-8"], body: self.render()), using: req.sharedContainer)
    return req.sharedContainer.eventLoop.newSucceededFuture(result: res)
  }
}
