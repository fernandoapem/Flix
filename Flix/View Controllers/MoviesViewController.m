//
//  MoviesViewController.m
//  Flix
//
//  Created by Fernando Arturo Perez on 6/24/20.
//  Copyright © 2020 Fernando Arturo Perez. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName :UIColor.systemYellowColor};
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}
- (UIAlertController *)startAlert{
    NSString *title = @"Cannot Get Movies";
    NSString *notice = @"The internet connection appears to be offline.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:notice preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
        [self fetchMovies];
    }];
    
    [alert addAction:tryAgainAction];
    
    return alert;
}
- (void)fetchMovies {
    [self.loadingActivityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self.loadingActivityIndicator stopAnimating];
        
        
        if (error != nil) {
            UIAlertController *alert = [self startAlert];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            self.movies = dataDictionary[@"results"];
            
            [self.tableView reloadData];
            
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.grayColor;
    cell.selectedBackgroundView = backgroundView;
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLStr = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLStr = movie[@"poster_path"];
    NSString *fullPosterURLStr = [baseURLStr stringByAppendingString:posterURLStr];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLStr];
    cell.posterView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    __weak MovieCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
            weakSelf.posterView.alpha = 0.0;
            weakSelf.posterView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.posterView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Image was cached so just update the image");
            weakSelf.posterView.image = image;
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        NSLog(@"Failed request");
    }];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


@end
