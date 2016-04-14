//
//  ViewController.m
//  HttpsDemo
//
//  Created by shihaijie on 4/14/16.
//  Copyright © 2016 Saick. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Now start the connection
    NSURL *httpsURL = [NSURL URLWithString:@"https://www.github.com"];
    self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:httpsURL] delegate:self];
    
//    //先导入证书
//    NSString * cerPath = ...; //证书的路径
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
//    self.trustedCertificates = @[CFBridgingRelease(certificate)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    
    //2)SecTrustEvaluate对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified))
    {
        //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
        NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
        
        NSLog(@"Https 单向验证成功");
    } else {
        //5)验证失败，取消这次验证流程
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}

//// 使用本地证书的方式
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    //1)获取trust object
//    SecTrustRef trust = challenge.protectionSpace.serverTrust;
//    SecTrustResultType result;
//    
//    //注意：这里将之前导入的证书设置成下面验证的Trust Object的anchor certificate
//    SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)self.trustedCertificates);
//    
//    //2)SecTrustEvaluate会查找前面SecTrustSetAnchorCertificates设置的证书或者系统默认提供的证书，对trust进行验证
//    OSStatus status = SecTrustEvaluate(trust, &result);
//    if (status == errSecSuccess &&
//        (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified))
//    {
//        //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
//        NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
//        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
//    } else {
//        //5)验证失败，取消这次验证流程
//        [challenge.sender cancelAuthenticationChallenge:challenge];
//    }
//}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection_didFailWithError:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection_didFailWithError:%@", error);
}

@end
