//
//  CTAssetResourceLoaderDelegate.m
//  CTVideoView
//
//  Created by casa on 16/6/20.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTAssetResourceLoaderDelegate.h"

@implementation CTAssetResourceLoaderDelegate

#pragma mark - AVAssetResourceLoaderDelegate
// Processing Resource Requests
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{

}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest
{
    return YES;
}

// Processing Authentication Challenges
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
{

}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
{
    return YES;
}


@end
