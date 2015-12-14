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
    GameControlViewStateDownPress,
    GameControlViewStateActionPress
};

/**
 Delegate for GameControlView to communicate action buttonpress
 */
@protocol GameControlViewDelegate <NSObject>

/**
 Notifies delegate action button was pressed
 */
- (void)gameControlDidPressAction;

/**
 Notifes delegate directional control's state has changed
 
 @param state GameConrolViewState that control updated to
 */
- (void)gameControlDidChangeToState:(GameControlViewState) state;

@end


/**
 Control for game. Primary interface is the state property, that represents what interaction is happening
 */
@interface GameControlView : UIView



/// Property indicating current interaction with control
@property (nonatomic, assign) GameControlViewState state;

/// Recipient of controller's messages.
@property (nonatomic, weak) id<GameControlViewDelegate> delegate;

@end
