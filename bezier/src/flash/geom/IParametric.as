package flash.geom {

	public interface IParametric {

		/**
		 * Режим ограничения линии.
		 * @default true   
		 **/
		function get isSegment():Boolean;

		function set isSegment(value:Boolean):void;

		/**
		 * Начальная точка линии.
		 * @default (0,0)
		 **/
		function get start():Point;

		function set start(value:Point):void;

		/**
		 * Конечная точка линии.
		 * @default (0,0)
		 **/
		function get end():Point;

		function set end(value:Point):void;

		/**
		 * Длина линии
		 * @return Number
		 */
		function get length():Number;

		/**
		 * Вычисляет и возвращает точку по time-итератору.
		 * @return Point;
		 **/
		 
		function getPoint(time:Number):Point;

		/**
		 * Вычисляет и возвращает time-итератор точки по дистанции от <code>start</code>.
		 * @return Number;
		 **/
		 
		function getTimeByDistance(distance:Number):Number;

		/**
		 * Вычисляет и возвращает массив time-итераторов точек с заданным шагом.
		 * @return Array;
		 **/
		 
		function getTimesSequence(step:Number, startShift:Number = 0):Array;

		/**
		 * Вычисляет и возвращает габаритный прямоугольник.
		 * @return Rectangle;
		 **/
		 
		function get bounds():Rectangle;

		//  == management == 
		/**
		 * Изменяет объект таким образом, что точка с заданным итератором
		 * примет координаты, определенные параметрами.
		 * @return void 
		 **/
		 
		function setPoint(time:Number, x:Number = undefined, y:Number = undefined):void;

		/**
		 * Смещает объект на заданную дистанцию по осям X и Y
		 * @return void 
		 **/
		 
		function offset(dx:Number, dy:Number):void;

		/**
		 * Смещает объект на заданную дистанцию по осям X и Y
		 * @return void 
		 **/
		 
		function angleOffset(value:Number, fulcrum:Point = null):void;

		/**
		 * Вычисляет и возвращает time-итератор точки, ближайшей к заданной.
		 * @return Number
		 **/
		function getClosest(fromPoint:Point):Number;

		//		function getSegment (fromTime:Number=0, toTime:Number=1):IParametric;
		
		/**
		 * Вычисляет и возвращает длину сегмента от точки <code>start</code>
		 * до точки, заданной параметром time;
		 * @return Number
		 **/
		 
		function getSegmentLength(time:Number):Number;

		// == intersections ==
		/**
		 * Вычисляет и возвращает пересечение с Line
		 * @return Intersection
		 **/
		function intersectionLine(line:Line):Intersection;

		/**
		 * Вычисляет и возвращает пересечение с Bezier
		 * @return Intersection
		 **/
		function intersectionBezier(target:Bezier):Intersection;

		
		/**
		 * Возвращает строковое представление объекта
		 * @return String
		 **/
		 
		function toString():String;
	}
}