cask "beook" do
  version "6.4.0"
  sha256 "432770463fcf026fb43f74eb6a4c1b05a742342ab9ed6782581dfc318c2788c6"
  url "https://beook.ch/downloads/setup/mac64/beook_mac64_install_#{version}.dmg"
  app "beook.app"
  zap trash: [
               "~/Library/Preferences/beook.plist",
             ]
end
