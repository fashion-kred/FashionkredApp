//
//  FHProduct.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "FHProduct.h"

NSString* const kProductIDKey = @"id";
NSString* const kProductNameKey = @"name";
NSString* const kProductURLKey = @"url";
NSString* const kProductImageURLKey = @"url";
NSString* const kProductCoverKey = @"isCover";
NSString* const kProductLoveCountKey = @"loves";
NSString* const kProductImagesKey = @"images";


@interface FHProduct ()

@property (nonatomic, copy) NSString *productID;

@end

@implementation FHProduct

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    if (dict) {
        if (dict[kProductIDKey]) {
            _productID = [dict[kProductIDKey] stringValue];
        }
        if (dict[kProductNameKey]) {
            _productName = dict[kProductNameKey];
        }
        if (dict[kProductURLKey]) {
            _productURL = dict[kProductURLKey];
        }
        
        _loves = [dict[kProductLoveCountKey] intValue];
        _cover = [dict[kProductCoverKey] boolValue];
        
        NSArray *imageArray = dict[kProductImagesKey];
        if ([imageArray count] > 0) {
            for (NSDictionary *imageDict in imageArray) {
                if (imageDict[kProductImageURLKey]) {
                    _productImageURL = imageDict[kProductImageURLKey];
                }
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_productID forKey:kProductIDKey];
    [aCoder encodeObject:_productName forKey:kProductNameKey];
    [aCoder encodeObject:_productURL forKey:kProductURLKey];
    [aCoder encodeInt:_loves forKey:kProductLoveCountKey];
    [aCoder encodeBool:_cover forKey:kProductCoverKey];
    [aCoder encodeObject:_productImageURL forKey:kProductImageURLKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _productID = [aDecoder decodeObjectForKey:kProductIDKey];
        _productName = [aDecoder decodeObjectForKey:kProductNameKey];
        _productURL = [aDecoder decodeObjectForKey:kProductURLKey];
        _loves = [aDecoder decodeIntForKey:kProductLoveCountKey];
        _cover = [aDecoder decodeBoolForKey:kProductCoverKey];
        _productImageURL = [aDecoder decodeObjectForKey:kProductImageURLKey];
    }
    
    return self;
}


@end
