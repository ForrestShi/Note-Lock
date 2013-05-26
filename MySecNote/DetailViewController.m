//
//  DetailViewController.m
//  MySecNote
//
//  Created by forrest on 13-4-21.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteView.h"
#import "GCPlaceholderTextView.h"


@interface DetailViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic)  GCPlaceholderTextView *noteTextView;

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
        GCPlaceholderTextView *v = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.)];
        self.noteTextView = v;
        self.noteTextView.backgroundColor = [UIColor whiteColor];
        [self.noteTextView setFont:[UIFont fontWithName:@"Helvetica-Light" size:20]];
        self.noteTextView.delegate = self;
        self.noteTextView.alpha = 0.;
        [self.view addSubview:self.noteTextView];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        UISwipeGestureRecognizer *swip1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        swip1.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swip1];
        
        UISwipeGestureRecognizer *swip2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        swip2.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swip2];
        
        UISwipeGestureRecognizer *swip3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        swip3.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swip3];
        
        UISwipeGestureRecognizer *swip4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        swip4.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:swip4];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observePinView) name:kShowLoginView object:nil];


    }
    return self;
}
- (void)swip:(UISwipeGestureRecognizer*)gesture{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)observePinView{
    DLog(@"detected");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

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

- (BOOL)isEmptyNote{
    return (self.noteTextView.text.length == 0 );
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_detailItem && [self isEmptyNote]== NO ) {
        [_detailItem setValue:textView.text forKey:@"content"];
        NSArray *stringArray = [textView.text componentsSeparatedByString:@"\n"];
        NSString *possibleTitle = [stringArray objectAtIndex:0];
        [_detailItem setValue:possibleTitle forKey:@"title"];
    }else{
        [_detailItem setValue:@"Empty" forKey:@"title"];
    }
}

- (void)assignEmptyNoteTitle{
    if (_detailItem && [self isEmptyNote] ) {
        [_detailItem setValue:@"Empty" forKey:@"title"];
    }
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
        NSString *noteText = [self.detailItem valueForKey:@"content"];
        self.noteTextView.text = noteText;
        if (noteText.length == 0 ) {
            [self.noteTextView setPlaceholder:@"Title"];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.noteTextView.alpha = 1.;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.noteTextView resignFirstResponder];
    [self assignEmptyNoteTitle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];    
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
