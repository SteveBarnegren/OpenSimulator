#!/usr/bin/env swift

import Foundation

// MARK: - Shell Helper

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

// MARK: - Paths last modified sort

func lastModifiedSort(first: String, second: String) -> Bool{
    
    let firstAttributes = try! fileManager.attributesOfItem(atPath: first)
    let secondAttributes = try! fileManager.attributesOfItem(atPath: second)
    
    let firstModificationDate = firstAttributes[FileAttributeKey.modificationDate] as! Date
    let secondModificationDate = secondAttributes[FileAttributeKey.modificationDate] as! Date
    
    return firstModificationDate > secondModificationDate
}

func removeHiddenFilesFilter(path: String) -> Bool {
    return path.characters.first! != "."
}

// MARK: - Main

let fileManager = FileManager.default

// Get the Simulator devices directory
let homeDirectory = NSHomeDirectory()
let devicesDirectory = "\(homeDirectory)/Library/Developer/CoreSimulator/Devices"

// Get paths to all devices
guard let devicePaths = try? fileManager.contentsOfDirectory(atPath: devicesDirectory) else {
    fatalError("No devices")
}

// Get the most recently modified device
let lastModifiedDevice = devicePaths.filter(removeHiddenFilesFilter)
    .map{ "\(devicesDirectory)/\($0)" }
    .sorted(by: lastModifiedSort).first!

// Get the the applications data folder
let applicationsDataDirectory = "\(lastModifiedDevice)/data/Containers/Data/Application"

// Get the most recently modified application
guard let applicationPaths = try? fileManager.contentsOfDirectory(atPath: applicationsDataDirectory) else {
    fatalError("No applications")
}

// Get the last modified applications
let lastModifiedApplication = applicationPaths.filter(removeHiddenFilesFilter)
    .map{ "\(applicationsDataDirectory)/\($0)" }
    .sorted(by: lastModifiedSort).first!

// open in finder
shell("open", "\(lastModifiedApplication)")
