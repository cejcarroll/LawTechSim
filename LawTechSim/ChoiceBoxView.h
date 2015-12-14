//
//  ChoiceBoxView.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "UtilityView.h"
@class ChoiceEvent;


/**
 Interface for displaying a series of choices within a box
 @note set frame with height = 0. ChoiceBox will grow up from that line as needed
 */
@interface ChoiceBoxView : UtilityView

/// Index of currentl selected choice. Initiially 0. Automatically ignores changes that exceed bounds.
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 Displays choices from contents of ChoiceEvent.
 Unhides box if hidden
 
 @param event ChoiceEvent to display
 */
- (void)displayChoiceEvent:(ChoiceEvent *)event;

@end
