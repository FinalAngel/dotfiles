cask "dash" do
  version "5.1.6"
  sha256 "6c49b237710f05bcd09656247d392f1fc770c04b6a4e2d8ac8ef572dc196efd2"
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
