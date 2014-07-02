//
//  LookParser.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookParser : NSObject

@property (nonatomic, strong) NSMutableArray *lookArray;

- (NSArray *)parseLookFrom:(NSDictionary *)jsonData;
- (void)saveUserLooks;
- (NSMutableArray *)fetchLooks;

@end
