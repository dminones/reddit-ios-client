# Reddit iOS Client
A simple Reddit client that shows the top 50 entries from www.reddit.com/top.

## Features

### The app should be able to show data from each entry such as:

- Title (at its full length, so take this into account when sizing your cells)
- Author
- entry date, following a format like “x hours ago” 
- A thumbnail for those who have a picture.
- Number of comments
- User can tap on the thumbnail to be sent to the full sized picture. Just opening the url from preview at the moment

### Also includes:

- Pagination support
- Saving pictures in the picture gallery
- App state-preservation/restoration
- Support iPhone 6/ 6+ screen size
- Pull to Refresh

### Design Guidelines:

- Assume the latest platform and use Swift
- Use UITableView / UICollectionView to arrange the data.
- Please refrain from using AFNetworking, instead use NSURLSession 
- Support Landscape
- Use Storyboards
