# PETRO App - BeReal for Pets

This app is built with Flutter + Firebase.

## Features
- Firebase Auth login/register
- User profile with photo
- Pet photo gallery (like BeReal)
- UID-based friend adding
- Modern minimalist UI

## Tech Stack
- Flutter
- Firebase (Auth, Firestore, Storage)
- Dart

## To Do
- [ ] Friend request system
- [ ] Realtime notifications
- [ ] Upload camera shots to gallery

## Current Firebase Collections
- users/{uid} → name, email, uid
- posts/{docId} → userId, imageUrl, createdAt
