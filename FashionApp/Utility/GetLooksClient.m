//
//  GetLooksClient.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/11/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "GetLooksClient.h"

NSString* const kLookURLString = @"http://54.187.150.46/WebServices.aspx/GetRecentLooks";
NSString* const kUserID = @"userId";
NSString* const kOffsetValue = @"offset";
NSString* const kLimit = @"limit";
NSString* const kLookURL = @"http://54.187.150.46/look.aspx?lid=";

@implementation GetLooksClient

+ (GetLooksClient *)sharedClient
{
    static GetLooksClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kLookURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return  nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getLooksForUser:(NSUInteger)userID
                 offset:(NSUInteger)offset
                  limit:(int)limit
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSDictionary *parameters = @{kUserID: @(userID), kOffsetValue : @(offset), kLimit : @(limit)};
    
    [self POST:kLookURLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);            
        }
    }];
}


@end
