//
//  BaseModel.swift
//  Heuristics
//
//  Created by Ahmed on 8/23/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

internal class Channel {
    internal let id: String
    internal let name: String
    internal var lastMessage: String
    internal let date: String
    internal let image:String
    internal var have_unread:Bool?
  
    init(id: String, name: String, image:String,date:String,lastMessage:String,have_unread:Bool? = false) {
        self.id = id
        self.name = name
        self.image = image
        self.lastMessage = lastMessage
        self.date = date
        self.have_unread = have_unread
  }
}
