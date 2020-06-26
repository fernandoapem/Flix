//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Fernando Arturo Perez on 6/25/20.
//  Copyright © 2020 Fernando Arturo Perez. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName :UIColor.systemYellowColor};
    self.movieCollectionView.dataSource = self;
    self.movieCollectionView.delegate = self;
    self.movieSearchBar.delegate = self;
    
    [self fetchMovies];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.movieCollectionView.collectionViewLayout;
    
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.movieCollectionView.frame.size.width - layout.minimumInteritemSpacing* (postersPerLine-1))/postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
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
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
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
            self.filteredMovies = self.movies;
            
            //            NSLog(@"%@",self.movies[0][@"title"]);
            
        }
        [self.movieCollectionView reloadData];
    }];
    [task resume];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        // NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.movieCollectionView reloadData];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.movieSearchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.movieSearchBar.showsCancelButton = NO;
    self.movieSearchBar.text = @"";
    [self.movieSearchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedPoster = sender;
    NSIndexPath *indexPath = [self.movieCollectionView indexPathForCell:tappedPoster];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [self.movieCollectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    NSString *baseURLStr = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLStr = movie[@"poster_path"];
    NSString *fullPosterURLStr = [baseURLStr stringByAppendingString:posterURLStr];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLStr];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}


@end
