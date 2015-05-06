basic geom classes:
**Bezier, Line, Intersection.**

There are two methods, that are used in ActionScript drawing: _lineTo()_ and _curveTo()_ and realize sengment and Bezier second-order curve drawing correspondingly.

There are tools in Flash IDE to draw curves with Bezier third-order curves, but during the compilation process they are approximated with second-order curves.

As the result, all shapes in compiled SWF-file become segments or Bezier second-order curves.

That's why we encounter a group of tasks, that need mathematical engine to work with segments and Bezier second-order curves.