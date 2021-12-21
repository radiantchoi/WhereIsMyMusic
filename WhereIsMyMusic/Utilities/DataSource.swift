//
//  DataSource.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/19.
//

import Foundation

struct DataSource<S: Equatable, I: Equatable> {
    var sections = [(section: S, items: [I])]()
    
    init(_ sections: (S, [I])...) {
        self.sections = sections
    }
}

extension DataSource {
    mutating func appendSection(_ section: S, with items: [I]) {
        sections.append((section, items))
    }
    
    mutating func removeAllSections() {
        sections.removeAll()
    }
    
    mutating func append(_ itemsToAppend: [I], in section: S) {
        guard let index = sections.firstIndex(where: { $0.section == section })
        else { return }
        
        var items = sections[index].items
        itemsToAppend.forEach {
            items.append($0)
        }
        sections[index].items = items
    }
    
    mutating func insert(_ item: I, in section: S, at index: Int) {
        guard let sectionIndex = sections.firstIndex(where: { $0.section == section })
        else { return }
        
        var items = sections[sectionIndex].items
        items.insert(item, at: index)
        sections[sectionIndex].items = items
    }
    
    mutating func removeAll(item: I) {
        sections.enumerated().forEach { (index, section) in
            var items = section.items
            items.removeAll(where: { $0 == item })
            sections[index].items = items
        }
    }
    
    mutating func removeAllItems(in section: S) {
        guard let sectionIndex = sections.firstIndex(where: { $0.section == section })
        else { return }
        
        sections[sectionIndex].items.removeAll()
    }
}

extension DataSource {
    func indexPath(for item: I, in section: S? = nil) -> IndexPath? {
        for (sectionIndex, aSection) in sections.enumerated() {
            for (itemIndex, anItem) in aSection.items.enumerated() where anItem == item {
                if let section = section,
                   section != aSection.section {
                    continue
                }
                return IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    func sectionIndex(of section: S) -> Int? {
        for (index, aSection) in sections.enumerated() where section == aSection.section {
            return index
        }
        return nil
    }
}

extension DataSource {
    var numberOfSections: Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return sections[section].items.count
    }
}

extension DataSource {
    func section(for index: Int) -> S {
        return sections[index].section
    }
    
    func item(for indexPath: IndexPath) -> I {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    func items(of section: S) -> [I]? {
        return sections.first(where: { $0.section == section })?.items
    }
}
