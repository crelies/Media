//
//  PHFetchOptions.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

extension PHFetchOptions {
    func predicate(_ predicate: NSPredicate) -> Self {
        self.predicate = predicate
        return self
    }

    func fetchLimit(_ fetchLimit: Int) -> Self {
        self.fetchLimit = fetchLimit
        return self
    }

    func sortDescriptors(_ sortDescriptors: [NSSortDescriptor]) -> Self {
        self.sortDescriptors = sortDescriptors
        return self
    }
}
