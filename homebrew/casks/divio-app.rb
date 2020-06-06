cask "divio-app" do
  version "1.0.2"
  sha256 "abc9a38b9d6fd1aef16995455147df6629d9af80b6c21b5ed02d576df647e8c9"
  url "https://divio-app-releases.s3.amazonaws.com/releases/Divio-#{version}.dmg"
  app "Divio.app"
  zap trash: [
               "~/Library/Application Support/Divio",
               "~/Library/Caches/com.divio.divio-app",
               "~/Library/Preferences/com.divio.divio-app.plist",
               "~/Library/Preferences/com.divio.divio-app.helper.plist",
             ]
end
