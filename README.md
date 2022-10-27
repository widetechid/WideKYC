<h1 align="center">
  <a>
    WideKYC
  </a>
</h1>

<div align="center">

<a href="">![Android SDK Version](https://img.shields.io/badge/Android-1.1.2-brightgreen)</a>
<a href="">![iOS SDK Version](https://img.shields.io/badge/iOS-1.1.4-brightgreen)</a>
<a href="">![GitHub language count](https://img.shields.io/github/languages/count/widetechid/widekyc)</a>
<a href="">![GitHub top language](https://img.shields.io/github/languages/top/widetechid/widekyc)</a>
<a href="">![GitHub repo size](https://img.shields.io/github/repo-size/widetechid/widekyc)</a>
<a href="">![GitHub last commit](https://img.shields.io/github/last-commit/widetechid/widekyc)</a>

</div>

All in one eKYC (Electronic Know Your Customer) solution available for android and ios. Wide Technologies Indonesia provides an SDK for you to implement integration with your native mobile application. This document provides you with an overview of the SDK integration in terms of its architecture, interaction flow, available products, and general integration process.

## Contents

- [Available Products](#available-products)
- [Integration Architecture](#integration-architecture)
- [Interaction Flow](#interaction-flow)
- [Integration Process](#integration-process)
- [API Documentation](#api-documentation)
- [Reference](#reference)

## Available Products
WideKYC SDK integration can be applied to the following products:

* Liveness Detection
* ID Recognize _(OCR)_
* ID Validation _(by Dukcapil - Population and Civil Registration Agency)_

<p float="left">
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/passiveLiveness.png" alt="00" width="250"/>
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/idRecognize.png" alt="01" width="250"/>
<img src="https://github.com/widetechid/WideKYC/blob/main/assets/idValidation.png" alt="02" width="250"/>
</p>

## Integration Architecture
Here is the architecture of our SDK integration.

![integrationChart](https://github.com/widetechid/WideKYC/blob/main/assets/integrationChart.jpeg)
<p align=center>Figure 1. SDK integration architecture</p>

SDK integration consists of two parts:

* Client-side integration: integrate the WideKYC SDK into the merchant application. The WideKYC SDK provides a ready set of screens and tools for both iOS and Android applications to capture required user data such as face images, identity document images, and so on. By integrating the WideKYC SDK, you can easily create a friendly interaction experience for your users in terms of:
  * Well designed UI to guide your users through the simple and easy business process
  * High success rate and high security with multiple algorithms applied
  * Simplified integration process by directly uploading images to the WideKYC service to process

* Server-side integration: Expose endpoints for your (merchant) application in your (merchant) server so that the merchant application can interact with the merchant server, which then accesses the WideKYC API to initialize a transaction and double-check verification results.

## Interaction Flow
The following diagram illustrates the whole interaction flow when a WideKYC service is started through the mobile application.

![interactionDiagram](https://github.com/widetechid/WideKYC/blob/main/assets/interactionDiagram.jpeg)
<p align=center>Figure 2. Sequence diagram</p>

1. A user initiates a business process (for example, an ID Recognize process) through the merchant application.
2. The merchant app calls the getMetaInfo interface to obtain the meta-information about the WideKYC SDK and the user's device for preparation.
3. The WideKYC SDK returns the meta-information to the merchant application.
4. The merchant application initializes a transaction and passes the meta-information and product type to the merchant server.
5. With the meta-information and product info as an input, the merchant server calls the initialize API to obtain the configuration information, which includes parameters about SDK connection and behavior.
6. The WideKYC server performs a usability check based on the meta-information. If the check is passed, the WideKYC server returns the configuration information to the merchant server.
7. The merchant server returns the configuration information to the merchant application.
8. The merchant application starts the WideKYC SDK with the configuration information that is obtained in Step 7.
9. The WideKYC SDK interacts with the user, captures required data (for example, ID images), and uploads it to the Wide server for verification. There might be multiple rounds of interaction between the WideKYC SDK and Wide server.
10. The WideKYC server performs related checks on the uploaded user data, and returns the transaction status to the WideKYC SDK. If all the corresponding checks are passed, a result code that indicates success is returned to the WideKYC SDK; otherwise, the process might be interrupted and further interactions are needed between the user and the WideKYC SDK.
11. The WideKYC SDK notifies the merchant application that the transaction is completed.
12. The merchant application syncs with the merchant server that the transaction is completed and starts a double check on the transaction details.
13. The merchant server calls the checkResult API to check the transaction details with the WideKYC server again.
14. The WideKYC server returns the transaction details to the merchant server.
    Note: To ensure information security, sensitive information such as captured face images is only returned to the merchant server.

15. The merchant server filters the transaction details that are returned from the WideKYC server and returns the information that is not sensitive to the merchant application.
16. The merchant application informs the user that the process is completed.


## Integration Process

* [**SDK Integration Process**][sdk-integration-process].
* [**Merchant Server Integration Process**][merchant-server-integration-process].

[sdk-integration-process]: https://github.com/widetechid/WideKYC/wiki/SDK-Integration-Process
[merchant-server-integration-process]: https://github.com/widetechid/WideKYC/wiki/Merchant-Server-Integration-Process

## API Documentation

* [**WideKYC API**][widekyc-api]
* [**Merchant Specific API**][merchant-specific-api]

[widekyc-api]: https://github.com/widetechid/WideKYC/wiki/WideKYC-API
[merchant-specific-api]: https://github.com/widetechid/WideKYC/wiki/Merchant-Specific-API

## Reference

* [**Product Reference**][product-reference].
* [**Android SDK Reference**][android-sdk-reference].
* [**iOS SDK Reference**][ios-sdk-reference].

[product-reference]: https://github.com/widetechid/WideKYC/wiki/Product-Reference
[android-sdk-reference]: https://github.com/widetechid/WideKYC/wiki/SDK-Reference-(Android)
[ios-sdk-reference]: https://github.com/widetechid/WideKYC/wiki/SDK-Reference-(iOS)
