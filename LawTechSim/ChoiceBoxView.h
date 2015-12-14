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
 @note bottom corner of ChoiceBoxView's frame is used to resize subviews properly
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


/**
 Return the size ChoiceBoxView should be with respect to current choice being displayed
 Calculates based on text within internal UITextView. If empty, returns CGRectZero
 
 @return CGRect frame value for ChoiceBoxView.
 */
- (CGSize)sizeForCurrentChoiceEvent;


/**
 Returns Choice object's option string for current selection
 
 @return NSString of Choice object's option
 */
- (NSString *)choiceOptionForCurrentSelection;

@end
