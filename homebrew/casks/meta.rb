cask "meta" do
  version "1.9.5"
  sha256 "0d7a5e08a20a5f6911f1d195719a20d287ce129ba824b2216fc9d18d9f626e21"
  url "http://www.nightbirdsevolve.com/meta/updates/latest/"
  app "Meta.app"
  zap trash: [
               "~/Library/Application Support/Meta",
               "~/Library/Caches/com.nightbirdsevolve.Meta",
               "~/Library/Preferences/com.nightbirdsevolve.Meta.plist",
             ]
end
