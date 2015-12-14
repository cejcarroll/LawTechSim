//
//  GameUtilityView.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "UtilityView.h"

@interface UtilityView ()

/// Background image
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation UtilityView

NSString *const UtilityViewFontName = @"ArialMT";
const CGFloat UtilityViewFontSize = 18.0;



static NSString *const kBackgroundImageFileName = @"backgroundBox";
static const UIEdgeInsets kBackgroundImageEdgeInsets = {6, 6, 6, 6};

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.backgroundImageView];
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    // Background UIImageView
    [self.backgroundImageView setFrame:bounds];
}

#pragma mark - Properties

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        UIImage *bgImage = [[UIImage imageNamed:kBackgroundImageFileName]
                            resizableImageWithCapInsets:kBackgroundImageEdgeInsets];
        _backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
    }
    
    return _backgroundImageView;
}

- (UIFont *)utilityFont
{
    if (!_utilityFont)
    {
        _utilityFont = [UIFont fontWithName:UtilityViewFontName size:UtilityViewFontSize];
    }
    
    return _utilityFont;
}

@end
