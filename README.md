# RickAndMorty
## App
This app has two screen:
- First screen to show a list of characters.
- Second screen to show a list of episodes where the character appears.

## Architecture
The app has been developed in Swift using MVVM-C architecture.
### Dependency injection based in protocols
To build the screens, dependency injection based in protocols is used to make it easier to create them.
### Concurrency
To manage the concurrency and the requests to the server, the app uses async/await functions.
### View updates
To update the view with the different states provided by the view model, the view suscribes to publishers in the bind function.
## External libraries
Kingfisher is used to download and cache the character images previously downloaded.
