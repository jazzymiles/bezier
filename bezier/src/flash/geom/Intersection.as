// UTF-8
package flash.geom {

	public class Intersection extends Object {
		
		/**
		 * Свойство, указывающее на тип пересечения.<BR/>
		 * Если пересечение существует, то результатом вычисления может быть либо массив точек,
		 * либо полное или частичное совпадение фигур.<BR/>
		 * <BR/>
		 * Если значение <code>isCoincidence=false</code>, значит фигуры пересеклись.
		 * В этом случае массив <code>currentTimes</code> будет содержать итераторы точек пересечения
		 * на текущем объекте, а массив <code>targetTimes</code> будет содержать итераторы точек
		 * пересечения на целевом объекте.<BR/>
		 * <BR/>
		 * Если значение <code>isCoincidence=true</code>, значит найдено совпадение.<BR/>
		 * Совпадение описывается парами итераторов, определяющих начало и конец фигуры совпадения.<BR/>
		 * Используйте метод getSegment для получения совпадающих фигур.<BR/>
		 * <BR/>
		 * К примеру, получая пересечение двух кривых Безье, требуется проверить, 
		 * существует ли пересечение и далее обрабатывать в зависимости от его типа:
		 * <BR/>
		 * <listing version="3.0">
		 * var intersection:Intersection = currentBezier.intersectionBezier(targetBezier);
		 * if (intersection) {
		 * 	if (intersection.isCoincidence) {
		 * 		// обработка совпадения
		 * 	} else {
		 * 		// обработка пересечения
		 * 	} 
		 * }
		 * </listing>
		 * <BR/>
		 * <BR/>
		 * Совпадением двух отрезков может являться только отрезок.
		 * Он будет описан как пара значений в массиве currentTimes
		 * и соответствующая пара значений в массиве targetTimes.<BR/>
		 * Отрезок можно получить:<BR/>
		 * <listing version="3.0">
		 * currentLine.getSegment(intersection.currentTimes[0], intersection.currentTimes[1]);
		 * </listing>
		 * либо <BR/>
		 * <listing version="3.0">
		 * targetLine.getSegment(intersection.targetTimes[0], intersection.targetTimes[1]);
		 * </listing>
		 * результатом двух вычислений будет два эквивалентных отрезка.<BR/>
		 * <BR/>
		 * <BR/>
		 * 
		 * Совпадение отрезка и кривой Безье может быть только, если кривая Безье вырождена в прямую.<BR/>  
		 * 
		 */
		
		public var isCoincidence:Boolean = false;

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
		 
		public const targetTimes:Array = new Array();

	}
}