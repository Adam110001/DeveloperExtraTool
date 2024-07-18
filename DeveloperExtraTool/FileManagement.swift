//
//  FileManagement.swift
//  DeveloperExtraTool
//
//  Created by Adam Dovciak on 18/07/2024.
//

import Foundation

struct LibPath: Identifiable,Hashable {
    let id = UUID()
    let name: String
    let fullPath: String
    var extandPath:Bool = false
}

struct SysPath: Identifiable,Hashable {
    let id = UUID()
    let name: String
    let fullPath: String
    var extandPath:Bool = false
}

class FileEnvirnonment: Observable,ObservableObject {
    @Published var files:([LibPath], [SysPath]) = ([],[])
    @Published var searchText: String = ""
    
    var filteredLibDir: [LibPath] {
        if self.searchText.isEmpty {
            return files.0
        } else {
            return files.0.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var filteredSystemDir: [SysPath] {
        if self.searchText.isEmpty {
            return files.1
        } else {
            return files.1.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

class FileManagement {
    public func getFrameworksFromRootDirs() throws -> ([LibPath], [SysPath]) {
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        isDirectory[0] = true
        
        defer { isDirectory.initialize(to: false) }
        
        guard FileManager.default.fileExists(atPath: "/Library/Frameworks", isDirectory: isDirectory) else {
            return ([],[])
        }
        guard FileManager.default.fileExists(atPath: "/System/Library/Frameworks", isDirectory: isDirectory) else {
            return ([],[])
        }
        guard FileManager.default.fileExists(atPath: "/System/Library/PrivateFrameworks", isDirectory: isDirectory) else {
            return ([],[])
        }
        
        let libFrameworks:[String] = try FileManager.default.contentsOfDirectory(atPath: "/Library/Frameworks"),
            sysLibFrameworks:[String] = try FileManager.default.contentsOfDirectory(atPath: "/System/Library/Frameworks"),
            sysLibPrivFrameworks:[String] = try FileManager.default.contentsOfDirectory(atPath: "/System/Library/PrivateFrameworks")
        
        let libraryFrameworks:[LibPath] = libFrameworks.compactMap({ return LibPath(name: $0, fullPath: "/Library/Frameworks/" + $0) })
        let sysLibraryFrameworks:[SysPath] = sysLibFrameworks.compactMap({ return SysPath(name: $0, fullPath: "/System/Library/Frameworks/" + $0) }) + sysLibPrivFrameworks.compactMap({ return SysPath(name: $0, fullPath: "/System/Library/Frameworks/" + $0) })
        
        return (libraryFrameworks,sysLibraryFrameworks)
    }
}
