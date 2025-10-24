## My priorities

- I started exploring the code and made an idea on what can be done. I started with refactoring the structure, improving blocs, widget structure, a bit of DI cleanup, and error handling. Reviewing my changes commit by commit follows my priorities and line of thought.
- In between I added the details screen and tweaked the hero animation
- Did some visual changes in terms of padding

## What else I would change?

- Provide Blocs via getIt - Won’t need to handle construction of blocs as dependencies would be automatically resolved. Developers won’t need to modify the call to the Bloc constructor if they add new params to it.
- Separate UI and API models. For simple projects I prefer the pragmatic approach of using the API models all the way to the UI layer. From an architectural perspective this is flawed as it creates a tight dependency between the two layers. Mapping API Models to UI models would fix this but it makes sense when the project complexity increases significantly
- I would use Segmented state pattern for states as described here: https://chililabs.io/blog/segmented-state-pattern-with-delayed-result
- Localization approach can be improved. Didn’t check it very well but having an enum for each string is bad. Adding a string to arb files should automatically generate usable keys. I like the approach of being able to use localized strings in blocs as it doesn’t depend on the context directly.
- Maybe placeholders for loading images

## Other bugs not fixed:

- The RippleEffect doesn’t work, didn’t properly understood its purpose. Would make sense on other types of buttons, not images.
- Seeing an error of images folder not being found

## Visuals

- It doesn’t look too great to be honest. Having just a list of images in an app I can’t think of visual changes as I don’t know the purpose of it.
- I would use a proper theme first of all.

## Time spent

- I’ve worked throughout the day, in paralel with my daily tasks at work, roughly 3-4 hours of focus for this exercise.




## I’ve used AI as I do in my daily work. Here are the prompts:

### Task 1 - refactor Bloc Architecture

Analyze the BLoC implementation in the `/lib/screens/home/` directory. The current architecture is incorrectly implemented - it uses raw streams to update the UI instead of following proper BLoC pattern conventions.

Tasks:

1. Review all files in the `lib/screens/home/` directory to understand the current implementation
2. Fetch and review the official BLoC documentation at https://bloclibrary.dev/flutter-bloc-concepts/ to understand the correct architecture patterns
3. Identify the specific architectural flaws:
   - Check if the BLoC is using raw StreamControllers instead of proper event/state pattern
   - Verify if events are being used to trigger state changes
   - Check if states are properly defined and emitted
   - Ensure the UI is using BlocBuilder, BlocListener, or BlocConsumer widgets appropriately
4. Refactor the home screen BLoC implementation to follow the proper flutter_bloc architecture:
   - Define clear Event classes for all user actions
   - Define clear State classes for all UI states
   - Implement proper event handlers using `on<Event>()` method
   - Use `emit()` to emit new states instead of directly adding to streams
   - Update the UI layer to properly consume BLoC states using appropriate widgets
5. Ensure the refactored code follows Flutter and Dart best practices
6. Maintain all existing functionality while improving the architecture

Do not create new test files unless explicitly requested.

### Task 2 - Simplify widget structure

Refactor the `_PhotosSectionContent` and `_PhotoItem` widgets in `lib/screens/home/home_screen.dart` to improve the widget structure and implementation:

1. Replace the current manual row-based layout in `_PhotosSectionContent` with a proper `GridView` widget (such as `GridView.builder` or `GridView.count`) to display the photo items
2. Remove the `isLeftItem` parameter from the `_PhotoItem` widget constructor and its usage, as the grid layout will handle positioning automatically
3. Update the `_PhotoItem` widget implementation to work without the `isLeftItem` parameter, removing any conditional logic that depends on it
4. Ensure the grid maintains the same visual appearance (2-column layout) as the current implementation
5. Preserve all existing functionality including tap handlers, image loading, and any other interactive features

The goal is to simplify the code by using Flutter's built-in grid layout capabilities instead of manually managing item positioning.

### Task 3 - details screen

Implement photo detail navigation with the following requirements:

1. **Current State**: Tapping on a photo in the home screen currently has no action
2. **Required Implementation**:
   - Add tap handling to photo items in the home screen
   - Navigate to a new photo details screen when a photo is tapped
   - Pass the selected photo data to the details screen
3. **Details Screen Layout**:
   - Display the photo image at full width of the screen
   - Show the photo description below the image in a well-formatted, readable text style
   - Ensure proper spacing and padding for good visual presentation
4. **Animation**:
   - Implement a Hero animation that transitions the photo from the home screen thumbnail to the full-width image on the details screen
   - Use matching Hero tags to create a smooth visual transition
5. **Navigation**:
   - Maintain the existing navigation patterns and architecture used in the codebase
   - Ensure the back navigation works properly to return to the home screen
   - Follow the project's existing routing conventions (e.g., if using named routes, GoRouter, Navigator 2.0, etc.)
6. **Code Organization**:
   - Create the details screen in an appropriate location following the project's folder structure
   - Keep code clean and follow existing patterns in the codebase

#### Part 2:

Fix the Hero animation issue when navigating to the photo detail screen.

**Problem**:
- The Hero animation from home screen to detail screen only works on the second tap for most photos
- Some photos appear to have no Hero animation at all
- This is likely caused by the full-resolution image not being loaded yet when the Hero animation starts
- The home screen uses `photo.urls.thumb` while the detail screen uses `photo.urls.full`

**Required Fix**:
In the PhotoDetailScreen (`lib/screens/photo_detail/photo_detail_screen.dart`):
- Modify the CachedNetworkImage inside the Hero widget to use the thumbnail (`photo.urls.thumb`) as a placeholder while the full-resolution image (`photo.urls.full`) loads
- Use the `placeholder` parameter of CachedNetworkImage to show the thumbnail image during loading
- This will ensure the Hero animation is smooth because the thumbnail is already cached from the home screen
- The full-resolution image should fade in once loaded, replacing the thumbnail

**Note**: The back navigation Hero animation already works correctly and should not be affected by this change.

### Task 4 - error handling
#### Note: this didn’t work very well with AI, improved it a lot after AI’s work, still not happy with it but committed it anyway


Add proper error handling to the HomeBloc located at `lib/blocs/home_bloc.dart` to handle failures from the photos API.

Requirements:

1. Catch and handle errors when the photos API call fails in the HomeBloc
2. Display error messages to the user using localized strings (use the existing localization system in the project)
3. If the photos API (`lib/data/api/photos_api.dart`) doesn't currently propagate errors properly, modify it to throw or return appropriate error information
4. Ensure the error state is properly represented in the bloc's state management
5. Keep all changes minimal and simple - only modify what's necessary for basic error handling

Constraints:

- Prefer the simplest solution that works with the existing architecture
- Minimize the number of files changed
- Follow existing patterns in the codebase for error handling and localization
- Do not create new files unless absolutely necessary
- Do not write tests unless explicitly asked
