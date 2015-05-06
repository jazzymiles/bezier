# Constructor #

```
public function Bezier(start:Point=undefined, control:Point=undefined, end:Point=undefined, isSegment:Boolean=true):void
```

# Properties #
### description ###
```
public function get start ():Point
public function set start (value:Point):void

public function get control ():Point
public function set control (value:Point):void

public function get end ():Point
public function set end (value:Point):void

public function get isSegment ():Boolean
public function set isSegment (value:Boolean):void
```

### geom properties ###
```
public function get length():Number

public function get area ():Number
public function get triangleArea ():Number

public function get bounds ():Rectangle

public function get parabolaVertex():Number
public function get parabolaFocusPoint():Point
```

# Methods #

```
public function getSegmentLength(time:Number):Number
public function getSegment (fromTime:Number=0, toTime:Number=1):Bezier

public function getPoint(time:Number):Point
public function setPoint(time:Number, x:Number=undefined, y:Number=undefined):void

public function angleOffset(value:Number, fulcrum:Point=null):void
public function offset(dx:Number, dy:Number):void

public function getClosest(fromPoint:Point):Number
public function getTimeByDistance (distance:Number):Number
public function getTimesSequence (step:Number, startShift:Number=0):Array

public function getTangentAngle(time:Number=0):Number
```

### intersections ###
```
public function intersectionLine (line:Line):Intersection
public function intersectionBezier (target:Bezier):Intersection
```

### other ###
```
public function toString ():String
```