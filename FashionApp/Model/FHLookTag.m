//
//  FHLookTag.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "FHLookTag.h"

NSString* const kLookTagIDKey = @"id";
NSString* const kLookTagNameKey = @"name";
NSString* const kLookTagImageURLKey = @"imageUrl";

@interface FHLookTag ()

@property (nonatomic, copy) NSString *tagID;

@end

@implementation FHLookTag

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (dict) {
        if (dict[kLookTagIDKey]) {
            _tagID = [dict[kLookTagIDKey] stringValue];
        }
        if ( dict[kLookTagNameKey]) {
            _tagName = dict[kLookTagNameKey];
        }
        if (dict[kLookTagImageURLKey]) {
            _tagImageURL = dict[kLookTagImageURLKey];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_tagID forKey:kLookTagIDKey];
    [aCoder encodeObject:_tagName forKey:kLookTagNameKey];
    [aCoder encodeObject:_tagImageURL forKey:kLookTagImageURLKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _tagID = [aDecoder decodeObjectForKey:kLookTagIDKey];
        _tagName = [aDecoder decodeObjectForKey:kLookTagNameKey];
        _tagImageURL = [aDecoder decodeObjectForKey:kLookTagImageURLKey];
    }
    
    return self;
}


@end
