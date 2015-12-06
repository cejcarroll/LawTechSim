//
//  GameControlView.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/6/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameControlView.h"

@interface GameControlView ()

// TEMP: Properties
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation GameControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _state = GameControlViewStateNoPress;
        
        
        // FIXME: Replace with actual assets and organize later on
        [self initializeButtons];
        [self addSubview:self.leftBtn];
        [self addSubview:self.upBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.downBtn];
        [self addSubview:self.actionBtn];
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect btnFrame;
    
    CGFloat kButtonPadding = 30; // Space from edge of screen
    CGFloat kButtonSpacing = 50; // Space between btns
    
    // LEFT
    btnFrame = self.leftBtn.frame;
    btnFrame.origin.x = kButtonPadding;
    btnFrame.origin.y = bounds.size.height / 2;
    [self.leftBtn setFrame:btnFrame];
    
    // UP
    btnFrame = self.upBtn.frame;
    btnFrame.origin.x = kButtonPadding + kButtonSpacing;
    btnFrame.origin.y = bounds.size.height / 2 - kButtonSpacing;
    [self.upBtn setFrame:btnFrame];
    
    // DOWN
    btnFrame = self.downBtn.frame;
    btnFrame.origin.x = kButtonPadding + kButtonSpacing;
    btnFrame.origin.y = bounds.size.height / 2 + kButtonSpacing;
    [self.downBtn setFrame:btnFrame];
    
    // RIGHT
    btnFrame = self.rightBtn.frame;
    btnFrame.origin.x = kButtonPadding + 2*kButtonSpacing;
    btnFrame.origin.y = bounds.size.height / 2;
    [self.rightBtn setFrame:btnFrame];
    
    // ACTION
    btnFrame = self.actionBtn.frame;
    btnFrame.origin.x = bounds.size.width - kButtonPadding - btnFrame.size.width;
    btnFrame.origin.y = bounds.size.height / 2;
    [self.actionBtn setFrame:btnFrame];
}

#pragma mark - Actions

- (void)leftBtnPressed
{
    self.state = GameControlViewStateLeftPress;
}

- (void)upBtnPressed
{
    self.state = GameControlViewStateUpPress;
}

- (void)rightBtnPressed
{
    self.state = GameControlViewStateRightPress;
}

- (void)downBtnPressed
{
    self.state = GameControlViewStateDownPress;
}

- (void)directionalBtnDepressed
{
    self.state = GameControlViewStateNoPress;
}

- (void)actionBtnPressed
{
    if (self.delegate)
        [self.delegate gameControlDidPressAction];
}

#pragma mark - Properties

- (void)setState:(GameControlViewState)state
{
    if (_state != state && self.delegate)
        [self.delegate gameControlDidChangeToState:state];
    
    _state = state;
}

// TEMP: Too lazy; Initializing all buttons at once
- (void)initializeButtons
{
    NSUInteger depressControlEvents = UIControlEventTouchDragExit | UIControlEventTouchUpInside;
    
    // LEFT
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leftBtn setTitle:@"LEFT" forState:UIControlStateNormal];
    [self.leftBtn sizeToFit];
    [self.leftBtn addTarget:self
                     action:@selector(leftBtnPressed)
           forControlEvents:UIControlEventTouchDown];
    [self.leftBtn addTarget:self
                     action:@selector(directionalBtnDepressed)
           forControlEvents:depressControlEvents];
    
    // UP
    self.upBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.upBtn setTitle:@"UP" forState:UIControlStateNormal];
    [self.upBtn sizeToFit];
    [self.upBtn addTarget:self
                   action:@selector(upBtnPressed)
         forControlEvents:UIControlEventTouchDown];
    [self.upBtn addTarget:self
                     action:@selector(directionalBtnDepressed)
           forControlEvents:depressControlEvents];
    
    // RIGHT
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rightBtn setTitle:@"RIGHT" forState:UIControlStateNormal];
    [self.rightBtn sizeToFit];
    [self.rightBtn addTarget:self
                      action:@selector(rightBtnPressed)
            forControlEvents:UIControlEventTouchDown];
    [self.rightBtn addTarget:self
                     action:@selector(directionalBtnDepressed)
           forControlEvents:depressControlEvents];
    
    // DOWN
    self.downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.downBtn setTitle:@"DOWN" forState:UIControlStateNormal];
    [self.downBtn sizeToFit];
    [self.downBtn addTarget:self
                     action:@selector(downBtnPressed)
           forControlEvents:UIControlEventTouchDown];
    [self.downBtn addTarget:self
                     action:@selector(directionalBtnDepressed)
           forControlEvents:depressControlEvents];
    
    // ACTION
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionBtn setTitle:@"ACTION" forState:UIControlStateNormal];
    [self.actionBtn sizeToFit];
    [self.actionBtn addTarget:self
                          action:@selector(actionBtnPressed)
                forControlEvents:UIControlEventTouchUpInside];
}





@end
