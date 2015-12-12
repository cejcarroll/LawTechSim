//
//  StoryParser.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EntityInteractionGroup, EventSequence;

@protocol StoryParserDelegate <NSObject>

/**
 Called when StoryParser finishes parsing all EntityInteractionGroups described in file
 
 
 @param interactionGroupsDict NSDictionary of entityId to EntityInteractionGroup for that entity. I.e. the "starting" scenes for a entity
 @param scenes NSDictionary of sceneId to EventSequences. I.e. the comprehensive dictionary of all scenes
 */
- (void)storyParserDidParseInteractionGroups:(NSDictionary <NSString *, EntityInteractionGroup *> *)interactionGroupsDict
                                      scenes:(NSDictionary <NSString *, EventSequence *> *)scenes;


@end

//-------------------------------------------------

/**
 StoryParser parses game story file .ltg
 */
@interface StoryParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id<StoryParserDelegate> delegate;


/**
 Begin parsing story file
 
 @param fileName NSString file name of story file
 */
- (void)parseInteractionGroupsFromFileNamed:(NSString *)fileName;

@end
