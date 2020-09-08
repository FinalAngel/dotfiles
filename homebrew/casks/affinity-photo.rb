cask "affinity-photo" do
  version "1.8.4"
  sha256 "a2c4023810409bfb3de58a9b68963f5b8b763e5aaa4b42aa429731a27b475853"
  url "https://store.serif.com/download/075b51/"
  app "Affinity Photo.app"
  zap trash: [
               "~/Library/Application Support/Affinity Photo",
               "~/Library/Caches/com.seriflabs.affinityphoto",
               "~/Library/Preferences/com.seriflabs.affinityphoto.plist",
             ]
end
