//
//  CTAssetResourceLoaderDelegate.m
//  CTVideoView
//
//  Created by casa on 16/6/20.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTAssetResourceLoaderDelegate.h"

@interface CTAssetResourceLoaderDelegate ()

@property (nonatomic, strong) NSMutableArray *requestList;

@end

@implementation CTAssetResourceLoaderDelegate

#pragma mark - AVAssetResourceLoaderDelegate
// Processing Resource Requests
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    if (self.requestList.count == 0) {
        [self.requestList addObject:loadingRequest];

        NSURLComponents *urlComponent = [NSURLComponents componentsWithURL:loadingRequest.request.URL resolvingAgainstBaseURL:NO];
        urlComponent.scheme = self.originScheme;
        NSURL *realURL = urlComponent.URL;

        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfiguration];

        [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSDictionary *headers = httpResponse.allHeaderFields;

                loadingRequest.contentInformationRequest.contentLength = httpResponse.expectedContentLength;
                loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
                CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(headers[@"Content-Type"]), NULL);
                loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
            }
//            loadingRequest.response = response;
            return NSURLSessionResponseAllow;
        }];
        [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            //        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"-----------");
            NSLog(@"%@", loadingRequest);
            NSLog(@"-----------");
            [loadingRequest.dataRequest respondWithData:data];
//            [loadingRequest finishLoadingWithResponse:nil data:nil redirect:nil];
            //        [loadingRequest finishLoading];
            //        });
            //        NSLog(@"here i am");
        }];
        //    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //        NSLog(@"here");
        //    }];

        NSURLRequest *request = [NSURLRequest requestWithURL:realURL];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"complete");
            [loadingRequest finishLoading];
        }];
        [dataTask resume];
    }


//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%f", (CGFloat)downloadProgress.completedUnitCount / (CGFloat)downloadProgress.totalUnitCount);
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mp4"];
//        return [NSURL fileURLWithPath:filePath];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSLog(@"completed");
//    }];
//    [downloadTask resume];

    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.requestList removeObject:loadingRequest];
}

//- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest
//{
//    return YES;
//}
//
//// Processing Authentication Challenges
//- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
//{
//
//}
//
//- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
//{
//    return YES;
//}

#pragma mark - getters and setters
- (NSMutableArray *)requestList
{
    if (_requestList == nil) {
        _requestList = [[NSMutableArray alloc] init];
    }
    return _requestList;
}

@end
