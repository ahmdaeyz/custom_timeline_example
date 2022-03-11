# custom_timeline_example

A Flutter app to demonstrate the usage of CustomPainter, flutter_boxy, and staggered animations.
#
## Demo


https://user-images.githubusercontent.com/36048466/157918508-535f68d5-349b-49bc-b271-25b31aefae54.mp4


#
## Challenges

- Deciding which way should I use to create the connectors with `CustomPainter` was crucial. I ended up using a `Rect` to draw the arcs.
- Gluing the connectors with the card widget was tricky and I decided I should try using boxy since I need to know the size and position of the elements of the layout.
- Animating the connectors was quite tricky because it consisted of two parts (the line and the arc).

#### Have a suggestion to refactor? create an issue!

#
## References

- [`CustomPainter` vs `ClipPath`](http://blog.geveo.com/Flutter-Custom-Paint-and-Clip-Path-for-highly-customized-UI-design) 

- [`CustomPainter` explained with examples](https://morioh.com/p/40f3c0ad1f33) 

- [Draw a dashed paths with `CustomPainter`](https://stackoverflow.com/a/71099304/9297478)

- [Animating a `CustomPainter`.](https://codewithandrea.com/articles/flutter-drawing-with-custom-painter/)

- [Staggered (Sequential/overlapping) animations.](https://docs.flutter.dev/development/ui/animations/staggered-animations)


#
For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
