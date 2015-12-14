//
//  GameOverlayView.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameOverlayView.h"
#import "DialogBoxView.h"
#import "ChoiceBoxView.h"
#import "DialogueEvent.h"
#import "ChoiceEvent.h"

@interface GameOverlayView ()

@property (nonatomic, strong) DialogBoxView *dialogBoxView;
@property (nonatomic, strong) ChoiceBoxView *choiceBoxView;

@end

@implementation GameOverlayView

/*   Dialog box   */
static const CGFloat kBoxPadding = 10;
static const CGFloat kDialogBoxHeight = 90;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.dialogBoxView];
        [self addSubview:self.choiceBoxView];
        
        self.dialogBoxView.hidden = YES;
        self.choiceBoxView.hidden = YES;
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    /*   Dialog Box   */
    CGRect dialogBoxFrame = self.bounds;
    dialogBoxFrame.size.width -= 2 * kBoxPadding;
    dialogBoxFrame.size.height = kDialogBoxHeight;
    dialogBoxFrame.origin.x += kBoxPadding;
    dialogBoxFrame.origin.y += bounds.size.height - kDialogBoxHeight - kBoxPadding;
    [self.dialogBoxView setFrame:dialogBoxFrame];
    
    /*   Choice Box   */
    CGRect choiceBoxFrame = dialogBoxFrame;
    choiceBoxFrame.size = [self.choiceBoxView sizeForCurrentChoiceEvent];
    choiceBoxFrame.origin.x += dialogBoxFrame.size.width - choiceBoxFrame.size.width;
    choiceBoxFrame.origin.y -= choiceBoxFrame.size.height + kBoxPadding;
    [self.choiceBoxView setFrame:choiceBoxFrame];

}

#pragma mark - Public

- (void)hideAllOverlays
{
    self.dialogBoxView.hidden = YES;
    self.choiceBoxView.hidden = YES;
}

- (void)displayEvent:(id<EventProtocol>)event
{
    EventType eventType = [event eventType];
    
    if (eventType == EventTypeDialogue)
    {
        [self.dialogBoxView displayDialogEvent:event];
    }
    else if (eventType == EventTypeChoice)
    {
        [self.choiceBoxView displayChoiceEvent:event];
        [self setNeedsLayout]; // Trigger re-layout of choice box
    }
    
}

- (void)redirectGameInput:(GameControlViewState)state
{
    if (!self.swallowsAction)
        return;
    
    if (state == GameControlViewStateActionPress)
    {
        /*   User selected choice   */
        NSString *chosenOption = [self.choiceBoxView choiceOptionForCurrentSelection];
        [self.delegate gameOverlayDidSelectOption:chosenOption];
        
        self.choiceBoxView.hidden = YES;
    }
    else if (state == GameControlViewStateDownPress || state == GameControlViewStateRightPress)
    {
        self.choiceBoxView.selectedIndex += 1;
    }
    else if (state == GameControlViewStateUpPress || state == GameControlViewStateLeftPress)
    {
        self.choiceBoxView.selectedIndex -= 1;
    }
}

#pragma mark - Properties

- (BOOL)swallowsAction
{
    return self.choiceBoxView.hidden == NO;
}

- (DialogBoxView *)dialogBoxView
{
    if (!_dialogBoxView)
    {
        _dialogBoxView = [[DialogBoxView alloc] initWithFrame:self.bounds];;
    }
    
    return _dialogBoxView;
}

- (ChoiceBoxView *)choiceBoxView
{
    if (!_choiceBoxView)
    {
        _choiceBoxView = [[ChoiceBoxView alloc] initWithFrame:CGRectZero];
    }
    
    return _choiceBoxView;
}



@end
