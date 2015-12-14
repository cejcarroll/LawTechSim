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

@interface GameOverlayView ()

@property (nonatomic, strong) DialogBoxView *dialogBoxView;
@property (nonatomic, strong) ChoiceBoxView *choiceBoxView;

@end

@implementation GameOverlayView

/*   Dialog box layout   */
static const CGFloat kDialogBoxPadding = 10;
static const CGFloat kDialogBoxHeight = 90;

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Public

- (void)hideAllOverlays
{
    
}

- (void)displayEvent:(id<EventProtocol> *)event
{
    
}

- (void)redirectInputFromGame:(GameControlViewState)state
{
    
}

#pragma mark - Properties

- (DialogBoxView *)dialogBoxView
{
    if (!_dialogBoxView)
    {
        _dialogBoxView = [[DialogBoxView alloc] initWithFrame:self.bounds];
        _dialogBoxView.hidden = YES;
    }
    
    return _dialogBoxView;
}

@end
