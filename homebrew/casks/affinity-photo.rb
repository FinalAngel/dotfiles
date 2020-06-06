cask "affinity-photo" do
  version "1.8.3"
  sha256 "7a9f8af6742b947fbc15e3ed83cc470fccdd455372aeec1fe4a15591153d224f"
  url "https://store.serif.com/download/075b51/"
  app "Affinity Photo.app"
  zap trash: [
               "~/Library/Application Support/Affinity Photo",
               "~/Library/Caches/com.seriflabs.affinityphoto",
               "~/Library/Preferences/com.seriflabs.affinityphoto.plist",
             ]
end
