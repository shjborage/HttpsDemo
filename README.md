# HttpsDemo

在 iOS 中尝试 https  

### 根据域名下载证书
证书其实就是文本，可通过以下命令来获取并手动保存。 多级证书，可能需要保存多个并分别操作。
```
openssl s_client -showcerts -host sp0.baidu.com -port 443
```
>You can examine one of these certificates by:
>
>1. copying the text (the -----BEGIN CERTIFICATE----- line through to the -----END CERTIFICATE----- line) into a text file with the .pem extension
>2. dragging that file into Keychain Access
>3. double clicking the newly imported certificate
>This will open the standard certificate viewer which you can use to examine the certificate in detail.

这儿也有一些说明：<http://serverfault.com/questions/139728/how-to-download-ssl-certificate-from-a-website>


证书转换格式供 iOS 的工程使用

```
openssl x509 -in sp0_bdnsdk.gem -out cert.cer -outform der
```

### 双向验证
双向验证一般比较少，当服务端需要双向验证的话， `connection: willSendRequestForAuthenticationChallenge:` 返回的`challenge.protectionSpace.authenticationMethod` 是 `NSURLAuthenticationMethodClientCertificate`，处理的方式是使用 `credentialWithIdentity:certificates:persistence:` 来获取本地证书创建凭证 `credential`，使用该凭证来进行连接。

具体你可以参考下面文档和例子：  
<https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/Articles/AuthenticationChallenges.html>  
<http://www.sunethmendis.com/2013/01/11/certificate-based-client-authentication-in-ios/>
<http://stackoverflow.com/questions/25924881/ios-client-certificates-and-mobile-device-management>

##REF
<https://developer.apple.com/library/ios/technotes/tn2232/_index.html>
<http://nsscreencast.com/episodes/73-ssl-pinning>
<http://oncenote.com/2014/10/21/Security-1-HTTPS/>