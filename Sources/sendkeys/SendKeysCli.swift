//
//  File.swift
//  
//
//  Created by Soc Sieng on 12/28/20.
//

import ArgumentParser

struct SendKeysCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Command line tool to script up sending keystrokes and mouse actions"
        // subcommands: [Generate.self]
    )

    init() { }
}
