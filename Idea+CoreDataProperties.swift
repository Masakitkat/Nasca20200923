//
//  Idea+CoreDataProperties.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//
//

import Foundation
import CoreData


extension Idea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Idea> {
        return NSFetchRequest<Idea>(entityName: "Idea")
    }

    @NSManaged public var date: Date?
    @NSManaged public var eval1: Int16
    @NSManaged public var eval2: Int16
    @NSManaged public var eval3: Int16
    @NSManaged public var eval1_text: String
    @NSManaged public var eval2_text: String
    @NSManaged public var eval3_text: String
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var tag: NSSet?

    public var wrappedtitle : String {
        title ?? "No title"
    }
    
    public var tagArray : [Tag] {
        let set = tag as? Set<Tag> ?? []
        
        return set.sorted {
            $0.wrappedName > $1.wrappedName
        }
    }
    
}

// MARK: Generated accessors for tag
extension Idea {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}

extension Idea : Identifiable {

}
