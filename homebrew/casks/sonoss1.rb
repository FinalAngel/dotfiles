cask "sonoss1" do
  version "11.2"
  sha256 "ca9d7cdbc8d60970cd4933cbdff3c7600acaa905dc38d131777cef26bdd6eef8"
  url "https://www.sonos.com/redir/controller_software_mac"
  app "Sonos S1 Controller.app"
  zap trash: [
               "~/Library/Caches/com.sonos.macController",
               "~/Library/Application Support/com.sonos.macController",
               "~/Library/Preferences/com.sonos.macController.plist",
               "~/private/var/folders/k_/xc02q9bj5s5f5kcyy7jv39kh0000gn/C/com.sonos.macController",
               "~/Library/Logs/Sonos S1 Controller",
             ]
end
