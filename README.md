# Angular-Firechat

Simple chatting app built using **[AngularJS](https://angularjs.org)** and **[Firechat](https://github.com/firebase/firechat)**, dully named **Angular-Firechat** due to lack of creativity (might use a hipster name in the future, like *Orange* or *Banana*).

## Setup

Clone this project, then run

```
npm install
bower install
```

## Demo

To run the app

```
gulp serve
```

or run a simple server using `dist` folder as root. For example, if PHP is installed, navigate to `dist` folder then run

```
php -S localhost:9000
```

## Features

The objective of version 1.0 is to implement the core of the app. That is, the ability for users to authenticate and then communicate. In order to achieve that, the following features are implemented:

1. User registration
2. User login
3. Retrieve a list of chat rooms associated with current user
4. Creation of a chat room
5. Enter and exit chat room 
6. Sending a message inside a chat room
7. Sending an invitation to another user to join a chat room
8. Retrieve a list of invitations addressed to current user
9. Accept/decline an invitation

Interactivity is achieved by simply alerting user for successes and errors using `toastr` plugin. 

Current UI uses minimum styling just to make it human-usable. Its layout was built for mobile device screen size.

## Known Issues

Edge cases, malformed inputs, and other not-so-core functions that make a fully fledged chatting app are yet to be covered. Among them are:

- Not able to logout
- Able to invite oneself into one's own room
- Yet to use refresh token
- Other minor UI quirks


