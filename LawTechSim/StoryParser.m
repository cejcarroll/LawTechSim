//
//  StoryParser.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "StoryParser.h"

@interface StoryParser ()

/// Mapping of scene identifier to specific character
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *scenarioMapping;

/// Dict of scene identifier to required flag identifier
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *scenarioConditions;

/// Array of parsed scenarios as EntityInteractionGroup
@property (nonatomic, strong) NSMutableArray <EntityInteractionGroup *> *interactionGroups;

/// parser for game file
@property (nonatomic, strong) NSXMLParser *fileParser;

@end

@implementation StoryParser


#pragma mark - Public

- (void)parseInteractionGroupsFromFileNamed:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"ltg"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.scenarioMapping = [NSMutableDictionary dictionary];
    self.scenarioConditions = [NSMutableDictionary dictionary];
    self.interactionGroups = [NSMutableArray array];
    
    self.fileParser = [[NSXMLParser alloc] initWithData:data];
    self.fileParser.delegate = self;
    [self.fileParser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // TODO: Create dictionary by iterationg through self.interactionGroups
    // Apply condition requires from scenarioConditions
    // Add each interactionGroup to key (char id) of scenarioMapping
    
//    [self.delegate storyParserDidParseInteractionGroups:self.interactionGroups];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"<%@>: %@", elementName, attributeDict);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"</%@>", elementName);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@: %@", NSStringFromClass([self class]), [parseError localizedDescription]);
}

@end
