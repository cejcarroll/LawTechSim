//
//  ChoiceBoxView.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "ChoiceBoxView.h"
#import "ChoiceEvent.h"

@interface ChoiceBoxView ()

/// Container for displaying text
@property (nonatomic, strong) UITextView *textView;

/// Dictionary of text attributes for default attributed text
@property (nonatomic, strong) NSDictionary *defaultTextAttributes;

/// Dictionary of text attributes for selected attributed text
@property (nonatomic, strong) NSDictionary *selectedTextAttributes;

/// Current choice event being displayed
@property (nonatomic, strong) ChoiceEvent *choiceEvent;

/// Bold font for selected choice
@property (nonatomic, strong) UIFont *selectedFont;

@end

@implementation ChoiceBoxView

/// Padding between text and background iamge
static const CGFloat kChoiceTextPadding = 5.0;

/// Extra space for text to account for size increase on selection
static const CGFloat kChoiceTextBuffer = 5.0;

/// Font name for selected choice
static NSString *const kChoiceBoxBoldFontName = @"Arial-BoldMT";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.textView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    // Clear previous choice's remenants
    if (hidden == YES)
    {
        self.textView.attributedText = nil;
        self.choiceEvent = nil;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textViewFrame = CGRectInset(self.bounds, kChoiceTextPadding, kChoiceTextPadding);
    [self.textView setFrame:textViewFrame];
}

#pragma mark - Public

/**
 Finds selected index's choice, and bolds specific text
 
 @param selectedIndex newSelectedIndex
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    // if invalid index, ignore it
    if (selectedIndex < 0 || selectedIndex >= self.choiceEvent.choices.count)
        return;
    
    Choice *oldChoice = self.choiceEvent.choices[_selectedIndex];
    Choice *newChoice = self.choiceEvent.choices[selectedIndex];
    
    NSMutableAttributedString *displayString = [self.textView.attributedText mutableCopy];
    
    NSRange unboldRange = [displayString.string rangeOfString:oldChoice.option];
    [displayString addAttributes:self.defaultTextAttributes range:unboldRange];
    
    NSRange boldRange = [displayString.string rangeOfString:newChoice.option];
    [displayString addAttributes:self.selectedTextAttributes range:boldRange];
    
    self.textView.attributedText = displayString;
    
    _selectedIndex = selectedIndex;
}

- (void)displayChoiceEvent:(ChoiceEvent *)event
{
    if (self.hidden)
        self.hidden = NO;
    
    self.choiceEvent = event;
    
    NSMutableString *displayString = [NSMutableString string];
    
    for (Choice *c in event.choices)
        [displayString appendFormat:@"%@\n", c.option];

    // delete last newline
    [displayString deleteCharactersInRange:NSMakeRange(displayString.length-1, 1)];
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:displayString
                                                                           attributes:self.defaultTextAttributes];
    self.textView.attributedText = attributedString;
    
    [self setSelectedIndex:0];
}

- (CGSize)sizeForCurrentChoiceEvent
{
    // Return CGRectZero if empty
    if (!self.textView.text || [self.textView.text isEqualToString:@""])
        return CGSizeZero;
    
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
    newSize.width += 2*kChoiceTextPadding + kChoiceTextBuffer;
    newSize.height += 2*kChoiceTextPadding;
    
    return newSize;
}

- (NSString *)choiceOptionForCurrentSelection
{
    Choice *c = self.choiceEvent.choices[self.selectedIndex];
    
    return c.option;
}

#pragma mark - Properties

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        
        [_textView setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                     forAxis:UILayoutConstraintAxisVertical];
        [_textView setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                     forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _textView;
}

- (NSDictionary *)defaultTextAttributes
{
    if (!_defaultTextAttributes)
    {
        _defaultTextAttributes = @{NSFontAttributeName : self.utilityFont};
    }
    
    return _defaultTextAttributes;
}

- (NSDictionary *)selectedTextAttributes
{
    if (!_selectedTextAttributes)
    {
        _selectedTextAttributes = @{NSFontAttributeName : self.selectedFont};
    }
    
    return _selectedTextAttributes;
}

- (UIFont *)selectedFont
{
    if (!_selectedFont)
    {
        _selectedFont = [UIFont fontWithName:kChoiceBoxBoldFontName size:UtilityViewFontSize];
    }
    
    return _selectedFont;
}

@end
