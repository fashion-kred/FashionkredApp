//
//  LookCell.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/11/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

@class FHUserLook;

#import <Foundation/Foundation.h>

extern NSString* const kUserURL;
extern NSString* const kUserProductPicPlaceholder;
extern NSString* const kUserPicPlaceholder;

@interface LookCell : UITableViewCell

@property (nonatomic) FHUserLook *look;

- (void)loadSubviewsForLook:(FHUserLook *)userLook;

@property (copy, nonatomic) void (^actionBlock)(NSString *);

@end
