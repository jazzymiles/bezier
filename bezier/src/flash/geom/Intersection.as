package flash.geom {

	public class Intersection extends Object {

		/**
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, метод которого был вызван. 
		 **/
		 
		public const currentTimes:Array = new Array();

		/**
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, который был передан 
		 * в качестве аргумента при вызове метода получения пересечений. 
		 **/
		 
		public const oppositeTimes:Array = new Array();

		/**
		 * Если два объекта частично или полностью совпали, будет возвращен объект, 
		 * представляющий совпавшую часть.
		 **/
		 
		public var coincidence:Object;
	}
}