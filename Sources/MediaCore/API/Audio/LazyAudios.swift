//
//  LazyAudios.swift
//  MediaCore
//
//  Created by Christian Elies on 21.02.21.
//

import Photos

/// <#Description#>
public final class LazyAudios {
    private let result: PHFetchResult<PHAsset>

    /// <#Description#>
    public var count: Int { result.count }

    init(result: PHFetchResult<PHAsset>) {
        self.result = result
    }

    public subscript(index: Int) -> Audio? {
        guard index >= 0, index < result.count else {
            return nil
        }
        let asset = result.object(at: index)
        return .init(phAsset: asset)
    }
}

public extension LazyAudios {
    /// <#Description#>
    static var all: LazyAudios? = {
        // TODO:
        return nil
    }()
}
