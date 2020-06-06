cask "affinity-designer" do
  version "1.8.3"
  sha256 "881182faf9ad41eb1635cac5e7c1ce474e5a63b3f508380d9030848115fea7ba"
  url "https://store.serif.com/download/aa4dee/"
  app "Affinity Designer.app"
  zap trash: [
               "~/Library/Application Support/Affinity Designer",
               "~/Library/Caches/com.seriflabs.affinitydesigner",
               "~/Library/Preferences/com.seriflabs.affinitydesigner.plist",
             ]
end
