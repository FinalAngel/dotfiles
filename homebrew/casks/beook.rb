cask "beook" do
  version "6.4.4"
  sha256 "733f29375253caaf44d406ce617d1bc6ba99dea29717ab3af7aed5dbde1ba953"
  url "https://beook.ch/downloads/setup/mac64/beook_mac64_install_#{version}.pkg"
  app "beook.app"
  zap trash: [
               "~/Library/Preferences/beook.plist",
             ]
end
