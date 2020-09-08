cask "meta" do
  version "1.9.6"
  sha256 "128c08df7852bb662648fabfedb8f214b7948de6b865b806dbe94a48480f3811"
  url "http://www.nightbirdsevolve.com/meta/updates/latest/"
  app "Meta.app"
  zap trash: [
               "~/Library/Application Support/Meta",
               "~/Library/Caches/com.nightbirdsevolve.Meta",
               "~/Library/Preferences/com.nightbirdsevolve.Meta.plist",
             ]
end
