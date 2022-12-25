<p align="center">
  <a href="https://flutter.io/">
    <img src="https://cdn.icon-icons.com/icons2/2107/PNG/512/file_type_flutter_icon_130599.png" alt="Logo" width=72 height=72>
  </a>

  <h3 align="center">Flutter Shop App</h3>

  <p align="center">
    Shop app with Flutter that uses Firebase
    <br>
    Project made following Maximilian Schwarzmüller's <a href="https://pro.academind.com/p/learn-flutter-dart-to-build-ios-android-apps-2020">Academind Flutter Course</a> 🎯
    <br>
    <br>
    
  </p>
</p>

<p>
<img src="https://i.imgur.com/P2plCR6.png" alt="app 1" width="250"/><img src="https://i.imgur.com/hlthFek.png" alt="app 1" width="250"/><img src="https://i.imgur.com/9y088xW.png" alt="app 1" width="250"/><img src="https://i.imgur.com/3WVpv4Z.png" alt="app 1" width="250"/><img src="https://i.imgur.com/WYpVKsG.png" alt="app 1" width="250"/>
</p>

## Quickstart

Get the Flutter Sdk: [official documentation](https://flutter.dev/docs/get-started/install).

Clone this repository:
```
git clone https://github.com/lastra-dev/flutter-shop-app/
```

Get dependencies inside the project directory:
```
flutter pub get
```
Create a Firebase project with email authentication  
Make .env file with your [Firebase Realtime Database](https://firebase.google.com/docs/database) URL and your Firebase project WEB API KEY (see .env.example)


## What's included

* CRUD: create, read, update and delete operations with Firebase!
* Responsive layout
* Linting with 'Linter' dart package
* Environment variables with 'flutter_dotenv' dart package
* Async HTTP requests to Firebase REST API with HTTP dart package (You should use the firebase package instead. I used HTTP package to learn how to work with different backends)
* Animations: Hero, SlideTransition and FadeTransition

### Firebase

This repo is using Firebase. It uses the Realtime Database to save user products and orders and authentication to signup users to the app.

### Animations
I use AnimationControllers, AnimationContainers, and route animations to run these animations:
* Hero Animation
* SlideTransition
* FadeTransition
