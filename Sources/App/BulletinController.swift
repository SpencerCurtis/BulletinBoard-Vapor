//
//  BulletinController.swift
//  App
//
//  Created by Spencer Curtis on 2/14/20.
//

import Foundation
import Vapor
import Plot

final class BulletinController: RouteCollection {
    
    enum Errors: Error {
        case notFound
    }
    
    func boot(router: Router) throws {
        
        router.get(use: mainPage)
        router.post("new", use: createBulletin)
        router.post(use: deleteBulletin)
    }
    
    func mainPage(_ req: Request) -> Future<HTML> {
        
        return Bulletin
            .query(on: req)
            .all()
            .flatMap { (bulletins) -> Future<HTML> in
                
                let bulletins = bulletins.sorted(by: { $0.timestamp > $1.timestamp })
                
                return req.future(BulletinBoardContexts.mainBulletinBoardPage(with: bulletins))
        }
    }
    
    func createBulletin(_ req: Request) throws -> Future<HTTPStatus>  {
        return try req.content.decode(Bulletin.self).flatMap({ (bulletin) -> Future<HTTPStatus> in
            return bulletin.save(on: req).transform(to: HTTPStatus.ok)
        })
    }
    
    func deleteBulletin(_ req: Request) throws -> Future<Response> {
        
        struct BulletinLookup: Content {
            let identifier: String
        }
        
        return try req.content
            .decode(BulletinLookup.self)
            .flatMap({ (lookup) -> EventLoopFuture<Response> in
                
                guard let identifier = UUID(uuidString: lookup.identifier) else { return req.future(req.redirect(to: "/")) }
                
                _ = Bulletin
                    .find(identifier, on: req)
                    .unwrap(or: Errors.notFound)
                    .delete(on: req)
                
                return req.future(req.redirect(to: "/"))
            }
        )
    }
}
