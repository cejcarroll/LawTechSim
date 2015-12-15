//
//  MinigameScene.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/15/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControlView.h"


typedef NS_ENUM(NSInteger, MinigameState)
{
    MinigameStateSuccess,
    MinigameStateFail
};

@protocol MinigameSceneDelegate <NSObject>

- (void)minigameDidEndWithState:(MinigameState)state;

@end

@interface MinigameScene : SKScene <GameControlViewInputReceiver>

/// Identifier for minigame. Used to specify specific minigame event
@property (nonatomic, readonly, copy) NSString *minigameId;

/// Delegate to which results of minigame is sent to
@property (nonatomic, weak) id<MinigameSceneDelegate> resultsDelegate;


- (instancetype)initWithSize:(CGSize)size minigameId:(NSString *)minigameId;


@end
