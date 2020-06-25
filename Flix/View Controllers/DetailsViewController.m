//
//  DetailsViewController.m
//  Flix
//
//  Created by Fernando Arturo Perez on 6/25/20.
//  Copyright © 2020 Fernando Arturo Perez. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loadingActivityIndicator startAnimating];
    
    NSString *baseURLStr = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLStr = self.movie[@"poster_path"];
    NSString *fullPosterURLStr = [baseURLStr stringByAppendingString:posterURLStr];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLStr];
    
    [self.posterView setImageWithURL:posterURL];
    

    NSString *backdropURLStr = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLStr = [baseURLStr stringByAppendingString:backdropURLStr];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLStr];
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    [self.loadingActivityIndicator stopAnimating];
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
