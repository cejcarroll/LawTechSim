//
//  DialogBox.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "DialogBoxView.h"
#import "DialogueEvent.h"

@interface DialogBoxView ()

/// Text View to display text
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DialogBoxView

static const CGFloat kTextBoxPadding = 5;


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.textView];
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;

    // Text UILabel
    CGRect textViewFrame = CGRectInset(bounds, kTextBoxPadding, kTextBoxPadding);
    [self.textView setFrame:textViewFrame];
}

#pragma mark - Public

- (void)displayText:(NSString *)text
{
    if (self.hidden)
        self.hidden = NO;
    
    self.textView.text = text;
}

- (void)displayDialogEvent:(DialogueEvent *)event
{
    NSString *displayText = [NSString stringWithFormat:@"%@:\n%@", event.speakerName, event.content];
    
    [self displayText:displayText];
}

#pragma mark - Properties

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont fontWithName:UtilityViewFontName size:UtilityViewFontSize];
    }
    
    return _textView;
}

@end
