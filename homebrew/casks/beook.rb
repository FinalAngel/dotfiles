cask "beook" do
  version "6.4.4"
  sha256 "d643c5e9c2734497eeb3c863347bbbe7558d6ea41292509e0560f5f82f42d884"
  url "https://beook.ch/downloads/setup/mac64/beook_mac64_install_#{version}.dmg"
  app "beook.app"
  zap trash: [
               "~/Library/Preferences/beook.plist",
             ]
end
