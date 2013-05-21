//
//  DetailViewController.m
//  MySecNote
//
//  Created by forrest on 13-4-21.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic)  UITextView *noteTextView;

- (void)configureView;
@end

@implementation DetailViewController
@synthesize noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        UITextView *v= [[UITextView alloc] initWithFrame:CGRectZero];
        self.noteTextView = v;
        self.noteTextView.delegate = self;
        [self.view addSubview:self.noteTextView];

    }
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.noteTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    DLog(@"%s",__PRETTY_FUNCTION__);
    [textView scrollRangeToVisible: range];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    DLog(@"%s",__PRETTY_FUNCTION__);
    //    [UIView animateWithDuration:.3 animations:^{
    //        self.noteTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.2);
    //    }];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

- (BOOL)isEmptyNote{
    return (self.noteTextView.text.length == 0 );
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    DLog(@"%s",__PRETTY_FUNCTION__);

    if (_detailItem && [self isEmptyNote]==NO ) {
        [_detailItem setValue:textView.text forKey:@"content"];
        NSArray *stringArray = [textView.text componentsSeparatedByString:@"\n"];
        NSString *possibleTitle = [stringArray objectAtIndex:0];
        [_detailItem setValue:possibleTitle forKey:@"title"];
    }
}

- (void)hideKeyboard{
    [self.noteTextView endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
        self.noteTextView.text = [self.detailItem valueForKey:@"content"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.noteTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.noteTextView endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.noteTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noteTextView.frame = self.view.bounds;
    self.noteTextView.backgroundColor = [UIColor whiteColor];
    [self.noteTextView setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:18]];

    [self configureView];
    
    UIBarButtonItem *keyBoardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    self.navigationItem.rightBarButtonItem = keyBoardButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    DLog(@"%s",__PRETTY_FUNCTION__);
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:.3 animations:^{
        self.noteTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
    }];
}
- (void) keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:.3 animations:^{
        self.noteTextView.frame = self.view.frame;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
