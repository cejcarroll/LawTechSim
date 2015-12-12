//
//  StoryParser.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EntityInteractionGroup;

@protocol StoryParserDelegate <NSObject>

/**
 Called when StoryParser finishes parsing all EntityInteractionGroups described in file
 
 @param sequenceGroups NSDictionary of entityId to EventSequenceGroup for that entity
 */
- (void)storyParserDidParseInteractionGroups:(NSDictionary <NSString *, EntityInteractionGroup *> *)interactionGroups;


@end

//-------------------------------------------------

/**
 StoryParser parses game story file .ltg
 When VALIDATE flag is on, validates story file
 */
@interface StoryParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id<StoryParserDelegate> delegate;


/**
 Begin parsing story file
 
 @param fileName NSString file name of story file
 */
- (void)parseInteractionGroupsFromFileNamed:(NSString *)fileName;

@end
