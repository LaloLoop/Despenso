# Despenso iOS app

This project has the current implementation of the Despenso app, to record your groceries lists, it's mean to to be run on iOS 13.3 devices and above.

It uses SwitfUI definitions, and tries to abstract the logic out of the views.

## Required permissions

Since this App's main way of interacting with the user is through speech, microphone permissions are required.

## Testing

The app has Unit and UI tests.

For unit tests some dependencies are manually mocked if necessary. There's a level to which tests no longer occur, and it's defined at the [Core group](Despenso/Core/), which is the lowest level interaction with the Framework. If we went a level deeper, we'd need to mock the Framework classes which is currently not supported by Swift and its lack of reflection available in other languages.

In my experience, there's no point in testing exact calls to functions in classes, since that is kind of testing the actual implementation, which makes brittle tests. Tests in the perspective of this project, work best if oriented into the expected behavior of the code.

UI tests with run without mocking, which make them more like E2E tests.

## ToDos

- [x] Allow for audio input of the list
- [ ] Show list of groceries within the app
- [ ] Allow for basic management of the list
  - [ ] Setting up amount of items
  - [ ] Deleting items
  - [ ] Updating items: name, quantity, buy time, price, store
- [x] Add unit tests
- [x] Add UI tests
- [ ] Upload audio recordings
