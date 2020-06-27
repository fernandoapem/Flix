# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **13** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Customize the UI.


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.The Search Bar Feature

2.Collection Views

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/d5QS1DvdVm.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='http://g.recordit.co/JuCzPiokea.gif' title='Video Walkthrough2' width='' alt='Video Walkthrough2' />

Here's a screenshot of the network error message feature:

<img src = 'http://g.recordit.co/04rpMbSonl.gif' title='Network Error' width='' alt='Network Error'/>

GIF created with [RecordIt](https://recordit.co/).

## Notes

Describe any challenges encountered while building the app.

-Implementing the Search Bar Feature

-Initially working with the Collection View

-Ensuring the highlight selection when a cell is tapped dissipates after it's either selected or not longer tapped

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [The Movie Database](https://developers.themoviedb.org/) - movie database api

## License

    Copyright [2020] [Fernando Perez]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
