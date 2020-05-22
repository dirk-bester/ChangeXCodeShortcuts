//
//  ContentView.swift
//  ChangeXCodeShortcuts
//
//  Created by Dirk Bester on 4/30/20.
//  Released under the Do what the Fuck You Want to Public License.
//
/*
All kinds of snippets from stackoverflow like this:
 https://stackoverflow.com/questions/10266170/xcode-duplicate-line?noredirect=1&lq=1
but like curated to not screw the copy buffer as of XCode 11, and select the result so you can multi-paste, just like Corbin Dallas will have had a multi-pass.

 As well as the horrendous suffering involved in getting a damn GUI password prompt to set simple file permissions:
 https://apple.stackexchange.com/questions/23494/what-option-should-i-give-the-sudo-command-to-have-the-password-asked-through-a

 Special thanks to the XCode team for being dicks about line duplication and custom key bindings.
*/

import SwiftUI
import Foundation

struct ContentView: View {
	@State var shortcutText: String = """
			Custom (a dictionary)
			Duplicate Lines (A String entry)
			selectParagraph:, delete:, undo:, moveRight:, yankAndSelect:
			"""
    var body: some View {
		VStack {
			Button(action: {
				let _ = shell("""
					pw="$(osascript -e 'Tell application "System Events" to display dialog "Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)" && /
					echo "$pw" | sudo -S chmod 666 /Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/IDETextKeyBindingSet.plist
					echo "$pw" | sudo -S chmod 777 /Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/
					""")
			}) {
				Text("Edit Custom Shortcuts")
			}
			Button(action: {
				let _ = shell("""
					open -a Xcode.app /Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/IDETextKeyBindingSet.plist
					""")
			}) {
				Text("Open IDETextKeyBindingSet.plist")
			}
			TextField("""
			Duplicate Lines
			selectParagraph:, delete:, undo:, moveRight:, yankAndSelect:
			""", text: $shortcutText)
			Button(action: {
				let _ = shell("""
					pw="$(osascript -e 'Tell application "System Events" to display dialog "Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)" && /
					echo "$pw" | sudo -S chmod 644 /Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/IDETextKeyBindingSet.plist
					echo "$pw" | sudo -S chmod 755 /Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/
					""")
			}) {
				Text("Fix Permissions Afterwards")
			}
		}
		.padding()
		.background(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@discardableResult func shell(_ command: String) -> String {
	let task = Process()
	task.launchPath = "/bin/zsh"
	task.arguments = ["-c", command]

	let pipe = Pipe()
	task.standardOutput = pipe
	task.launch()

	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

	return output
}

