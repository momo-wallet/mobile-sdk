# mobile-sdk
If your business have a mobile app. You can use this SDK to integrate MoMo app into your app.

# mobile-sdk
-If your business have a mobile app. You can use this SDK to integrate MoMo app into your app.
  If your business have a mobile app. You can use this SDK to integrate MoMo app into your app.
 
 ## iOS App
 #IMPORTANT: Config file Plist
 
 ```
 <key>CFBundleURLTypes</key>
 <array>
   <dict>
     <key>CFBundleURLName</key>
     <string></string>
     <key>CFBundleURLSchemes</key>
     <array>
       <string>partnerSchemeId</string>
     </array>
   </dict>
 </array>
 <key>LSApplicationQueriesSchemes</key>
 <array>
   <string>momo</string>
 </array>
 <key>NSAppTransportSecurity</key>
 <dict>
   <key>NSAllowsArbitraryLoads</key>
   <true/>
 </dict>
 ```
 #partnerSchemeId: provided by MoMo , get from business.momo.vn
 
 ## Android App
