# Despenso iOS app

This project has the current implementation of the Despenso app, to record your groceries lists, it's meanto to be run on iOS 13.3 devices and above.

It uses SwitfUI definitions, and tries to abstract the logic out of the views.

## Required permissions

Since this App's main way of interacting with the user is through speech, microphone permissions are required.

## Testing

The app has Unit tests, that are manually mocked if encessary. There's a level to which tests no longer occurr, and it's defined at the Core group, which is the lowest level interaction with the Framework. If we went a level deepere, we'd need to mock the Framework classes which is currently not supported by Swift and the lack of reflection as in other languages.

In my experience, there's no point in testing exact calls to functions in classes, since that is kind of programming the actual implementation, which makes brittle tests. Tests in for the perspective of this project, work best if oriented into the expected behavior of the code.

## ToDos

- [x] Allow for audio input of the list
- [ ] Show list of groceries within the app
- [ ] Allow for basic management of the list
  - [ ] Setting up amount of items
  - [ ] Deleting items
  - [ ] Updating items: name, quantity, buy time, price, store
- [ ] Add unit tests
- [ ] Add UI tests
- [ ] Upload audio recordings
