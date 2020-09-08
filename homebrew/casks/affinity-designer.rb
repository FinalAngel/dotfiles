cask "affinity-designer" do
  version "1.8.4"
  sha256 "be5a3f58dfb69eaba73ef7897970dd7e91dc880c6da8025f1e4d64f3ab6db718"
  url "https://store.serif.com/download/aa4dee/"
  app "Affinity Designer.app"
  zap trash: [
               "~/Library/Application Support/Affinity Designer",
               "~/Library/Caches/com.seriflabs.affinitydesigner",
               "~/Library/Preferences/com.seriflabs.affinitydesigner.plist",
             ]
end
