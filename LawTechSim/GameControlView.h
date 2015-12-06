//
//  GameControlView.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/6/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 GameControlView States for interactions
 */
typedef NS_ENUM(NSInteger, GameControlViewState)
{
    GameControlViewStateNoPress,
    GameControlViewStateLeftPress,
    GameControlViewStateUpPress,
    GameControlViewStateRightPress,
    GameControlViewStateDownPress
};

/**
 Delegate for GameControlView to communicate action buttonpress
 */
@protocol GameControlViewDelegate <NSObject>

- (void)gameControlDidPressAction;
- (void)gameControlDidChangeToState:(GameControlViewState) state;

@end


/**
 Control for game. Primary interface is the state property, that represents what interaction is happening
 */
@interface GameControlView : UIView


/**
 Property indication current interaction with control
 */
@property (nonatomic, assign) GameControlViewState state;

@property (nonatomic, weak) id<GameControlViewDelegate> delegate;

@end
