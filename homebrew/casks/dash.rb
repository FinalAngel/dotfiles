cask "dash" do
  version "5.1.6"
  sha256 "dd0d23c03f447b6b904765444e8863d55f4cb15c8d1669d039d14e095eb5466a"
  url "http://frankfurt.kapeli.com/downloads/v5/Dash.zip"
  app "Dash.app"
  zap trash: [
               "~/Library/Application Support/Dash",
               "~/Library/Application Support/com.kapeli.dashdoc",
               "~/Library/Caches/com.kapeli.dashdoc",
               "~/Library/Cookies/com.kapeli.dashdoc.binarycookies",
               "~/Library/Logs/Dash",
               "~/Library/Preferences/com.kapeli.dashdoc.plist",
             ]
end
