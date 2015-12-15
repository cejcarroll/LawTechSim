//
//  MinigameScene.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/15/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "MinigameScene.h"

@implementation MinigameScene

- (instancetype)initWithSize:(CGSize)size minigameId:(NSString *)minigameId
{
    if (self = [super initWithSize:size])
    {
        _minigameId = minigameId;
        
        // TEMP:
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithText:@"Tap screen to win"];
        labelNode.position = CGPointMake(size.width / 2, size.height / 2);
        labelNode.fontColor = [SKColor whiteColor];
        [self addChild:labelNode];
    }
    
    return self;
}

// Temp implementation just sends delegate message
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.resultsDelegate minigameDidEndWithState:MinigameStateSuccess];
}

#pragma mark - GameControlViewInputReciever

- (void)redirectGameInput:(GameControlViewState)state
{
    
}

@end
