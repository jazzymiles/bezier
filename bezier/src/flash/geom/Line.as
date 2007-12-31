// UTF-8
package flash.geom {

	/**
	 * Класс Line представляет линию в параметрическом представлении, 
	 * задаваемую точками на плоскости <code>start</code> и <code>end</code>
	 * и реализован в поддержку встроенного метода <code>lineTo()</code>.<BR/>
	 * В классе реализованы свойства и методы, предоставляющие доступ к основным 
	 * геометрическим свойствам линии.<BR/>
	 * Точки, принадлежащие линии определяются их time-итератором. 
	 * Итератор <code>t</code> точки на линии <code>P<sub>t</sub></code> равен отношению 
	 * расстояния от точки <code>P<sub>t</sub></code> до стартоврой точки <code>S</code> 
	 * к расстоянию от конечной точки <code>E</code> до стартовой точки <code>S</code>.  
	 * <BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Bezier
	 * @see Intersection
	 */
	public class Line extends Object implements IParametric {

		
		protected const PRECISION:Number = 1e-10;

		protected var __start:Point;
		protected var __end:Point;
		protected var __isSegment:Boolean;

		public function Line(start:Point = undefined, end:Point = undefined, isSegment:Boolean = true) {
			this.start = (start as Point) || new Point();
			this.end = (end as Point) || new Point();
			this.isSegment = isSegment;
		}

		/*
		 * Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах, 
		 * start, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		 */

		/**
		 * Начальная опорная (anchor) точка отрезка. Итератор <code>time</code> равен нулю.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function get start():Point {
			return __start;
		}

		public function set start(value:Point):void {
			__start = value;
		}

		/**
		 * Конечная опорная (anchor) точка отрезка. Итератор <code>time</code> равен единице.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function get end():Point {
			return __end;
		}

		public function set end(value:Point):void {
			__end = value;
		}

		/**
		 * Определяет является ли линия бесконечной в обе стороны
		 * или ограничена в пределах итераторов от 0 до 1.<BR/>
		 * <BR/>
		 * <BR/>
		 * Текущее значение isSegment влияет на результаты методов:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
		 * 
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function get isSegment():Boolean {
			return __isSegment;
		}

		public function set isSegment(value:Boolean):void {
			__isSegment = Boolean(value);
		}

		/**
		 * 
		 * @return Line копия текущего объекта Line.  
		 */		

		public function clone():Line {
			return new Line(start.clone(), end.clone(), isSegment);
		}

		/**
		 * Угол наклона линии в радианах.
		 * Поворот осуществляется относительно точки <code>start</code>.
		 * Возвращаемое значение находится в пределах от положительного PI до отрицательного PI;
		 * 
		 **/
		public function get angle():Number {
			return Math.atan2(end.y - start.y, end.x - start.x);
		}

		public function set angle(rad:Number):void {
			var distance:Number = Point.distance(start, end);
			var polar:Point = Point.polar(distance, rad);
			end.x = start.x + polar.x;
			end.y = start.y + polar.y; 
		}

		/**
		 * Поворачивает линию относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0);
		 * @param value:Number угол поворота в радианах
		 * @param fulcrum:Point центр вращения. 
		 * Если параметр не определен, центром вращения является точка <code>start</code>
		 */

		public function angleOffset(rad:Number, fulcrum:Point = null):void {
			fulcrum = fulcrum || new Point();
			var startLine:Line = new Line(fulcrum, start);
			startLine.angle += rad;
			var endLine:Line = new Line(fulcrum, end);
			endLine.angle += rad;
		}

		/**
		 * Смещает линию на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 * 
		 */		
		public function offset(dx:Number, dy:Number):void {
			start.offset(dx, dy);
			end.offset(dx, dy);
		}

		/**
		 * Вычисляет и возвращает длину отрезка <code>start</code>-<code>end</code>.
		 * Возвращаемое число всегда положительное значение; 
		 * @return Number;
		 **/
		public function get length():Number {
			return Point.distance(start, end); 
		}

		/**
		 * Вычисляет и возвращает точку на линии, заданную time-итератором.
		 * @param time time-итератор
		 * @return Point точка на линии
		 * 
		 */		

		public function getPoint(time:Number):Point {
			var x:Number = start.x + (end.x - start.x)*time;
			var y:Number = start.y + (end.y - start.y)*time;
			return new Point(x, y);
		}

		/**
		 * Вычисляет и возвращает time-итератор точки находящейся на заданной дистанции по линии от точки start. 
		 * @param distance:Number
		 * @return Number
		 * 
		 */		
		public function getTimeByDistance(distance:Number):Number {
			return distance/Point.distance(start, end);
		}

		/**
		 * Изменяет позицию точки <code>end</code> таким образром, 
		 * что точка <code>P<sub>time</sub></code> станет в координаты,
		 * заданные параметрами <code>x</code> и <code>y</code>.
		 * Если параметр <code>x</code> или <code>y</code> не определен,
		 * значение соответствующей координаты точки <code>P<sub>time</sub></code>
		 * не изменится. 
		 * @param time
		 * @param x
		 * @param y
		 * 
		 */		

		public function setPoint(time:Number, x:Number = undefined, y:Number = undefined):void {
			if (isNaN(x) && isNaN(y)) {
				return;
			}
			var point:Point = getPoint(time);
			if (!isNaN(x)) {
				point.x = x;
			}
			if (!isNaN(y)) {
				point.y = y;
			}
			end.x = point.x + (point.x - start.x)*((1 - time)/time);
			end.y = point.y + (point.y - start.y)*((1 - time)/time);
		}

		/**
		 * Возвращает габаритный прямоугольник объекта. 
		 **/

		public function get bounds():Rectangle {
			var xMin:Number = Math.min(start.x, end.x);
			var xMax:Number = Math.max(start.x, end.x);
			var yMin:Number = Math.min(start.y, end.y);
			var yMax:Number = Math.max(start.y, end.y);
			var width:Number = xMax - xMin;
			var height:Number = yMax - yMin;
			return new Rectangle(xMin, yMin, width, height);
		}

		
		/**
		 * Возвращает отрезок - сегмент линии, заданный начальным и конечным итераторами.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Line 
		 * 
		 */		

		public function getSegment(fromTime:Number = 0, toTime:Number = 1):Line {
			return new Line(getPoint(fromTime), getPoint(toTime));
		}

		/**
		 * Возвращает длину сегмента линии от точки <code>start</code> 
		 * до точки на линии, заданной time-итератором.
		 *  
		 * @param time - итератор точки.
		 * 
		 * @return Number 
		 * 
		 */		
		public function getSegmentLength(time:Number):Number {
			return Point.distance(start, getPoint(time));
		}

		/**
		 * Вычисляет и возвращает массив точек на линии удаленных друг от друга на 
		 * расстояние, заданное параметром <code>step</code>.<BR/>
		 * Перавя точка массива будет смещена от стартовой точки на расстояние, 
		 * заданное параметром <code>startShift</code>. 
		 * При этом, если значение <code>startShift</code> превышает значение
		 * <code>step</code>, будет использован остаток от деления на <code>step</code>.<BR/>
		 * <BR/>
		 * Типичное применение данного метода - вычисление последовательности точек 
		 * для рисования пунктирных линий. 
		 * 
		 * @param step
		 * @param startShift
		 * @return 
		 * 
		 */
		public function getTimesSequence(step:Number, startShift:Number = 0):Array {
			step = Math.abs(step);
			var distance:Number = (startShift%step + step)%step;
			
			var times:Array = new Array();
			var lineLength:Number = Point.distance(start, end);
			if (distance > lineLength) {
				return times;
			}
			var timeStep:Number = step/lineLength;
			var time:Number = getTimeByDistance(distance);
			
			while (time <= 1) {
				times[times.length] = time;
				time += timeStep;
			}
			return times;
		}

		/**
		 * Вычисляет и возвращает пересечение двух линий.
		 * @param line:Line
		 * @return Intersection;
		 * 
		 * @see #isSegment
		 */

		public function intersectionLine(targetLine:Line):Intersection {
			// checkBounds
			if (isSegment && targetLine.isSegment) {
				var fxMax:Number = Math.max(start.x, end.x);
				var fyMax:Number = Math.max(start.y, end.y);
				var fxMin:Number = Math.min(start.x, end.x);
				var fyMin:Number = Math.min(start.y, end.y);
				
				var sxMax:Number = Math.max(targetLine.start.x, targetLine.end.x);
				var syMax:Number = Math.max(targetLine.start.y, targetLine.end.y);
				var sxMin:Number = Math.min(targetLine.start.x, targetLine.end.x);
				var syMin:Number = Math.min(targetLine.start.y, targetLine.end.y);
		
				if (fxMax < sxMin || sxMax < fxMin || fyMax < syMin || syMax < fyMin) { 
					// no intersection
					return null;  
				} 
			}
			// end check bounds

			var intersection:Intersection;
			
			var fseX:Number = end.x - start.x;
			var fseY:Number = end.y - start.y;
			
			var sseX:Number = targetLine.end.x - targetLine.start.x;
			var sseY:Number = targetLine.end.y - targetLine.start.y;
			
			var sfsX:Number = start.x - targetLine.start.x;
			var sfsY:Number = start.y - targetLine.start.y;
			
			
			var denominator:Number = fseX*sseY - fseY*sseX;
			var a:Number = sseX*sfsY - sfsX*sseY;
			
			if (denominator == 0) { 
				if (a == 0) { 
					// TODO: new coincident type
					// coincident
//					var sfeX:Number = start.x - targetLine.end.x;
//					var sfeY:Number = start.y - targetLine.end.y;
//					var startTime:Number = -(sfsX/fseX || sfsY/fseY) || 0;
//					var endTime:Number = -(sfeX/fseX || sfeY/fseY) || 0;
//					
//					var order_array:Array = [new OrderedPoint(0, start),
//						new OrderedPoint(1, end),
//						new OrderedPoint(startTime, targetLine.start),
//						new OrderedPoint(endTime, targetLine.end)];
//					order_array.sortOn(OrderedPoint.TIME, Array.NUMERIC);
//					
//					var startOrdered:OrderedPoint = order_array[1];
//					var endOrdered:OrderedPoint = order_array[2];
					
					intersection = new Intersection();
					intersection.isCoincidence = true;
					// intersection.coincidenceLine = new Line(startOrdered.point, endOrdered.point);
					return intersection;
				} else { 
					// parallel
					return null;
				}
			}
			
			var currentTime:Number = a/denominator;
			if (isSegment) {
				if (currentTime < 0 || currentTime > 1) { 
					// no intersection
					return null;
				}
			}
			
			var b:Number = fseX*sfsY - sfsX*fseY;
			var oppositeTime:Number = b/denominator;
			if (targetLine.isSegment) {
				if (oppositeTime < 0 || oppositeTime > 1) { 
					// no intersection
					return null;
				}
			}

			intersection = new Intersection();
			intersection.currentTimes[0] = currentTime;
			intersection.targetTimes[0] = oppositeTime;
			return intersection;
		}

		
		/**
		 * Вычисляет и возвращает пересечение с Bezier;
		 * @param target:Bezier
		 * @return 
		 * 
		 */		
		public function intersectionBezier(target:Bezier):Intersection {
			var intersection:Intersection = new Intersection();
			target;
			return intersection;
		}

		/**
		 * Вычисляет и возвращает точку на линии, ближайшую к заданной.
		 * @param fromPoint:Point - произвольная точка.
		 * @return Number - time-итератор точки на линии.
		 * @see isSegment
		 */

		public function getClosest(fromPoint:Point):Number {
			var from_distance:Number = Point.distance(start, fromPoint);
			var from_angle:Number = Math.atan2(start.y - end.y, start.x - end.x);
			var difference:Number = from_angle - angle;
			var distance:Number = from_distance*Math.cos(difference);
			var time:Number = distance/length;
			if (!isSegment) {
				return time;
			}
			if(time < 0) {
				return 0;
			}
			if (time > 1) {
				return 1;
			}
			return time;
		}

		
		
		//**************************************************
		//				UTILS 
		//**************************************************
		/**
		 * 
		 * @return 
		 * 
		 */
		public function toString():String {
			return 	"(start:" + start + ", end:" + end + ")";
		}
	}
}

import flash.geom.Point;

class OrderedPoint {

	public static var TIME:String = "time";

	public var time:Number;
	public var point:Point;

	public function OrderedPoint(timeValue:Number, pt:Point) {
		this.time = timeValue;
		this.point = pt.clone();
	}
}
