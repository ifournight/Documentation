//
//  NewBookmarkFolderController.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "NewBookmarkFolderController.h"
#import "FolderRenameTextField.h"
#import "BookmarkManager.h"
#import "Appearance.h"

@interface NewBookmarkFolderController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet FolderRenameTextField *textField;

@property (strong, nonatomic) UIAlertView *noneTextAlertView;
@property (strong, nonatomic) UIAlertView *uniqueNameAlertView;

@end

@implementation NewBookmarkFolderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // NavBar Custom
    [[Appearance share] customNavBar:self.navBar];
    [[Appearance share] customNavBarButton:self.cancelButton];
    [[Appearance share] customNavBarButton:self.doneButton];
    // Text Field
    self.textField.placeholder = @"New Folder";
    self.textField.enabled = YES;
    // Notification Observe
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIAlertView *)noneTextAlertView
{
    if (!_noneTextAlertView) {
        _noneTextAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Sorry, folder names must be at least 1 character in length." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    return _noneTextAlertView;
}

- (UIAlertView *)uniqueNameAlertView
{
    if (!_uniqueNameAlertView) {
        _uniqueNameAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Folde names must be unique" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    return _uniqueNameAlertView;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate newBookmarkFolderDidCancel];
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.textField.text.length == 0) {
        [self.noneTextAlertView show];
    }   else if (![[BookmarkManager share] uniqueBookmarkFolderName:self.textField.text]) {
        [self.uniqueNameAlertView show];
    }   else {
        [self.delegate newBookmarkFolderDidDoneWithName:self.textField.text];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // No need to differentiate two types of alertView
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)applicationDidEnterBackground
{
    if (self.noneTextAlertView.visible) {
        [self.noneTextAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (self.uniqueNameAlertView.visible) {
        [self.uniqueNameAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end