//
//  GameOverlayView.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventProtocol.h"
#import "GameControlView.h"

@protocol GameOverlayViewDelegate <NSObject>

/**
 Notify delegate an option in ChoiceBox was selected
 
 @param option NSString option of a Choice object
 */
- (void)gameOverlayDidSelectOption:(NSString *)option;

@end

/**
 View above GameScene's SKView, containing all HUD elements like dialog box, choice box, etc
 Swallows user interaction from GameControlView when Choice mode is active
 */
@interface GameOverlayView : UIView <GameControlViewInputReceiver>

@property (nonatomic, strong) id <GameOverlayViewDelegate> delegate;

/// BOOL indicating whether commands should be swallowed by overlay. I.e. when choice is active
@property (nonatomic, readonly) BOOL swallowsAction;


/**
 Hides all overlays displayed. Call when series of interaction ends
 */
- (void)hideAllOverlays;

/**
 Display Event of type Choice or Dialogue appropriately.
 All other event types are ignored
 
 @param event Obj conforming to EventProtocol to display
 */
- (void)displayEvent:(id<EventProtocol>)event;

@end
