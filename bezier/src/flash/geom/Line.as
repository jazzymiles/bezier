// UTF-8
// translator: Flastar http://flastar.110mb.com

package flash.geom 
{

	/* *
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
	 * <BR/>
	 * Многие методы класса Line унифицированы по названию и параметрам с аналогичными методами класса Bezier.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Bezier
	 * @see Intersection
	 */
	 
	/**
	 * Class Line introdaction line at parametrical introduction, 
	 * given by points on plane <code>start</code> and <code>end</code>
	 * and realized to support internal method <code>lineTo()</code>.<BR/>
	 * At class realized properties and methods, they help you take access to basic 
	 * geometry properties of line.<BR/>
	 * Points, belongs to line defines by time-iterator. 
	 * Interator <code>t</code> points on line <code>P<sub>t</sub></code> equally bearing 
	 * distance from point <code>P<sub>t</sub></code> at start point <code>S</code> 
	 * with distace from end point <code>E</code> at start point <code>S</code>.  
	 * <BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Bezier
	 * @see Intersection
	 */

	public class Line extends Object implements IParametric 
	{

		
		protected const PRECISION : Number = 1e-10;

		protected var __start : Point;
		protected var __end : Point;
		protected var __isSegment : Boolean;
		protected var __isRay : Boolean;

		//**************************************************
		//				CONSTRUCTOR 
		//**************************************************
		
		/* *
		 * 
		 * Создает новый объект Line. 
		 * Если параметры не переданы, то все опорные точки создаются в координатах 0,0  
		 * 
		 * @param start:Point начальная точка прямой или отрезка
		 * @param end:Point конечная точка прямой или отрезка
		 * @param isSegment:Boolean флаг ограниченности
		 * @param isRay:Boolean флаг того, что прямая является лучом
		 * 
		 * @example В этом примере создается прямая в случайных координатах.  
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomLine():Line {
		 * 	return new Line(randomPoint(), randomPoint());
		 * }
		 *	
		 * const line:Line = randomLine();
		 * trace("random line: "+line);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/		

		public function Line(start : Point = undefined, end : Point = undefined, isSegment : Boolean = true, isRay : Boolean = false) 
		{
			initInstance(start, end, isSegment, isRay);
		}

		/* *
		 * Приватный инициализатор для объекта, который можно переопределить. Параметры совпадают с параметрами конструктора.
		 *
		 **/ 
		protected function initInstance(start : Point = undefined, end : Point = undefined, isSegment : Boolean = true, isRay : Boolean = false) : void 
		{
			__start = (start as Point) || new Point();
			__end = (end as Point) || new Point();
			__isSegment = Boolean(isSegment);
			__isRay = Boolean(isRay);
		}

		/*
		 * Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах, 
		 * start, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		 */

		/*
		 * As public variables impossible to redefine in daughter classes, 
		 * start, end and isSegment realized how get-set methods, not how public variables.
		 */
		 
		 
		/* *
		 * Начальная опорная точка прямой. Итератор <code>time</code> равен нулю.
		 * 
		 * @return Point начальная точка прямой
		 * 
		 * @default Point(0, 0)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 * 
		 **/
		/**
		 * First anchor point of piece of line. Interator <code>time</code> equally 0.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/		
		public function get start() : Point 
		{
			return __start;
		}

		public function set start(value : Point) : void 
		{
			__start = value;
		}

		/* *
		 * Конечная опорная точка прямой. Итератор <code>time</code> равен единице.
		 *  
		 * @return Point конечная точка прямой
		 *  
		 * @default Point(0, 0)
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		 
		/**
		 * Final bearing(anchor) point of piece of line. Interator <code>time</code> equally 1.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		public function get end() : Point 
		{
			return __end;
		}

		public function set end(value : Point) : void 
		{
			__end = value;
		}

		/* *
		 * Определяет является ли прямая бесконечной в обе стороны,
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
		 
		/**
		 * Defined, is line infinite in both side
		 * or limited in borders of interators 0-1.<BR/>
		 * <BR/>
		 * <BR/>
		 * Current variable isSegment influense at results of methods:<BR/>
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
		public function get isSegment() : Boolean 
		{
			return __isSegment;
		}

		public function set isSegment(value : Boolean) : void 
		{
			__isSegment = Boolean(value);
		}

		/* *
		 * Определяет является ли прямая лучом, то есть бесконечной только в направлении от start к end.
		 * <BR/>
		 * Текущее значение isRay влияет на результаты методов:<BR/>
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
		public function get isRay() : Boolean 
		{
			return __isRay;
		}

		public function set isRay(value : Boolean) : void 
		{
			__isRay = Boolean(value);
		}

		
		/* *
		 * Создает и возвращает копию текущего объекта Line. 
		 * Обратите внимание, что в копии опорные точки так же копируются, и являются новыми объектами.
		 * 
		 * @return Line копия прямой
		 * 
		 * @example В этом примере создается случайная прямая и ее копия. 
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomLine():Line {
		 * 	return new Line(randomPoint(), randomPoint());
		 * }
		 *	
		 * const line:Line = randomLine();
		 * const clone:Line = line.clone();
		 * trace("random line: "+line);
		 * trace("clone line: "+clone);
		 * trace(bezier == clone); //false
		 * 	 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/	
		/**
		 * 
		 * @return Line copy of current object Line.  
		 */

		public function clone() : Line 
		{
			return new Line(__start.clone(), __end.clone(), __isSegment);
		}

		
		/**
		 * Получение вектора из начальной точки прямой в конечную точку.
		 * Обратный вектор можно получить методом <a href="#endToStart">endToStart</a><BR/> 
		 *  
		 * @see #endToStart
		 * 
		 * @return Point вектор из начальной точки в конечную
		 * 
		 * @example В этом примере создается прямая, и выводится вектор из начальной точки в конечную.
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *		
		 * const line:Line = Line( new Point(100, 300), new Point(400, 200));
		 * var point:Point = line.startToEnd;
		 * trace(point.x+" "+point.y); //300 -100
		 *  
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */		
		public function get startToEnd() : Point
		{
			return new Point(end.x - start.x, end.y - start.y);			
		}

		/**
		 * Получение вектора из конечной точки прямой в начальную точку.
		 * Обратный вектор можно получить методом <a href="#endToStart">startToEnd</a><BR/> 
		 *  
		 * @see #startToEnd
		 * 
		 * @return Point вектор из конечной точки в начальную
		 * 
		 * @example В этом примере создается прямая, и выводится вектор из конечной точки в начальную.
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *		
		 * const line:Line = Line( new Point(100, 300), new Point(400, 200));
		 * var point:Point = line.endToStart;
		 * trace(point.x+" "+point.y); //-300 100
		 *  
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */		
		public function get endToStart() : Point
		{
			return new Point(start.x - end.x, start.y - end.y);			
		}

		
		/**
		 * Проверка вырожденности прямой в точку.
		 * Если прямая вырождена в точку, то возвращается объект класса Point с координатой точки, в которую вырождена прямая.
		 * В других случаях, если прямая протяженная, возвращается null.
		 * 
		 * @private Логика работы метода - проверка, что опорные точки прямой совпадают, с учетом допуска.
		 *  
		 * @return Point точка, в которую вырождена прямая
		 * 
		 * @example В этом примере создается прямая, и проверяется ее вырожденность в точку.
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *		
		 * const line:Line = Line( new Point(100, 300), new Point(100, 200));
		 * var point:Point = line.lineAsPoint();
		 * trace("Is it point? "+ (point != null)); //Is it point? false
		 * line.end.y = 300;
		 * point = line.lineAsPoint();
		 * trace("Is it point? "+ (point != null)); //Is it point?  true
		 * 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		public function lineAsPoint() : Point
		{
			if (this.startToEnd.length < PRECISION)
			{
				return start.clone();				
			}
			else
			{
				return null;
			}
		}

		
		/* *
		 * Угол наклона прямой.
		 * Измеряется в радианах, от положительного направления оси X к положительному направлению оси Y (стандартная схема).
		 * Возвращаемое значение находится в пределах от отрицательного PI до положительного PI.
		 * 
		 * @return Number угол наклона прямой
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Angle of incline line at radian.
		 * Rotate realize respecting at point <code>start</code>.
		 * The return value is between positive PI and negative PI. 
		 **/
		public function get angle() : Number 
		{
			return Math.atan2(__end.y - __start.y, __end.x - __start.x);
		}

		public function set angle(rad : Number) : void 
		{
			const distance : Number = Point.distance(__start, __end);
			const polar : Point = Point.polar(distance, rad);
			__end.x = __start.x + polar.x;
			__end.y = __start.y + polar.y; 
		}

		/* *
		 * Поворачивает линию относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0);
		 * 
		 * @param value:Number угол поворота в радианах
		 * @param fulcrum:Point центр вращения. 
		 * 		
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		 
		/**
		 * Rotate line respection at point <code>fulcrum</code> at current angle.
		 * If point <code>fulcrum</code> undefined, then automatically use (0,0);
		 * @param value:Number angle(radian)
		 * @param fulcrum:Point center of rotation. 
		 * If variable undefined, center of rotation is point <code>start</code>
		 */

		public function angleOffset(value : Number, fulcrum : Point = null) : void 
		{
			fulcrum = fulcrum || new Point();
			const startLine : Line = new Line(fulcrum, __start);
			startLine.angle += value;
			const endLine : Line = new Line(fulcrum, __end);
			endLine.angle += value;
		}

		/* *
		 * Смещает прямую на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0 
		 * @lang rus
		 */
		 
		/**
		 * Move line at given distance at axes X and Y.  
		 * 
		 * @param dx:Number variable of moving at axe X
		 * @param dy:Number variable of moving at axe Y
		 * 
		 */		 		
		public function offset(dX : Number = 0, dY : Number = 0) : void 
		{
			__start.offset(dX, dY);
			__end.offset(dX, dY);
		}

		/* *
		 * Длина отрезка <code>start</code>-<code>end</code>.
		 * Возвращаемое число - всегда положительное значение.
		 * При задании свойства length возможно использовать и отрицательные значения, но не нулевые.
		 * Изменение длины не меняет угла наклона прямой, а только перемещает точку end вдоль прямой.
		 * 
		 * @return Number длина отрезка
		 * 
		 **/
		/**
		 * Calculate and return length of piece of line <code>start</code>-<code>end</code>.
		 * Return number only positively; 
		 * @return Number;
		 **/

		public function get length() : Number 
		{
			return Point.distance(__start, __end); 
		}

		public function set length(value : Number) : void 
		{
			var lastLength : Number = this.length;
			if (lastLength > PRECISION)
			{
				var newEndX : Number = __start.x + value * (__end.x - __start.x) / lastLength;
				var newEndY : Number = __start.y + value * (__end.y - __start.y) / lastLength;			
				__end.x = newEndX;
				__end.y = newEndY;
			}
		}

		/* *
		 * Вычисляет и возвращает объект Point, представляющий точку на прямой, заданную параметром <code>time</code>.
		 * 
		 * @param time:Number итератор точки прямой
		 * @param point:Point=null необязательный параметр, объект Point, в который записать координаты
		 * 
		 * @return Point точка на прямой
		 * <I>
		 * Если передан параметр time равный 0 или 1, то будут возвращены объекты Point
		 * эквивалентные <code>start</code> и <code>end</code>, но не сами объекты <code>start</code> и <code>end</code> 
		 * </I> 
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Line;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();	
		 *	const time:Number = Math.random();
		 *	const point:Point = line.getPoint(Math.random());
		 *	trace(point);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */	
		/**
		 * Calculate and return point on line, given by time-iterator.
		 * @param time time-итератор
		 * @return Point point on line
		 * 
		 */
		public function getPoint(time : Number, point : Point = null) : Point 
		{
			point = (point as Point) || new Point();
			point.x = __start.x + (__end.x - __start.x) * time;
			point.y = __start.y + (__end.y - __start.y) * time;
			return point;
		}

		/* *
		 * Вычисляет и возвращает time-итератор точки находящейся на заданной дистанции по линии от точки start. 
		 * @param distance:Number
		 * @return Number
		 * 
		 */
		/**
		 * Вычисляет time-итератор точки, находящейся на заданной дистанции 
		 * по прямой от точки <code>start</code><BR/>
		 *  
		 * @param distance:Number дистанция по прямой до искомой точки.
		 * 
		 * @return Number time-итератор искомой точки
		 *  
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Line;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();	
		 * 
		 *	trace(line.getTimeByDistance(-10); // negative value
		 *	trace(line.getTimeByDistance(line.length/2); // value between 0 and 1
		 * </listing>
		 * 
		 * @see #getPoint 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */ 
		/**
		 * Calculate and return time-iterator of point that can be found at given distance on line from point start. 
		 * @param distance:Number
		 * @return Number
		 * 
		 */
		public function getTimeByDistance(distance : Number) : Number 
		{
			var lineLength : Number = this.length;
			
			if (lineLength > PRECISION)
			{
				return distance / lineLength;
			}
			else
			{
				return Number.NaN;
			}
		}

		/* *
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
		
		/**
		 * Изменяет позицию точки <code>end</code> таким образром, 
		 * что точка <code>P<sub>time</sub></code> станет в координаты,
		 * заданные параметрами <code>x</code> и <code>y</code>.
		 * Если параметр <code>x</code> или <code>y</code> не определен,
		 * значение соответствующей координаты точки <code>P<sub>time</sub></code>
		 * не изменится. 
		 * 
		 * @param time:Number time-итератор точки кривой.
		 * @param x:Number новое значение позиции точки по оси X.
		 * @param y:Number новое значение позиции точки по оси Y.
		 * 
		 * @example 
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Line;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();	
		 *	trace(line);
		 *	
		 *	line.setPoint(0, 0, 0);
		 *	line.setPoint(0.5, 100, 100);
		 *	line.setPoint(1, 200, 0);
		 *	
		 *	trace(line); 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		 	
		/**
		 * Change position of point <code>end</code>, 
		 * that point <code>P<sub>time</sub></code> take coordinates,
		 * given by parameters <code>x</code> and <code>y</code>.
		 * If parameter <code>x</code> or <code>y</code> undefined,
		 * correspond variable <code>P<sub>time</sub></code>
		 * don't change. 
		 * @param time 
		 * @param x
		 * @param y
		 * 
		 */
		public function setPoint(time : Number, x : Number = undefined, y : Number = undefined) : void 
		{
			if (isNaN(x) && isNaN(y)) 
			{
				return;
			}
			const point : Point = getPoint(time);
			if (! isNaN(x)) 
			{
				point.x = x;
			}
			if (! isNaN(y)) 
			{
				point.y = y;
			}
			__end.x = point.x + (point.x - __start.x) * ((1 - time) / time);
			__end.y = point.y + (point.y - __start.y) * ((1 - time) / time);
		}

		/* *
		 * Вычисляет и возвращает описывающий прямоугольник сегмента прямой между начальной и конечной точками.<BR/> 
		 * Если свойство isSegment=false, это игнорируется, не влияет на результаты рассчета.</I> 
		 * 
		 * @return Rectangle габаритный прямоугольник.
		 * 
		 * @example В этом примере создается случайна кривая Безье, и выводится центр тяжести описывающего ее треугольника.
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 * const line:Line = randomLine();	
		 * var boundBox:Rectangle = line.bounds;
		 * trace(boundBox.x+" "+boundBox.y+" "+boundBox.width+" "+boundBox.height); 
		 *  
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		 
		 
		/**
		 * Return overall rectangle of object. 
		 **/
		public function get bounds() : Rectangle 
		{
			if (__start.x > __end.x) 
			{
				if (__start.y > __end.y) 
				{
					return new Rectangle(__end.x, __end.y, __start.x - __end.x, __start.y - __end.y);
				} 
				else 
				{
					return new Rectangle(__end.x, __start.y, __start.x - __end.x, __end.y - __start.y);
				}
			}
			if (__start.y > __end.y) 
			{
				return new Rectangle(__start.x, __end.y, __end.x - __start.x, __start.y - __end.y);
			} 
			return new Rectangle(__start.x, __start.y, __end.x - __start.x, __end.y - __start.y);
		}

		/**
		 * Возвращает отрезок - сегмент линии, заданный начальным и конечным итераторами.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Line;
		 * 
		 * @example 
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 * const line:Line = randomLine();	
		 * const segment1:Line = line.getSegment(1/3, 2/3);
		 * const segment2:Line = line.getSegment(-1, 2);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		 	
		/**
		 * Return piece of line - segment of line, given by beginning and ending interators.
		 * 
		 * @param fromTime:Number time-iterator first point of segment
		 * @param toTime:Number time-iterator end point of segment of curve
		 * 
		 * @return Line 
		 * 
		 */
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Line 
		{
			return new Line(getPoint(fromTime), getPoint(toTime));
		}

		
		/* *
		 * Возвращает длину сегмента прямой от точки <code>start</code> 
		 * до точки на линии, заданной time-итератором.
		 * 
		 * @param time:Number параметр time конечной точки сегмента.
		 * 
		 * @return Number длина сегмента прямой
		 * 
		 * 
		 * @example В этом примере создается случайная прямая, 
		 * вычисляется time-итератор точки середины прямой, а затем
		 * выводятся значения половины длины прямой и длина сегмента
		 * прямой до средней точки - они должны быть равны.
		 * <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 * const line:Line = randomLine();	
		 *	
		 *	const middleDistance:Number = line.length/2;
		 *	const middleTime:Number = line.getTimeByDistance(middleDistance);
		 *	const segmentLength:Number = line.getSegmentLength(middleTime);
		 *	
		 *	trace(middleDistance);
		 *	trace(segmentLength);
		 *	
		 *</listing> 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #length
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Return length of segment of line from point <code>start</code> 
		 * at point on line, given by time-iterator.
		 *  
		 * @param time - iterator of point.
		 * 
		 * @return Number 
		 * 
		 */
		public function getSegmentLength(time : Number) : Number 
		{
			return Point.distance(__start, getPoint(time));
		}

		/* *
		 * Вычисляет и возвращает массив точек на линии удаленных друг от друга на 
		 * расстояние, заданное параметром <code>step</code>.<BR/>
		 * Первая точка массива будет смещена от стартовой точки на расстояние, 
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
		 
		/**  
		 * Вычисляет и возвращает массив точек на линии удаленных друг от друга на 
		 * расстояние, заданное параметром <code>step</code>.<BR/>
		 * Первая точка массива будет смещена от стартовой точки на расстояние, 
		 * заданное параметром <code>startShift</code>. 
		 * При этом, если значение <code>startShift</code> превышает значение
		 * <code>step</code>, будет использован остаток от деления на <code>step</code>.<BR/>
		 * <BR/>
		 * Типичное применение данного метода - вычисление последовательности точек 
		 * для рисования пунктирных линий. 
		 *  
		 * @param step:Number шаг, дистанция по прямой между точками.
		 * @param startShift:Number дистанция по прямой, задающая смещение первой 
		 * точки последовательности относительно точки <code>start</code>
		 *  
		 * @return Array массив итераторов
		 *  
		 * @example <listing version="3.0">
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 * const line:Line = randomLine();
		 * var points:Array = line.getTimesSequence(10, 0);
		 *
		 *  for(var i:uint=0; i<points.length; i+=2)
		 *  {
		 *  	var startSegmentTime:Number = points[i];
		 *		var endSegmentTime:Number = points[i+1];
		 *		var segment:Line = line.getSegment(startSegmentTime, endSegmentTime);
		 *		drawLine(segment);
		 *  }
		 *
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Calculate and return array of points on line than can be found at distance 
		 * given be parameter <code>step</code>.<BR/>
		 * First point of array will be moved from start point at distance, 
		 * given be parameter <code>startShift</code>. 
		 * If variable <code>startShift</code> bigger then 
		 * <code>step</code>, will be used remainder from segmentation on <code>step</code>.<BR/>
		 * <BR/>
		 * Use this method it - calculating consecution of points 
		 * for drawing dotted lines. 
		 * 
		 * @param step
		 * @param startShift
		 * @return 
		 * 
		 */

		public function getTimesSequence(step : Number, startShift : Number = 0) : Array 
		{
			step = Math.abs(step);
			const distance : Number = (startShift % step + step) % step;
			
			const times : Array = new Array();
			const lineLength : Number = Point.distance(__start, __end);
			if (distance > lineLength) 
			{
				return times;
			}
			const timeStep : Number = step / lineLength;
			var time : Number = getTimeByDistance(distance);
			
			while (time <= 1) 
			{
				times[times.length] = time;
				time += timeStep;
			}
			return times;
		}

		/**
		 * Метод находит пересечения прямой с точкой<BR/>
		 * Добавлен для гармонии с методами пересечения двух прямых и кривой Безье с прямой.
		 * К этому методу сводятся остальные методы поиска пересечений в случае вырожденности фигур.
		 * 
		 * @param target:Point точка, с которой ищется пересечение
		 * @return Intersection объект с описанием пересечения
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Line;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();
		 *	var intersection:Intersection = line.intersectionPoint(new Point(100, 100));
		 *	trace(intersection);
		 *	
		 * </listing>
		 *  
		 * @see Intersection
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */

		
		public function intersectionPoint(target : Point) : Intersection 
		{
			var intersection : Intersection = new Intersection();
			
			var closestTime : Number = this.getClosest(target);
			var closestPoint : Point = this.getPoint(closestTime);
						
			if (Point.distance(target, closestPoint) < PRECISION)
			{
				intersection.addIntersection(closestTime, 0, this.isSegment, false);	
			}

			return intersection;
		}

		/**
		 * Метод находит пересечения двух прямых<BR/>
		 * Результат вычисления пересечения двух прямых может дать следующие результаты:  <BR/>
		 * - если пересечение отсутствует, возвращается объект Intersection с пустыми массивами currentTimes и targetTimes;<BR/>
		 * - если пересечение произошло в одной или двух точках, будет возвращен объект Intersection,
		 *   и time-итераторы точек пересечения данной прямой будут находиться в массиве currentTimes.
		 *   time-итераторы точек пересечения прямой <code>target</code> будут находиться в массиве targetTimes;<BR/>
		 * - если прямая вырождена, то может произойти совпадение. 
		 * В этом случае результатом будет являться отрезок - объект Line (<code>isSegment=true</code>), 
		 * который будет доступен как свойство <code>coincidenceLine</code> в возвращаемом объекте Intersection;<BR/>
		 * <BR/>  
		 * На результаты вычисления пересечений оказывает влияние свойство <code>isSegment<code> как текущего объекта,
		 * так и значение <code>isSegment</code> объекта target.
		 * 
		 * @param target:Line прямая линия, с которой ищется пересечение
		 * @return Intersection объект с описанием пересечения
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	import flash.geom.Line;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();
		 *	var target:Line = new Line(new Point(100, 100), new Point(200, 200));
		 *	var intersection:Intersection = line.intersectionLine(target);
		 *	trace(intersection);
		 *	
		 * </listing>
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see Intersection
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus 
		 */

		//TODO: забытый метод! переделать тут все нафиг. Sergeyev
		public function intersectionLine(targetLine : Line) : Intersection 
		{
			var intersection : Intersection = new Intersection();
			
			if (__isSegment && targetLine.__isSegment) 
			{
				var currentBoundBox : Rectangle = this.bounds;
				var targetBoundBox : Rectangle = targetLine.bounds;
						
				if (currentBoundBox.right < targetBoundBox.left || targetBoundBox.right < currentBoundBox.left || currentBoundBox.top < targetBoundBox.bottom || targetBoundBox.top < currentBoundBox.bottom) 
				{ 
					return intersection;  
				} 
			}
			
			var startToEnd : Point = this.startToEnd;
			var targetStartToEnd : Point = targetLine.startToEnd;
			
			const currentDeterminant : Number = startToEnd.x * __start.y - startToEnd.y * __start.x;
			const targetDeterminant : Number = targetStartToEnd.x * targetLine.__start.y - targetStartToEnd.y * targetLine.__start.x;
			const crossDeterminant : Number = startToEnd.x * targetStartToEnd.y - startToEnd.y * targetStartToEnd.x;
			const crossDeterminant2 : Number = __start.x * targetStartToEnd.y - __start.y * targetStartToEnd.x;
			
			if(Math.abs(crossDeterminant) < PRECISION) 
			{
				if(Math.abs(crossDeterminant2 + targetDeterminant) < PRECISION) 
				{
					intersection.isCoincidence = true;
										
					var coincidenceStartTime : Number;
					var coincidenceEndTime : Number;
					
					var currentEndTime : Number;
					var currentStartTime : Number;
					
					const linesStartTime : Number = 0;
					const linesEndTime : Number = 1;					
					
					if (Math.abs(startToEnd.x) > PRECISION) 
					{
						currentStartTime = - (__start.x - targetLine.__start.x) / startToEnd.x;
						currentEndTime = - (__start.x - targetLine.__end.x) / startToEnd.x;
					} 
					else 
					{ 
						if (Math.abs(startToEnd.y) > PRECISION) 
						{
							currentStartTime = (targetLine.__start.y - __start.y) / startToEnd.y;
							currentEndTime = (targetLine.__end.y - __start.y) / startToEnd.y;
						}
						else
						{
							currentStartTime = 0;
							currentEndTime = 0;
						}
					}
					
					if ((linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 && (linesEndTime - currentStartTime) * (linesEndTime - currentEndTime) <= 0) 
					{
						coincidenceEndTime = linesEndTime;
						coincidenceStartTime = linesStartTime; 
					} 
					else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) <= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) <= 0) 
					{
						coincidenceEndTime = currentEndTime;
						coincidenceStartTime = currentStartTime; 
					} else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) <= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) >= 0) 
					{
						coincidenceStartTime = currentStartTime;
						coincidenceEndTime = (linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 ? linesStartTime : linesEndTime;
					} else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) >= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) <= 0) 
					{
						coincidenceStartTime = currentEndTime;
						coincidenceEndTime = (linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 ? linesStartTime : linesEndTime;
					}
					var startPoint : Point = new Point(coincidenceStartTime * startToEnd.x + __start.x, coincidenceStartTime * startToEnd.y + __start.y);
					var endPoint : Point = new Point(coincidenceEndTime * startToEnd.x + __start.x, coincidenceEndTime * startToEnd.y + __start.y);
					intersection.coincidenceLine = new Line(startPoint, endPoint);
				}
				
				return intersection;
			}
			else
			{
				var solve : Point = new Point();			
				solve.x = (currentDeterminant * targetStartToEnd.x - targetDeterminant * startToEnd.x) / crossDeterminant;
				solve.y = (currentDeterminant * targetStartToEnd.y - targetDeterminant * startToEnd.y) / crossDeterminant;
			
				var time : Number;
				if (Math.abs(startToEnd.x) > PRECISION)
				{
					time = (solve.x - __start.x) / startToEnd.x;
				}
				else
				{
					if (Math.abs(startToEnd.y) > PRECISION)
					{
						time = (solve.y - __start.y) / startToEnd.y;
					}
					else
					{
						time = Number.NaN;
					}
				}
				
				var targetTime : Number;
				if (Math.abs(targetStartToEnd.x) > PRECISION)
				{
					targetTime = (solve.x - targetLine.__start.x) / targetStartToEnd.x;
				}
				else
				{
					if (Math.abs(startToEnd.y) > PRECISION)
					{
						targetTime = (solve.y - targetLine.__start.y) / targetStartToEnd.y;
					}
					else
					{
						targetTime = Number.NaN;
					}
				}
				if ((! isSegment || (time >= 0 && time <= 1)) && (! targetLine.isSegment || (targetTime >= 0 && targetTime <= 1)))
				{								
					intersection.currentTimes.push(time);
					intersection.targetTimes.push(targetTime);
				}
				
				return intersection;
			}
		}

		/**
		 * Метод находит пересечения прямой линии с кривой Безье<BR/>
		 * Полностью сводится к методу intersectionLine класса Bezier, подробное описание его работы смотрите там.
		 * 
		 * @param target:Bezier кривая Безье, с которой ищется пересечение
		 * @return Intersection объект с описанием пересечения
		 *   	
		 */		   		
		public function intersectionBezier(target : Bezier) : Intersection 
		{
			var intersection : Intersection = target.intersectionLine(this);
			intersection.switchCurrentAndTarget();
			return intersection;
		}

		
		/**
		 * <P>Вычисляет и возвращает time-итератор точки на прямой, 
		 * ближайшей к точке <code>fromPoint</code>.<BR/>
		 * В зависимости от значения свойства <a href="#isSegment">isSegment</a>
		 * возвращает либо значение в пределах от 0 до 1, либо от минус 
		 * бесконечности до плюс бесконечности.</P>
		 * 
		 * @param fromPoint:Point произвольная точка на плоскости
		 * 
		 * @return Number time-итератор ближайшей точки на прямой
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	import flash.geom.Point;
		 *	import flash.geom.Line;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomLine():Line {
		 *		return new Line(randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const line:Line = randomLine();
		 *	var fromPoint:Point = randomPoint();
		 *	var closest:Number = line.getClosest(fromPoint);
		 * 
		 *  trace(line);
		 *  trace(fromPoint);
		 *  trace(line.getPoint(closest));
		 *  
		 * </listing>
		 * 
		 * @see #isSegment
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 **/
		public function getClosest(fromPoint : Point) : Number 
		{
			const startToEnd : Point = this.startToEnd;
			const startToEndLength : Number = startToEnd.length;
						
			if( startToEndLength < PRECISION)
			{
				return 0;
			}
			
			const selfProjection : Number = - startToEnd.y * __start.x + startToEnd.x * __start.y;
			const projection : Number = (startToEnd.y * fromPoint.x + startToEnd.x * fromPoint.y + selfProjection) / (startToEndLength * startToEndLength);
			const point : Point = new Point(fromPoint.x - startToEnd.y * projection, fromPoint.y - startToEnd.x * projection);
			const time : Number = startToEnd.x ? (__start.x - point.x) / startToEnd.x : (point.y - __start.y) / startToEnd.y;
					
			if (! __isSegment) 
			{
				return time;
			}
			if(time < 0) 
			{
				return 0;
			}
			if (time > 1) 
			{
				return 1;
			}
			return time;
		}

		
		
		//**************************************************
		//				UTILS 
		//**************************************************
		/**
		 * Возвращает описание объекта Line, понятное человекам. 
		 * 
		 * @return String описание объекта
		 * 
		 */
		public function toString() : String 
		{
			return 	"(start:" + __start + ", end:" + __end + ")";
		}
	}
}
