cask "sonoss1" do
  version "12.1"
  sha256 "1a98300bd16bb2f727eb1921db80777cc23178a483d56b44a9bb5d95d9ea6602"
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
