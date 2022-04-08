# WideKYC

All in one eKYC (Electronic Know Your Customer) solution available for android and ios. Wide Technologies provides an SDK for you to implement integration with your native mobile application. This document provides you with an overview of the SDK integration in terms of its architecture, interaction flow, supported products, and general integration process.

## Integration architecture	
Here is the architecture of our SDK integration.

![integrationChart](https://github.com/widetechid/WideKYC/blob/main/assets/integrationChart.jpeg)
<p align=center>Figure 1. SDK integration architecture</p>

SDK integration consists of two parts:

* Client-side integration: integrate the WideKYC SDK into the merchant application. The Wide SDK provides a ready set of screens and tools for both iOS and Android applications to capture required user data such as face images, identity document images, and so on. By integrating the Wide SDK, you can easily create a friendly interaction experience for your users in terms of:
  * Well designed UI to guide your users through the simple and easy business process
  * High success rate and high security with multiple algorithms applied
  * Simplified integration process by directly uploading images to the WideKYC service to process

* Server-side integration: Expose endpoints for your (merchant) application in your (merchant) server so that the merchant application can interact with the merchant server, which then accesses the WideKYC API to initialize a transaction and double-check verification results.

## Supported products
WideKYC SDK integration can be applied to the following products:

* Liveness Detection 
* ID Recognize (OCR)
* ID Validation by Population and Civil Registration Agency (_Dukcapil_)
* RealID (ID Recognize -> Liveness Detection -> ID Validation)

<p float="left">
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/passiveLiveness.png" alt="00" width="250"/>
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/idRecognize.png" alt="01" width="250"/>
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/idValidation.png" alt="02" width="250"/>
</p>
	
## Interaction flow
The following diagram illustrates the whole interaction flow when a WideKYC service is started through the mobile application.

![interactionDiagram](https://github.com/widetechid/WideKYC/blob/main/assets/interactionDiagram.jpeg)
<p align=center>Figure 2. Sequence diagram</p>

1. A user initiates a business process (for example, an ID Recognize process) through the merchant application.
2. The merchant app calls the getMetaInfo interface to obtain the meta-information about the WideKYC SDK and the user's device for preparation.
3. The WideKYC SDK returns the meta-information to the merchant application.
4. The merchant application initializes a transaction and passes the meta-information and product type to the merchant server.
5. With the meta-information and product info as an input, the merchant server calls the initialize API to obtain the configuration information, which includes parameters about SDK connection and behavior.
6. The Wide server performs a usability check based on the meta-information. If the check is passed, the Wide server returns the configuration information to the merchant server.
7. The merchant server returns the configuration information to the merchant application.
8. The merchant application starts the Wide SDK with the configuration information that is obtained in Step 7.
9. The Wide SDK interacts with the user, captures required data (for example, ID images), and uploads it to the Wide server for verification. There might be multiple rounds of interaction between the Wide SDK and Wide server.
10. The Wide server performs related checks on the uploaded user data, and returns the transaction status to the Wide SDK. If all the corresponding checks are passed, a result code that indicates success is returned to the Wide SDK; otherwise, the process might be interrupted and further interactions are needed between the user and the Wide SDK.
11. The Wide SDK notifies the merchant application that the transaction is completed.
12. The merchant application syncs with the merchant server that the transaction is completed and starts a double check on the transaction details.
13. The merchant server calls the checkResult API to check the transaction details with the Wide server again.
14. The Wide server returns the transaction details to the merchant server.
    Note: To ensure information security, sensitive information such as captured face images is only returned to the merchant server.

15. The merchant server filters the transaction details that are returned from the Wide server and returns the information that is not sensitive to the merchant application.
16. The merchant application informs the user that the process is completed.


# Integration Process

This section introduces how to implement the Wide SDK on and client-side mobile.

## SDK requirements
The Wide SDK supports both Android and iOS. To integrate the Wide SDK, ensure your mobile device system meets the following requirements:

* Operation system version must be Android 4.3 or later, or iOS 8 or later.
* Permissions of network and camera must be granted to the Wide SDK.

Note: please note x86 architecture is not supported.

## Android Integration

### 1. Import the SDK

a. Configure the maven repository 

Add the following maven repository configuration to the build.gradle file that is in your project root directory.

    maven {
         setAllowInsecureProtocol(true)
         url 'http://10.240.39.141/nexus/repository/maven-releases'
    }

b. Add the SDK dependency 

Add the SDK as a dependency in your module's (application-level) gradle file (usually app/build.gradle).

    implementation ('id.co.widetechnologies.component.mobile:widekyc:1.1.0'){transitive = true}

### 2. Get meta information

Use the `WKYC` class and its method `getMetaInfo` for transaction later. 

    WKYC wkyc = WKYC.getInstance(applicationContext);
    String metaInfo = WKYC.getMetaInfo(applicationContext); 

### 3. Initialize a transaction
Send a request that contains the meta-information to your (merchant) server to initialize a transaction. Then your (merchant) server needs to call the initialize API to obtain the configuration and return it to your (merchant) application.

### 4. Start the transaction flow

a. Construct the `WKYCRequest` object with the config that is returned from the merchant server using the GSON library to easily map the result to `WKYCConfig` class

    InitResponse initResponse = new Gson().fromJson(configurationJson.getString(Constants.CONTENT), InitResponse.class);
    WKYCRequest request = new WKYCRequest();
    request.wkycConfig = new Gson().fromJson(resultJson.getString("content"), WKYCConfig.class);
    request.clientConfig = new HashMap<>();
    request.clientConfig.put(WKYCConstants.LOCALE, WKYCConstants.LANG_EN);
    return request;

b. Start the transaction flow by calling the start method with the `WKYCRequest` object that is constructed in Step 4(a). You also need to override the callback functions to handle the transaction result. 

    wkyc.start(initResponse, new WideCallback() {
        @Override
        public void onCompleted(WKYCResponse response) {
        }
        @Override
        public void onInterrupted(WKYCResponse response) {
        }
        @Override
        public void onCancel(WKYCResponse response) {
        }
    });

The transaction result contains a result code that indicates the transaction flow status. If the end-user has completed the flow, the onCompleted method is invoked, where the transaction status needs to be synced with your (merchant) server and a double check needs to be started. Then your (merchant) server needs to call the checkResult API to get transaction details and return them to your (merchant) application. 

If the end-user has not completed the flow or client or server-side runtime error happens, the onInterrupted method is invoked, where related process logic needs to be implemented according to your business requirements.

And if the end-user canceled the process using the title back button or native back on their device, the onCancel method is invoked, where related process logic needs to be implemented according to your business requirements.

### 5. Customize UI

You can customize some aspects of WideKYC User Interface. We provide `config.json` that you can look up at :
   
    android/app/src/main/assets/;
    
You can change every value defined on `config.json` to suit your application styles. To Activate the Customized UI you can pass the config file name to `WKYCRequest` client config

    request.clientConfig.put(WKYCConstants.UI_CONFIG_PATH, "config.json");
 
### 6. (Optional) Handle ProGuard

If ProGuard is enabled in your android application, to ensure the WideKYC SDK can be invoked by your application successfully, add the following configuration to the project's confusing file：

    -dontwarn com.wide.mobile.widekyc.**
    -keep class com.wide.mobile.widekyc.**{
       <fields>;
       <methods>;
    }

## iOS Integration

### 1. Configure the SDK dependency
Extract widekyc.framework zip & Import to your project

a. XCODE Configuration

Add widekyc.framework to target app -> general -> Frameworks and Libraries -> add new framework -> choose widekyc.framework in your directory.

![XCODEConfiguration](https://github.com/widetechid/WideKYC/blob/main/assets/xcodeConfig.png)
<p align=center>Figure 3. XCODE Configuration</p>

b. Add the SDK dependency 

Create or update your podfile and run pod install

    platform :ios, '11.0'
    target '[YOUR_APP_NAME]' do
    use_frameworks!

    pod 'SwiftyJSON'
    pod 'SVProgressHUD'
    pod 'GoogleMLKit/TextRecognition', '2.2.0'
    pod 'GoogleMLKit/FaceDetection'
    pod 'KDCircularProgress'

### 2. Get meta information
Use the `WKYC` class and its method `getMetaInfo` to get the meta information about the WideKYC SDK and the user's device. The meta information is used to initialize a transaction later.

    import widekyc & SwiftyJSON
    
    set variable for app:
   
    var wkyc = WKYC()]
    
    let json = JSON(wkyc.getMetaInfo())
    let metaInfo = String(data: try! JSONEncoder().encode(json), encoding: .utf8)

### 3. Initialize a transaction
Send a request that contains the meta-information to your (merchant) server to initialize a transaction. Then your (merchant) server needs to call the initialize API to obtain the configuration and return it to your (merchant) application.

### 4. Start the transaction flow

a. Construct the `WKYCRequest` object with the config that is returned from the merchant server and map its result to `WKYCConfig` class
        
    let request = WKYCRequest()
    request.wkycConfig = wkycConfig
    request.clientConfig = [WKYCConstants.LOCALE : "en-US"]


b. Start the transaction flow by calling the start method with the `WKYCRequest` object that is constructed in Step 4(a). You also need to override the callback functions to handle the transaction result.

     WKYC.sharedInstance.start(request: request,
          completeCallback: {
             # add your implementation
          }, 
          interruptCallback: { 
             # add your implementation
	  }, 
          cancelCallback: { 
             # add your implementation
          }
     )

The transaction result contains a result code that indicates the transaction flow status. If the end-user has completed the flow, the onCompleted method is invoked, where the transaction status needs to be synced with your (merchant) server and a double check needs to be started. Then your (merchant) server needs to call the checkResult API to get transaction details and return them to your (merchant) application. 

If the end-user has not completed the flow or client or server-side runtime error happens, the onInterrupted method is invoked, where related process logic needs to be implemented according to your business requirements.

And if the end-user canceled the process using the title back button or native back on their device, the onCancel method is invoked, where related process logic needs to be implemented according to your business requirements.





# API Reference

### Service Level 
The following table shows the service level types that are supported by the WideKYC SDK APIs, and the corresponding validation & behaviour that are returned/processed for each service level type.

| Product            | Service Level     | Description                        |
| :----------------: |:-----------------:| :---------------------------------:|
| Passive Liveness   | 62000             |  Medium liveness validation.       |
|                    | 62001             |  Advanced liveness validation.     |
| Id Recognize       | 62010             |  Entry Id Recognize validation.    |
|                    | 62011             |  Medium Id Recognize validation.   |
|                    | 62012             |  Advanced Id Recognize validation. |
| Id Validation.     | 62020             |  Id Validation with UI.            |
|                    | 62021             |  Id Validation non UI.             |
