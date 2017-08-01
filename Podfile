platform :ios, '10.0'

target 'Bangers and Mash' do
  use_frameworks!

  pod "FontAwesome.swift"
  pod "SwiftyCam", git: "https://github.com/brjennin/SwiftyCam.git", commit: "627ddfa6d830148cf9f2ad8253ed23a3701f890b"

  target 'Bangers and MashTests' do
    inherit! :search_paths

    pod "Quick"
    pod "Nimble"
    pod "Fleet"
  end

  target 'Bangers and MashUITests' do
    inherit! :search_paths

    pod "Nimble"
  end
end
