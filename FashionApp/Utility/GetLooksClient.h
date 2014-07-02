//
//  GetLooksClient.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/11/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


extern NSString * const kLookURLString;
extern NSString * const kLookURL;

@interface GetLooksClient : AFHTTPSessionManager

+ (GetLooksClient *)sharedClient;

- (void)getLooksForUser:(NSUInteger)userID
                 offset:(NSUInteger)offset
                  limit:(int)limit
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
