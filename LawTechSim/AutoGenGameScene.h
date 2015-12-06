//
//  GameScene.h
//  LawTechSim
//

//  Copyright (c) 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AutoGenGameScene : SKScene

@end

@interface SKScene (Unarchive)
+ (instancetype)unarchiveFromFile:(NSString *)file;
@end




