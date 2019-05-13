
# react-native-momosdk v1.2.5

### Module to create e-wallet payment method. That is the way to payment customer's order by their MoMo e-wallet.

## Getting started

`$ npm install react-native-momosdk --save`

### Mostly automatic installation

`$ react-native link react-native-momosdk`

### Manual installation


#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
- Add `import com.reactlibrary.RNMomosdkPackage;` to the imports at the top of the file
- Add `new RNMomosdkPackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:
```
include ':react-native-momosdk'
project(':react-native-momosdk').projectDir = new File(rootProject.projectDir,     '../node_modules/react-native-momosdk/android')
```

3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
```
compile project(':react-native-momosdk')
```

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-momosdk` and add `RNMomosdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNMomosdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Config file Plist (CFBundleURLTypes and LSApplicationQueriesSchemes)

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

```
AppDelegate
#import "RNMomosdk.h"
/*iOS 9 or newest*/
-(BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
  [RNMomosdk handleOpenUrl:url];
  return YES;
}

/*iOS 8 or lower*/
-(BOOL)application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation;{
  [RNMomosdk handleOpenUrl:url];
  return YES;
}
 ```

## Usage & Example code
```javascript
import { Platform, DeviceEventEmitter,NativeModules, NativeEventEmitter} from 'react-native';
import RNMomosdk from 'react-native-momosdk';
const RNMomosdkModule = NativeModules.RNMomosdk;
const EventEmitter = new NativeEventEmitter(RNMomosdkModule);

const merchantname = "CGV Cinemas";
const merchantcode = "CGV01";
const merchantNameLabel = "Nhà cung cấp";
const billdescription = "Fast and Furious 8";
const amount = 50000;
const enviroment = "0"; //"0": SANBOX , "1": PRODUCTION


componentDidMount(){
    EventEmitter.addListener('RCTMoMoNoficationCenterRequestTokenReceived', (response) => {
        try{
            console.log("<MoMoPay>Listen.Event::" + JSON.stringify(response));
              if (response && response.status == 0) {
                //SUCCESS: continue to submit momoToken,phonenumber to server
                let fromapp = response.fromapp; //ALWAYS:: fromapp==momotransfer
                let momoToken = response.data;
                let phonenumber = response.phonenumber;
                let message = response.message;
              } else {
                //let message = response.message;
                //Has Error: show message here
              }
        }catch(ex){}
    });
    //OPTIONAL
    EventEmitter.addListener('RCTMoMoNoficationCenterRequestTokenState',(response) => {
        console.log("<MoMoPay>Listen.RequestTokenState:: " + response.status);
        // status = 1: Parameters valid & ready to open MoMo app.
        // status = 2: canOpenURL failed for URL MoMo app 
        // status = 3: Parameters invalid
    })
}

// TODO: Action to Request Payment MoMo App
onPress = async () => {
    let jsonData = {};
    jsonData.enviroment = enviroment; //SANBOX OR PRODUCTION
    jsonData.action = "gettoken"; //DO NOT EDIT
    jsonData.merchantname = merchantname; //edit your merchantname here
    jsonData.merchantcode = merchantcode; //edit your merchantcode here
    jsonData.merchantnamelabel = merchantNameLabel;
    jsonData.description = billdescription;
    jsonData.amount = 5000;//order total amount
    jsonData.orderId = "ID20181123192300";
    jsonData.orderLabel = "Ma don hang";
    jsonData.appScheme = "momocgv20170101";// iOS App Only , match with Schemes Indentify from your  Info.plist > key URL types > URL Schemes
    console.log("data_request_payment " + JSON.stringify(jsonData));
    if (Platform.OS === 'android'){
      let dataPayment = await RNMomosdk.requestPayment(jsonData);
      this.momoHandleResponse(dataPayment);
    }else{
      RNMomosdk.requestPayment(JSON.stringify(jsonData));
    }
}

async momoHandleResponse(response){
  try{
    if (response && response.status == 0) {
      //SUCCESS continue to submit momoToken,phonenumber to server
      let fromapp = response.fromapp; //ALWAYS:: fromapp == momotransfer
      let momoToken = response.data;
      let phonenumber = response.phonenumber;
      let message = response.message;

    } else {
      //let message = response.message;
      //Has Error: show message here
    }
  }catch(ex){}
}
```
