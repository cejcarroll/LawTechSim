//
//  GameViewController.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControlView.h"
#import "StoryStore.h"

@interface GameViewController : UIViewController <GameControlViewDelegate, StoryStoreDelegate>

@end
