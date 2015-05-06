# Constructor #

```
public function Line(start:Point=undefined, end:Point=undefined, isSegment:Boolean=true)
```

# Properties #
### description ###
```
public function get start ():Point
public function set start (value:Point):void

public function get end ():Point
public function set end (value:Point):void

public function get isSegment ():Boolean
public function set isSegment (value:Boolean):void
```

### geom properties ###
```
public function get angle():Number
public function set angle(rad:Number):void

public function get length():Number
public function get bounds ():Rectangle
```

# Methods #

```
public function getSegmentLength(time:Number):Number
public function getSegment (fromTime:Number=0, toTime:Number=1):Line

public function getPoint(time:Number):Point
public function setPoint(time:Number, x:Number=undefined, y:Number=undefined):void

public function angleOffset(value:Number, fulcrum:Point=null):void
public function offset(dx:Number, dy:Number):void

public function getClosest(fromPoint:Point):Number
public function getTimeByDistance (distance:Number):Number
public function getTimesSequence (step:Number, startShift:Number=0):Array
```

### intersections ###
```
public function intersectionLine (line:Line):Intersection
public function intersectionBezier (target:Bezier):Intersection
```

### other ###
```
public function clone ():Line
public function toString ():String
```