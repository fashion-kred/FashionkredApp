//
//  FHLookTag.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kLookTagIDKey;
extern NSString* const kLookTagNameKey;
extern NSString* const kLookTagImageURLKey;

@interface FHLookTag : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *tagName;
@property (nonatomic, copy, readonly) NSString *tagImageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
