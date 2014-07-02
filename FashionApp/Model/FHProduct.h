//
//  FHProduct.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kProductIDKey;
extern NSString* const kProductNameKey;
extern NSString* const kProductURLKey;
extern NSString* const kProductImageURLKey;
extern NSString* const kProductCoverKey;
extern NSString* const kProductLoveCountKey;

@interface FHProduct : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *productName;
@property (nonatomic, copy, readonly) NSString *productURL;
@property (nonatomic, copy, readonly) NSString *productImageURL;
@property (nonatomic, getter = isCover, readwrite) BOOL cover;
@property (nonatomic, readonly) int loves;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
