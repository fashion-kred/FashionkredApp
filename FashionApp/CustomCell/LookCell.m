//
//  LookCell.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/11/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "LookCell.h"
#import "FHUserLook.h"
#import "FHLookTag.h"
#import "FHProduct.h"
#import "FHLookCreator.h"

#import "UIImageView+AFNetworking.h"

NSString* const kUserURL = @"http://54.187.150.46/user.aspx?uid=";
NSString* const kUserProductPicPlaceholder = @"placeholder";
NSString* const kUserPicPlaceholder = @"profile";

const CGFloat kOffset = 10;
const CGFloat kSmall_Width = 151.0;
const CGFloat kSmall_height = 231.0;
const CGFloat kBig_Width = 310.0;
const CGFloat kBig_height = 475.0;
const CGFloat kPaddingHorizontal = 11.0;
const CGFloat kPaddingVertical = 13.0;

@interface LookCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnHeart;
@property (weak, nonatomic) IBOutlet UIButton *btnRestyle;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *productsView;
@property (weak, nonatomic) IBOutlet UIView *creatorView;

@end

@implementation LookCell

- (void)loadSubviewsForLook:(FHUserLook *)userLook
{
    [self setHeartButtonForLook:userLook];
    [self setRestyleButtonForLook:userLook];
    
    [self layoutProductsForLook:userLook];
    [self layoutCreatorInfoForLook:userLook];
}

//Add all products to the ProductView for CurrentLook
- (void)layoutProductsForLook:(FHUserLook *)userLook
{
    [self.productsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = userLook.products.count;
    NSUInteger profileImageIndex = [self getCoverImagePositionForLook:userLook];
    
    for (int i = 0; i < count; i++) {
        
        FHProduct *product = userLook.products[i];
        
        NSURL *url = [NSURL URLWithString:product.productImageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:kUserProductPicPlaceholder];
        
        CGRect imageFrame = CGRectZero;
        imageFrame.size = (product.isCover) ? CGSizeMake(kBig_Width, kBig_height) :
        CGSizeMake(kSmall_Width, kSmall_height);
        
        imageFrame.origin = [self imagePositionForIndex:i
                                      profileImageIndex:profileImageIndex];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imageFrame];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = i;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 1.0;
        activityIndicator.center = CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2);
        activityIndicator.hidesWhenStopped = YES;
        [imgView addSubview:activityIndicator];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [activityIndicator startAnimating];
        
        @weakify(imgView)
        @weakify(activityIndicator)
        [imgView setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    
                                    @strongify(imgView)
                                    @strongify(activityIndicator)
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                    [activityIndicator stopAnimating];
                                    imgView.image = image;
                                }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    
                                    @strongify(activityIndicator)
                                    [activityIndicator stopAnimating];
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                                }];
        
        [self.productsView addSubview:imgView];
        
        UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTemp setBackgroundColor:[UIColor clearColor]];
        [btnTemp setFrame:imageFrame];
        [btnTemp addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
        btnTemp.tag = i;
        
        [self.productsView addSubview:btnTemp];
        
        btnTemp = nil;
        imgView = nil;
    }
}

//Set the Creator view values
- (void)layoutCreatorInfoForLook:(FHUserLook *)userLook
{
    [self.creatorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    FHLookCreator *creator = userLook.creator;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.creatorView addSubview:imgView];
    
    NSURL *url = [NSURL URLWithString:creator.creatorPicURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:kUserPicPlaceholder];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2);
    activityIndicator.hidesWhenStopped = YES;
    [imgView addSubview:activityIndicator];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    @weakify(imgView)
    @weakify(activityIndicator)
    [imgView setImageWithURLRequest:request
                   placeholderImage:placeholderImage
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                                @strongify(imgView)
                                @strongify(activityIndicator)

                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                [activityIndicator stopAnimating];
                                    imgView.image = image;
                        }
                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                @strongify(activityIndicator)
                                [activityIndicator stopAnimating];
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }];
    
    //Set Restyle Label in Creator View
    NSDictionary *labelRestyleAttributes = [self attributesForRestyleLabel];
    NSString *labelRestyleString = userLook.isReStyled ? @"re-styled by" : @"via";
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:labelRestyleString attributes:labelRestyleAttributes];
    CGSize sizeRestyle = attrStr.size;
    CGRect labelRestyleRect = CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + kOffset, imgView.frame.origin.y, sizeRestyle.width, sizeRestyle.height);
    UILabel *labelRestyle = [[UILabel alloc] initWithFrame:labelRestyleRect];
    labelRestyle.attributedText = attrStr;
    [self.creatorView addSubview:labelRestyle];

    //Set Creator Label in Creator View
    NSDictionary *creatorLabelAttributes = [self attributesForCreatorLabel];
    NSAttributedString *creatorAttributeString = [[NSAttributedString alloc] initWithString:creator.creatorName attributes:creatorLabelAttributes];
    CGSize sizeCreator = creatorAttributeString.size;
    CGRect creatorNameRect = CGRectMake(labelRestyleRect.origin.x, labelRestyleRect.origin.y + labelRestyleRect.size.height, sizeCreator.width, sizeCreator.height);
    UILabel *creatorNameLabel = [[UILabel alloc] initWithFrame:creatorNameRect];
    creatorNameLabel.attributedText = creatorAttributeString;
    [self.creatorView addSubview:creatorNameLabel];
    
    //Set Button to open creator url
    UIButton *btnCreator = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCreator setFrame:creatorNameRect];
    btnCreator.tag = [creator.creatorID intValue];
    [btnCreator addTarget:self action:@selector(openUserURL:) forControlEvents:UIControlEventTouchUpInside];
    [self.creatorView addSubview:btnCreator];
    
    //Set Tag Label in Creator View
    NSDictionary *tagLabelAttributes = [self attributesForTag];
    NSMutableString *tagString = [NSMutableString new];
    for (FHLookTag *tag in userLook.lookTags) {
        tagString = [NSMutableString stringWithFormat:@"%@ #%@",tagString,tag.tagName];
    }
    
    NSAttributedString *tagAttributeString = [[NSAttributedString alloc] initWithString:tagString attributes:tagLabelAttributes];
    CGSize sizeTag = tagAttributeString.size;
    CGRect tagRect = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + kOffset, sizeTag.width, sizeTag.height);
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:tagRect];
    tagLabel.attributedText = tagAttributeString;
    [self.creatorView addSubview:tagLabel];
}


#pragma mark Attribute Dictionary for Labels

- (NSDictionary *)attributesForRestyleLabel
{
    return @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15], NSForegroundColorAttributeName : [UIColor lightGrayColor]};
}

- (NSDictionary *)attributesForCreatorLabel
{
  return @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15], NSForegroundColorAttributeName : [UIColor colorWithRed:0.8863 green:0.3569 blue:0.7725 alpha:1.0]};}


- (NSDictionary *)attributesForTag
{
    return @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor colorWithRed:0.3843 green:0.4231 blue:0.2078 alpha:1.0]};
}


//Return resized image for display
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, newRect, imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Heart, Restyle Button

- (void)setHeartButtonForLook:(FHUserLook *)userLook
{
    [self.btnHeart setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 5)];
    [self.btnHeart setTitle:[NSString stringWithFormat:@"%d",userLook.upVote] forState:UIControlStateNormal];
    if (userLook.isLoved) {
        [self.btnHeart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnHeart setBackgroundImage:[UIImage imageNamed:@"heartSelected"] forState:UIControlStateNormal];
    } else {
        [self.btnHeart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnHeart setBackgroundImage:[UIImage imageNamed:@"heartUnselected"] forState:UIControlStateNormal];
    }
}

- (void)setRestyleButtonForLook:(FHUserLook *)userLook
{
    [self.btnRestyle setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 5)];
    [self.btnRestyle setTitle:[NSString stringWithFormat:@"%d",userLook.restyleCount] forState:UIControlStateNormal];
    if (userLook.isReStyled) {
        [self.btnRestyle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnRestyle setBackgroundImage:[UIImage imageNamed:@"restyleSelected"] forState:UIControlStateNormal];
    } else {
        [self.btnRestyle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnRestyle setBackgroundImage:[UIImage imageNamed:@"restyleUnselected"] forState:UIControlStateNormal];
    }
}

#pragma mark Calculate Image Position

//Get the origin point of image based on cover image
- (CGPoint)imagePositionForIndex:(NSUInteger)index profileImageIndex:(NSUInteger)profileImageIndex
{
    CGPoint toReturn = CGPointZero;
    
    NSUInteger totalCount = (self.look.products.count >0) ? MIN(self.look.products.count, 5) : 0;
    CGSize containerSize = self.productsView.frame.size;
    
    //Considering a grid of 3 columns
    CGFloat h_padding = (containerSize.width - 2*kSmall_Width - kBig_Width)/2;
    //Considering a grid of 2 rows
    CGFloat v_padding = (containerSize.height - 2*kSmall_height);
    
    NSInteger totalColumns = 3;
    NSInteger totalRows = (NSInteger) ceil(((float)totalCount / (float)totalColumns));
    
    NSInteger currentImageColumn = index % totalColumns;
    NSInteger currentImageRow = (index - currentImageColumn) % totalRows;
    NSInteger profileImageColumn = profileImageIndex >= 3 ? 1: profileImageIndex % totalColumns;
    NSInteger profileImageRow = (profileImageIndex - profileImageColumn) %totalRows;
    
    if (profileImageIndex >=3) {
        profileImageRow = 0;
        if (index >= 2 && index != profileImageIndex) {
            if (index == 2) {
                ++currentImageRow;
                currentImageColumn = 0;
            } else if (index == 3) {
                currentImageColumn = 2;
            } else if (index == 4) {
                currentImageColumn = 2;
            }
        } else if (index == profileImageIndex) {
            currentImageColumn = 1;
            currentImageRow = 0;
        }
    }
    
    CGFloat yPos = 0;
    yPos = (profileImageIndex == index)? 0 : currentImageRow * kSmall_height + currentImageRow * v_padding ;
    
    CGFloat xPos = 0;
    
    if (index < profileImageIndex)
    {
        if (profileImageIndex > 2) {
            if (profileImageRow < currentImageRow) {
                if (currentImageColumn >= profileImageColumn) {
                    if (profileImageIndex == 4) {
                        xPos = (kBig_Width + h_padding) + (currentImageColumn - 1) * (kSmall_Width + h_padding);
                    }
                }
                else {
                    xPos = (kSmall_Width + h_padding) * currentImageColumn;
                }
            }
            else if (profileImageRow == currentImageRow) {
                
                (currentImageColumn == profileImageColumn) ? ++currentImageColumn : currentImageColumn;
                
                if (currentImageColumn > profileImageColumn) {
                    xPos = (kBig_Width + h_padding) + (currentImageColumn - 1) * (kSmall_Width + h_padding);
                }
                else {
                    xPos = currentImageColumn * kSmall_Width + currentImageColumn * h_padding;
                }
            }
        } else {
            xPos = currentImageColumn * kSmall_Width + currentImageColumn * h_padding;
        }
    }
    else if (index == profileImageIndex)
    {
        xPos = (kSmall_Width + h_padding) * currentImageColumn;
    }
    else
    {
        if (profileImageRow < currentImageRow) {
            if (profileImageIndex >= 3) {
                xPos = (kBig_Width + h_padding) + (currentImageColumn - 1) * (kSmall_Width + h_padding);
            }
            else if (currentImageColumn >= profileImageColumn) {
                xPos = (kBig_Width + h_padding) + (currentImageColumn) * (kSmall_Width + h_padding);
            }
            else {
                xPos = (kSmall_Width + h_padding) * currentImageColumn;
            }
        }
        else if (profileImageRow == currentImageRow) {
            
            (currentImageColumn == profileImageColumn) ? ++currentImageColumn : currentImageColumn;
            
            if (currentImageColumn > profileImageColumn) {
                xPos = (kBig_Width + h_padding) + (currentImageColumn - 1) * (kSmall_Width + h_padding);
            }
            else {
                xPos = kSmall_Width * (index - profileImageIndex - 1) + kBig_Width + (index - profileImageIndex)*h_padding;
            }
        }
        else {
            xPos = kSmall_Width * (index - profileImageIndex) + kBig_Width + (index - profileImageIndex) * h_padding;
        }
    }
    
    toReturn.x = xPos;
    toReturn.y = yPos;
    
    return toReturn;
}

//Rearrange frames to set new cover
- (void)rearrangeFramesForLook:(FHUserLook *)userLook andNewProfileImageIndex:(int)index
{
    for (UIView *view in self.productsView.subviews) {
        int indexView = view.tag;
        FHProduct *product = self.look.products[indexView];
        CGPoint point = [self imagePositionForIndex:indexView profileImageIndex:index];
        CGSize size = (product.isCover) ? CGSizeMake(kBig_Width, kBig_height) : CGSizeMake(kSmall_Width, kSmall_height);
        CGRect imageRect;
        imageRect.origin = point;
        imageRect.size = size;
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = imageRect;
        }
        else if ([view isKindOfClass:[UIImageView class]]) {
            view.frame = imageRect;
        }
    }
}

//Return cover image position for current look
- (NSInteger)getCoverImagePositionForLook:(FHUserLook *)userLook
{
    NSInteger coverImagePosition = 0;
    for (int i = 0; i < [userLook.products count]; i++) {
        FHProduct *product = userLook.products[i];
        if (product.isCover) {
            break;
        }
        ++coverImagePosition;
    }
    
    return coverImagePosition;
}

#pragma mark - ACTION METHODS

//Called when user clicks on image to set it as cover
- (IBAction)myAction:(UIButton *)sender
{
    FHProduct *product = self.look.products[sender.tag];
    if (product.isCover) {
        return;
    } else {
        for (FHProduct *productLook in self.look.products) {
            if ([productLook isEqual:product]) {
                productLook.cover = YES;
            } else {
                productLook.cover = NO;
            }
        }
    }
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self rearrangeFramesForLook:self.look andNewProfileImageIndex:sender.tag];
                     }
                     completion:nil];
}

//Open URL when user clicks on creatorName
- (IBAction)openUserURL:(UIButton *)sender
{
    NSString *string = [kUserURL stringByAppendingFormat:@"%d",sender.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

//Share Action -- Forwarded to FHLooksViewController
- (IBAction)share:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(self.look.lookID);
    }
}



@end
