//
//  MPGameViewController.m
//  MyPet
//
//  Created by Jon Como on 3/4/15.
//  Copyright (c) 2015 Jon Como. All rights reserved.
//

#import "MPGameViewController.h"
#import "MPGameScene.h"

@import SpriteKit;

@interface MPGameViewController ()

@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) MPGameScene *game;

@end

@implementation MPGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGSize gameSize = self.view.bounds.size;
    
    self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, gameSize.width, gameSize.height)];
    self.game = [[MPGameScene alloc] initWithSize:gameSize];
    
    [self.view addSubview:self.skView];
    [self.skView presentScene:self.game];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
