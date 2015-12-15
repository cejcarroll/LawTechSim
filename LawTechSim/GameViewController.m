//
//  GameViewController.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameViewController.h"
#import "OverworldGameScene.h"


@interface GameViewController ()

/// View of GameScene
@property (nonatomic, strong) SKView *gameView;

/// SKScene of sprites
@property (nonatomic, strong) OverworldGameScene *overworldGameScene;

/// View of control
@property (nonatomic, strong) GameControlView *controlView;

/// Overlay view showing dialog boxes and choice boxes above gameView
@property (nonatomic, strong) GameOverlayView *overlayView;

/// Manages story and game state
@property (nonatomic, strong) StoryStore *storyStore;

/// Pointer to mini game
@property (nonatomic, strong) MinigameScene *miniGame;

@end

@implementation GameViewController

static NSString *const kGameStoryFileName = @"story";

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    // GameView
    [self.view addSubview:self.gameView];
    
    // TEMP: logs
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Controls
    [self.view addSubview:self.controlView];
    
    // Overlay
    [self.view addSubview:self.overlayView];
    
    // TODO: Implement Start Screen?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*   Initialize StoryStore   */
    self.storyStore = [[StoryStore alloc] initWithFileNamed:kGameStoryFileName
                                                   loadSave:NO];
    self.storyStore.delegate = self;
    
    /*   Setup GameScene   */
    [self.gameView presentScene:self.overworldGameScene];
}

// FIXME: Create separate view class for GameViewController
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // GameView to top half of screen
    CGRect gameFrame = self.view.bounds;
    gameFrame.size.height /= 2;
    [self.gameView setFrame:gameFrame];
    
    // OvelayView (same as gameView's frame)
    [self.overlayView setFrame:gameFrame];
    
    // ControlView to bottom half of screen TEMP
    CGRect ctrlFrame = self.view.bounds;
    ctrlFrame.size.height /= 2;
    ctrlFrame.origin.y += ctrlFrame.size.height;
    [self.controlView setFrame:ctrlFrame];
}

#pragma mark - Properties

- (SKView *)gameView
{
    if (!_gameView)
    {
        _gameView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _gameView.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return _gameView;
}

- (OverworldGameScene *)overworldGameScene
{
    if (!_overworldGameScene)
    {
        _overworldGameScene = [OverworldGameScene sceneWithSize: self.view.bounds.size];
    }
    
    return _overworldGameScene;
}

- (GameControlView *)controlView
{
    if (!_controlView)
    {
        _controlView = [[GameControlView alloc] init];
        _controlView.delegate = self;
    }
    
    return _controlView;
}

- (GameOverlayView *)overlayView
{
    if (!_overlayView)
    {
        _overlayView = [[GameOverlayView alloc] initWithFrame:CGRectZero];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.delegate = self;
    }
    
    return _overlayView;
}


#pragma mark - GameControlViewDelegate

- (void)gameControlDidChangeToState:(GameControlViewState)state
{
    if (self.miniGame)          /*   Redirect to Minigame if one is active   */
    {
        [self.miniGame redirectGameInput:state];
    }
    if ([self.storyStore hasActiveEventSequence])       /*   Interrumpt movement control if event sequence is active. (i.e. Choice or Dialogue being shown)   */
    {
        [self.overlayView redirectGameInput:state];
    }
    else        /*   If there is no active event sequence, redirect to game scene to control character   */
    {
        [self.overworldGameScene redirectGameInput:state];
    }
    
}

- (void)gameControlDidPressAction
{
    if (self.miniGame)                                  /*   Redirect to minigame if there is one   */
    {
        [self.miniGame redirectGameInput:GameControlViewStateActionPress];
    }
    else if (self.overlayView.swallowsAction)           /*   Redirect to overlay for choice box   */
    {
        [self.overlayView redirectGameInput:GameControlViewStateActionPress];
    }
    else if ([self.storyStore hasActiveEventSequence])       /*   Progress story based on current active event   */
    {

        [self.storyStore progressToNextEventWithOption:nil];
    }
    else
    {
        /*   If no active event loaded, and there is an entity nearby, begin new interaction   */
        NSString *nearbyEntityId = [self.overworldGameScene nearbyEntityForCharacter];
        
        if (nearbyEntityId)
        {
            [self.overworldGameScene redirectGameInput:GameControlViewStateNoPress];
            [self.storyStore activateEventSequenceForId:nearbyEntityId];
        }

    }
}

#pragma mark - GameOverlayViewDelegate

- (void)gameOverlayDidSelectOption:(NSString *)option
{
    assert(self.storyStore.currentEvent.eventType == EventTypeChoice);
    [self.storyStore progressToNextEventWithOption:option];
}


#pragma mark - StoryStoreDelegate

- (void)storyStoreReadEvent:(id<EventProtocol>)event
{
    EventType type = [event eventType];
    
    if (type == EventTypeDialogue ||
        type == EventTypeChoice)
    {
        [self.overlayView displayEvent:event];
    }
    else if (type == EventTypeSpecial)
    {
        [self.overlayView hideAllOverlays];
        
        self.miniGame = [[MinigameScene alloc] initWithSize:self.gameView.bounds.size
                                                 minigameId:@"MINIGAME_ID"];
        self.miniGame.resultsDelegate = self;
        
        SKTransition *transition = [SKTransition doorwayWithDuration:0.5];
        [self.gameView presentScene:self.miniGame transition:transition];
    }
    else
    {
        NSLog(@"Found unhandled event type %@", event);
    }

}


- (void)storyStoreFinishedSequence
{
    [self.overlayView hideAllOverlays];
}

#pragma mark - MinigameSceneDelegate

- (void)minigameDidEndWithState:(MinigameState)state
{
    [self.gameView presentScene:self.overworldGameScene transition:[SKTransition fadeWithDuration:0.5]];
    self.miniGame = nil;
    
    if (state == MinigameStateSuccess)
    {
        [self.storyStore progressToNextEventWithOption:StoryStoreSpecialEventSuccess];
    }
    else if (state == MinigameStateFail)
    {
        [self.storyStore progressToNextEventWithOption:StoryStoreSpecialEventFail];
    }
}




@end
