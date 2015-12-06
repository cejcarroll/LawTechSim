//
//  GameViewController.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

@property (nonatomic, strong) SKView *view;
@property (nonatomic, strong) GameScene *gameScene;

@end

@implementation GameViewController
@dynamic view;


- (void)loadView
{
    self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // TODO: Implement Start Screen?
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TEMP: Load GameScene for now
    [self.view presentScene:self.gameScene];

    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
