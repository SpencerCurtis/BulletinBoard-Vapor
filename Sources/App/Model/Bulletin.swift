//
//  Bulletin.swift
//  App
//
//  Created by Spencer Curtis on 2/12/20.
//

import Vapor
import FluentSQLite

final class Bulletin: Content, SQLiteUUIDModel, Migration {
    
    var id: UUID?
    var content: String
    let poster: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case poster
        case timestamp
    }
    
    init(id: UUID? = nil, content: String, poster: String, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.poster = poster
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decodeIfPresent(UUID.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
        self.poster = try container.decode(String.self, forKey: .poster)
        
        let timestamp = try? container.decodeIfPresent(Date.self, forKey: .timestamp)
        self.timestamp = timestamp ?? Date()
    }
    
    
}
