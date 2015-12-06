//
//  GameViewController.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameControlView.h"

@interface GameViewController ()

@property (nonatomic, strong) SKView *gameView;
@property (nonatomic, strong) GameScene *gameScene;
@property (nonatomic, strong) GameControlView *controlView;

@end

@implementation GameViewController



- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingNone;

    // GameView
    self.gameView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.gameView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.gameView];
    
    // TEMP: logs
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Controls
    [self.view addSubview:self.controlView];

    // TODO: Implement Start Screen?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TEMP: Load GameScene for now
    // Setup and Present GameScene
    self.controlView.delegate = self.gameScene;
    [self.gameView presentScene:self.gameScene];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect gameFrame = self.view.bounds;
    gameFrame.size.height /= 2;
    [self.gameView setFrame:gameFrame];
    
    // Layout control to bottom half of screen TEMP
    CGRect ctrlFrame = self.view.bounds;
    ctrlFrame.size.height /= 2;
    ctrlFrame.origin.y += ctrlFrame.size.height;
    [self.controlView setFrame:ctrlFrame];
    
}

#pragma mark - Properties

- (GameScene *)gameScene
{
    if (!_gameScene)
    {
        _gameScene = [GameScene sceneWithSize: self.view.bounds.size];
        // TODO: Load last played state (?)
    }
    
    return _gameScene;
}

- (GameControlView *)controlView
{
    if (!_controlView)
    {
        _controlView = [[GameControlView alloc] init];
    }
    
    return _controlView;
}



@end
