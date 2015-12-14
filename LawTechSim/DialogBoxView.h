//
//  DialogBox.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/13/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "UtilityView.h"
@class DialogueEvent;

/**
 Interface for displaying dialogue text in a box
 */
@interface DialogBoxView : UtilityView

/**
 Display string within dialog box. 
 Unhides view if hidden = YES
 
 @param text NSString to display
 */
- (void)displayText:(NSString *)text;

/**
 Display string representing dialog event in dialog box.
 Unhides view if hidden = YES
 
 @param event DialogEvent to display
 */
- (void)displayDialogEvent:(DialogueEvent *)event;

@end
