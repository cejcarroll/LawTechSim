//
//  ChoiceEvent.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EventProtocol.h"

/**
 Model for specific Choice within ChoiceEvent
 */
@interface Choice : NSObject

/// Option encapsulated by a particular choice, eg answering "Yes"
@property (nonatomic, readonly) NSString *option;

/// identifier to scene to jump to if this choice's action is taken
@property (nonatomic, readonly) NSString *destinationScene;


/**
 Initialize new Choice object
 
 @param option String that represents option
 @param sceneId identifier for schene to link to
 
 @return new Choice
 */
- (instancetype)initWithOption:(NSString *)option
              destinationScene:(NSString *)sceneId;

/**
 Initialize new Choice object from attributes
 
 @param attr NSDictionary of attributes
 
 @return new Choice
 */
- (instancetype)initWithAttributes:(NSDictionary *)attr;

@end

//-------------------------------------------------

/**
 Model for a Choice Event, when a player has to choose from several options
 */
@interface ChoiceEvent : NSObject <EventProtocol>

/// Array of all choices available
@property (nonatomic, readonly) NSArray<Choice *> *choices;

/**
 Creates a new Choice object based on attributes dictionary, and adds it to choice event
 Call as parsing story data file
 
 @param attr NSDictionary with attributes of choice
 */
- (void)addChoiceWithAttributes:(NSDictionary *)attr;

@end
