//
//  Tag+CoreDataProperties.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var idea: NSSet?
    @NSManaged public var tag : NSSet?
    @NSManaged public var choice: Bool
    @NSManaged public var issub : Bool
    
    
    public var wrappedName : String {
        text ?? "No Name"
    }
    
    public var ideaArray : [Idea] {
        let set = idea as? Set<Idea> ?? []
        return set.sorted {
            $0.wrappedtitle < $1.wrappedtitle
        }
    }
    
    public var tagArray : [Tag] {
        let set = tag as? Set<Tag> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for idea
extension Tag {

    @objc(addIdeaObject:)
    @NSManaged public func addToIdea(_ value: Idea)

    @objc(removeIdeaObject:)
    @NSManaged public func removeFromIdea(_ value: Idea)

    @objc(addIdea:)
    @NSManaged public func addToIdea(_ values: NSSet)

    @objc(removeIdea:)
    @NSManaged public func removeFromIdea(_ values: NSSet)

}

extension Tag : Identifiable {

}
