/**
 * 		I. ВС ТУПЛЕНИЕ
 * 
 * Для программного рисования во Flash используется два метода: lineTo() и curveTo(),
 * реализующие соответственно отрисовку отрезка и кривой Безье второго порядка.
 * В редакторе Flash имеется возможность отрисовывать кривые с помощью кривых Безье
 * третьего порядка, однако, на этапе компиляции, они аппроксимируются кривыми
 * Безье второго порядка.
 * В итоге, все векторные фигуры в скомпилированном swf файле реализованы с помощью
 * отрезков или кривых Безье второго порядка.
 * В результате возникает целый спектр задач, для решения которых требуется математический
 * аппарат работы с отрезками и кривыми Безье второго порядка.
 * 
 * 
 * 		II. БАЗОВЫЕ ЗАДАЧИ
 * 
 * 1. управление:
 *   - с помощью контрольных точек;
 *   - установка заданной точки в произвольно заданые координаты;
 *   - поворот относительно произвольно заданной точки;
 *   - смещение на заданное расстояние.
 * 2. геометрические свойства:
 *   - получение точки на плоскости по известному time-итератору;
 *   - родители (прямая для отрезка и парабола для кривой Безье)
 *   - длина заданного сегмента
 *   - габаритный прямоугольник
 *   - площадь (для кривой Безье)
 *   - касательные
 * 3. получение точек на кривой:
 *   - по дистанции от начала;
 *   - ближайшей до произвольно заданной;
 *   - пересечения с другими кривыми и отрезками.
 * 
 * Подавляющее большинство остальных практических задач могут быть решены
 * на основе решений этих базовых задач. 
 * 
 * Собственно, перечисленные базовые задачи и реализованы в этом пакете классов. 
 * Примеры решения других практических задач вынесены в пакет howtodo.
 * 
 * 
 * 		III. КОНЦЕПЦИИ
 * 
 * 1. Классы Bezier и Line реализованы схожим образом и подавляющее большинство
 * их методов имеют либо схожий, либо аналогичный синтаксис, определенный интерфейсом IParametric.
 * Разумеется, есть и отличия: к примеру, у Line не может быть свойства area,
 * и отсутствует управляющая точка control; у Bezier, в свою очередь нет свойства
 * angle, присутствующего в Line.
 *
 * 2. Геометрические фигуры(линии), реализованные в классах Line и Bezier, задаются в
 * параметрической форме, и каждая точка фигуры характеризуется time-итератором.
 * Возможно, что поначалу покажется неудобным, что при вычислении точки на кривой
 * возвращается не привычный всем объект класса Point, а time-итератор,
 * являющийся Number. Однако такая реализация позволяет избежать избыточных 
 * конвертаций при последующих расчетах.
 * При необходимости перевести точку фигуры в объект Point, используйте метод getPoint().
 * При необходимости найти time-итератор двумерной точки, используйте метод getClosest().
 * 
 * 3. Объекты Bezier и Line могут быть бесконечны, либо ограничены конечными точками start и end.
 * Ограниченность может быть установлена свойством isSegment (по умолчанию true).
 * Если задать isSegment=false, то возвращаемые методами значения будут содержать точки, в том числе, 
 * лежащие за пределами сегмента start-end. В противном случае, возвращаемые методами значения 
 * будут содержать только точки, принадлежащие сегменту лежащему между start и end.
 * 
 * [TODO]
 **/
 

package flash.geom {
	import flash.math.Equations;

	/** 
	 * <P>
	 * Класс Bezier представляет кривую Безье второго порядка в параметрическом представлении, 
	 * задаваемую точками на плоскости <code>start</code>, <code>control</code> и <code>end</code>
	 * и реализован в поддержку встроенного метода curveTo(). 
	 * В классе реализованы свойства и методы, предоставляющие доступ к основным геометрическим свойствам этой кривой.
	 * </P>
	 * <BR/>
	 * <h2>Краткие сведения о кривой Безье второго порядка.</h2>
	 * Любая точка P<sub>t</sub> на кривой Безье второго порядка вычисляется по формуле:<BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;S&#42;(1-t)<sup>2</sup>&nbsp;+&nbsp;2&#42;C&#42;(1-t)&#42;t&nbsp;+&nbsp;E&#42;t<sup>2</sup></code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * где: <BR/>
	 * <code><B>t</B></code> (<code><b>t</b>ime</code>) — time-итератор точки<BR/>
	 * <code><B>S</B></code> (<code><b>s</b>tart</code>) — начальная опорная (узловая) точка (<code>t=0</code>) (anchor point)<BR/>
	 * <code><B>С</B></code> (<code><b>c</b>ontrol</code>) — управляющая точка (direction point)<BR/> 
	 * <code><B>E</B></code> (<code><b>e</b>nd</code>) — конечная опорная (узловая) точка (<code>t=1</code>) (anchor point)<BR/>
	 * <BR/>
	 * Построение производится итерационным вычислением множества точек кривой, c изменением значения итератора t в пределах от нуля до единицы.<BR/>
	 * Точка кривой Безье характеризуется time-итератором.
	 * Две точки кривой, имеющие одинаковый time-итератор совпадут.
	 * В общем случае две точки кривой Безье второго порядка с различным time-итератором не совпадут.<BR/>
	 * <a name="bezier_building_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../../images/Step01Building.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *				width="100%" height="400" name="Step01Building"
	 * 				align="middle"
	 *				play="true"
	 *				loop="false"
	 *				quality="high"
	 *				allowScriptAccess="sameDomain"
	 *				type="application/x-shockwave-flash"
	 *				pluginspage="http://www.adobe.com/go/getflashplayer">
	 *			</embed>
	 *	</object>
	 * </td></table>
	 * <BR/>
	 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR/>
	 * <I>Используйте клавиши "влево" "вправо" для управления итератором.<BR/>
	 * Мышью перемещайте контрольные точки кривой.</I></P><BR/>
	 * <BR/>
	 * <h3>Свойства кривой Безье второго порядка</h3>
	 * <ul>
	 * 		<li>кривая непрерывна</li>
	 * 		<li>кривая аффинно-инвариантна</li>
	 * 		<li>все точки кривой Безье лежат в пределах треугольника ∆SCE</li>
	 * 		<li>точки <code>S</code> и <code>E</code> всегда принадлежат кривой Безье и ограничивают ее.</li>
	 * 		<li>точки с равномерно изменяющимся итератором распределены плотнее на участках с бóльшим изгибом</li>
	 * 		<li>вершина кривой Безье — точка с итератором <code>t=0.5</code> лежит на середине отрезка, соединяюшем <code>С</code> и середину отрезка <code>SE</code>.</li>
	 * 		<li>точка <code>C</code> в общем случае не принадлежит кривой и лежит на пересечении касательных к кривой в точках <code>S</code> и <code>E</code></li>
	 * 		<li>если точка <code>С</code> лежит на прямой <code>SE</code>, то такая кривая является вырожденной</li>
	 * 		<li>площадь фигуры, образуемой кривой Безье и отрезком <code>SE</code> равняется 2/3 </li>
	 * </ul>
	 * <h3>Кривая Безье и парабола</h3>
	 * Кривая Безье второго порядка является сегментом параболы.
	 * Кривая, построенная по <a href="#formula1">формуле <B>1</B></a>, и итератором <code><B>t</B></code> изменяющимся в бесконечных пределах является параболой. 
	 * Если кривая Безье лежит на параболе, то такая парабола по отношению к ней является родительской.
	 * <UL>
	 * 		<I>
	 * 		Это свойство также относится и к кривым Безье других степеней. Так, к примеру, отрезок можно 
	 * 		рассматривать как Безье первого порядка, а его родителем будет линия, которой принадлежит этот отрезок.
	 * 		Класс <a href="Line.html">Line</a> именно так интерпретирует отрезок для упрощения использования совместно с классом Bezier.<BR/>
	 * 		Кривая Безье третьего порядка на плоскости - сегмент проекции на плоскость кубической параболы, построеной в трехмерном пространстве.
	 * 		И общай случай: Кривая Безье порядка N на плоскости - сегмент проекции на плоскость N-мерной кривой, построеной в N-мерном пространстве.
	 * 		</I>
	 * </UL>
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Line
	 * @see Intersection
	 *  
	 **/

	public class Bezier extends Object implements IParametric {

		protected const PRECISION:Number = 1e-10;

		protected var __start:Point;
		protected var __control:Point;
		protected var __end:Point;
		protected var __isSegment:Boolean = true;

		//**************************************************
		//				CONSTRUCTOR 
		//**************************************************
		
		/* 
		 * 
		 * Создает новый объект Bezier. 
		 * Если параметры не переданы, то все опорные точки создаются в координатах 0,0  
		 * 
		 * @param start:Point начальная точка кривой Безье 
		 * 
		 * @param control:Point контрольная точка кривой Безье
		 *  
		 * @param end:Point конечная точка кривой Безье
		 * 
		 * @param isSegment:Boolean режим обработки.
		 * 
		 * @example В этом примере создается кривая Безье в случайных координатах.  
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * var bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/** 
		 * Create new Bezier object.
		 * If parameters are not passed, all control points are created in coordinates 0,0
		 *
		 * @param start:Point initial point of Bezier curve
		 *
		 * @param control:Point control point of Bezier curve
		 *
		 * @param end:Point end point of Bezier curve
		 *
		 * @param isSegment:Boolean operating mode
		 *
		 * @example In this example created Bezier curve with random coordinates.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * var bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda 
		 **/
		 
		 

		public function Bezier(start:Point = undefined, control:Point = undefined, end:Point = undefined, isSegment:Boolean = true) {
			__start = (start as Point) || new Point();
			__control = (control as Point) || new Point();
			__end = (end as Point) || new Point();
			__isSegment = Boolean(isSegment);
		}

		/*
		 * Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах, 
		 * start, control, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		 */
		
		/**
		 * Начальная опорная (anchor) точка кривой Безье. Итератор <code>time</code> равен нулю.
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
		 * Управляющая (direction) точка кривой Безье.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function get control():Point {
			return __control;
		}

		public function set control(value:Point):void {
			__control = value;
		}

		/**
		 * Конечная опорная (anchor) точка кривой Безье. Итератор <code>time</code> равен единице.
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
		 * Определяет является ли кривая Безье бесконечной в обе стороны
		 * или ограничена в пределах итераторов от 0 до 1.<BR/>
		 * <BR/>
		 * Безье строится с использованием итератора в пределах от 0 до 1, однако, 
		 * может быть построена в произвольных пределах.<BR/> 
		 * Кривая Безье, построеная от минус бесконечности до плюс 
		 * бесконечности является параболой.<BR/>
		 * <BR/>
		 * Текущее значение isSegment влияет на результаты методов:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Line.html#intersectionBezier">Line.intersectionBezier</a><BR/>
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
		 * Создает и возвращает копию текущего объекта Bezier.
		 * 
		 * @return Bezier.
		 * 
		 * @example В этом примере создается случайная кривая Безье и ее копия. 
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * var bezier:Bezier = randomBezier();
		 * var clone:Bezier = bezier.clone();
		 * trace("bezier: "+bezier);
		 * trace("clone: "+clone);
		 * trace(bezier == clone);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		public function clone():Bezier {
			return new Bezier(__start.clone(), __control.clone(), __end.clone(), isSegment);
		}

		//**************************************************
		//				GEOM PROPERTIES 
		//**************************************************
		
		/**
		 * Вычисляет длину киривой Безье
		 * 
		 * @return Number длина кривой Безье.
		 * 
		 * @example В этом примере создается случайная кривая Безье и выводится ее длина.  
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 *	
		 *	trace("bezier length: "+bezier.length);
		 * 
		 * </listing> 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #getSegmentLength
		 **/
		public function get length():Number {
			return getSegmentLength(1);
		}

		/**
		 * Вычисляет длину сегмента кривой Безье от стартовой точки до
		 * точки на кривой, заданной параметром time. 
		 * 
		 * @param time:Number параметр time конечной точки сегмента.
		 * @return Number length of arc.
		 * 
		 * @example В этом примере создается случайная кривая Безье, 
		 * вычисляется time-итератор точки середины кривой, а затем
		 * выводятся значения половины длины кривой и длина сегмента
		 * кривой до средней точки - они должны быть равны.
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 *	
		 *	var middleDistance:Number = bezier.length/2;
		 *	var middleTime:Number = bezier.getTimeByDistance(middleDistance);
		 *	var segmentLength:Number = bezier.getSegmentLength(middleTime);
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
		 **/
		public function getSegmentLength(time:Number):Number {
			var csX:Number = __control.x - __start.x;
			var csY:Number = __control.y - __start.y;
			var nvX:Number = __end.x - __control.x - csX;
			var nvY:Number = __end.y - __control.y - csY;
			
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			var c0:Number = 4*(csX*csX + csY*csY);
			var c1:Number = 8*(csX*nvX + csY*nvY);
			var c2:Number = 4*(nvX*nvX + nvY*nvY);
			
			var ft:Number;
			var f0:Number;
			
			if (c2 == 0) {
				if (c1 == 0) {
					ft = Math.sqrt(c0)*time;
					return ft;
				} else {
					ft = (2/3)*(c1*time + c0)*Math.sqrt(c1*time + c0)/c1;
					f0 = (2/3)*c0*Math.sqrt(c0)/c1;
					return (ft - f0);
				}
			} else {
				var sqrt_0:Number = Math.sqrt(c2*time*time + c1*time + c0);
				var sqrt_c0:Number = Math.sqrt(c0);
				var sqrt_c2:Number = Math.sqrt(c2);
				var exp1:Number = (0.5*c1 + c2*time)/sqrt_c2 + sqrt_0;
						
				if (exp1 < PRECISION) {
					ft = 0.25*(2*c2*time + c1)*sqrt_0/c2;
				} else {
					ft = 0.25*(2*c2*time + c1)*sqrt_0/c2 + 0.5*Math.log((0.5*c1 + c2*time)/sqrt_c2 + sqrt_0)/sqrt_c2*(c0 - 0.25*c1*c1/c2);
				}
				
				var exp2:Number = (0.5*c1)/sqrt_c2 + sqrt_c0;
				if (exp2 < PRECISION) {
					f0 = 0.25*(c1)*sqrt_c0/c2;
				} else {
					f0 = 0.25*(c1)*sqrt_c0/c2 + 0.5*Math.log((0.5*c1)/sqrt_c2 + sqrt_c0)/sqrt_c2*(c0 - 0.25*c1*c1/c2);
				}
				return ft - f0;
			}
		}

		
		/** 
		 * Вычисляет и возвращает площадь фигуры, ограниченой кривой Безье
		 * и отрезком <code>SE</code>.
		 * Площадь этой фигуры составляет 2/3 площади треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.<BR/>
		 * Соответственно, оставшаяся часть треугольника составляет 1/3 его площади.
		 * 
		 * @return Number
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var randomBezier:Bezier = randomBezier();
		 *	
		 * trace("bezier area: "+randomBezier.area);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #triangleArea	
		 **/
		public function get area():Number {
			return triangleArea*(2/3);
		}

		
		/**
		 * Вычисляет и возвращает площадь треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.  
		 * 
		 * @return Number
		 * 
		 * @see #area
		 **/
		public function get triangleArea():Number {
			// heron's formula
			var distanceStartControl:Number = Point.distance(__start, __control);
			var distanceEndControl:Number = Point.distance(__end, __control);
			var distanceStartEnd:Number = Point.distance(__start, __end);
			
			var halfPerimeter:Number = (distanceStartControl + distanceEndControl + distanceStartEnd)/2;
			var area:Number = Math.sqrt(halfPerimeter*(halfPerimeter - distanceStartControl)*(halfPerimeter - distanceEndControl)*(halfPerimeter - distanceStartEnd)); 
			return area;
		}

		/**
		 * 
		 * @return Rectangle габаритный прямоугольник.
		 */

		public function get bounds():Rectangle {
			var xMin:Number;
			var xMax:Number;
			var x:Number = __start.x - 2*__control.x + __end.x;
			var extremumTimeX:Number = ((__start.x - __control.x)/x) || 0;
			var extemumPointX:Point = getPoint(extremumTimeX);
			
			if (isNaN(extemumPointX.x) || extremumTimeX <= 0 || extremumTimeX >= 1) {
				xMin = Math.min(__start.x, __end.x);
				xMax = Math.max(__start.x, __end.x);
			} else {
				xMin = Math.min(extemumPointX.x, Math.min(__start.x, __end.x));
				xMax = Math.max(extemumPointX.x, Math.max(__start.x, __end.x));
			}
			
			var yMin:Number;
			var yMax:Number;
			var y:Number = __start.y - 2*__control.y + __end.y;
			var extremumTimeY:Number = ((__start.y - __control.y)/y) || 0;
			var extemumPointY:Point = getPoint(extremumTimeY);
			
			if (isNaN(extemumPointY.y) || extremumTimeY <= 0 || extremumTimeY >= 1) {
				yMin = Math.min(__start.y, __end.y);
				yMax = Math.max(__start.y, __end.y);
			} else {
				yMin = Math.min(extemumPointY.y, Math.min(__start.y, __end.y));
				yMax = Math.max(extemumPointY.y, Math.max(__start.y, __end.y));
			}

			var width:Number = xMax - xMin;
			var height:Number = yMax - yMin;
			return new Rectangle(xMin, yMin, width, height);
		}

		
		//**************************************************
		//		PARENT PARABOLA
		//**************************************************

		/**
		 * Вычисляет и возвращает time-итератор вершины параболы.
		 * 
		 * @return Number;
		 * 
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 *	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * var randomBezier:Bezier = randomBezier();
		 *	
		 * trace("parabola vertex time: "+randomBezier.parabolaVertex);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #parabolaFocus
		 */	

		public function get parabolaVertex():Number {
			var x:Number = __start.x - 2*__control.x + __end.x;
			var y:Number = __start.y - 2*__control.y + __end.y;
			var summ:Number = x*x + y*y;
			var dx:Number = __start.x - __control.x;
			var dy:Number = __start.y - __control.y;
			var vertexTime:Number = (x*dx + y*dy)/summ;
			if (isNaN(vertexTime)) {
				return 1/2;
			} 
			return vertexTime;
		}

		/**
		 * @return Point - фокус родительской параболы;
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #parabolaVertex
		 */
		// TODO:
		public function get parabolaFocusPoint():Point {
			var startX:Number = __start.x;
			var startY:Number = __start.y;
			var controlX:Number = __control.x;
			var controlY:Number = __control.y;
			var endX:Number = __end.x;
			var endY:Number = __end.y;

			var x:Number = startX - 2*controlX + endX;
			var y:Number = startY - 2*controlY + endY;
			var summ:Number = x*x + y*y;
			
			if (summ == 0) {
				return __control.clone();
			}
			
			var dx:Number = controlX - startX;
			var dy:Number = controlY - startY;
			
			var minT:Number = -(x*dx + y*dy)/summ;
			
			var minF:Number = 1 - minT;
			
			var minT2:Number = minT*minT;
			var minF2:Number = minF*minF;
		
			var psx:Number = 2*dx + 2*minT*x;
			var psy:Number = 2*dy + 2*minT*y;
			
			var vertexX:Number = startX*minF2 + 2*minT*minF*controlX + minT2*endX;
			var vertexY:Number = startY*minF2 + 2*minT*minF*controlY + minT2*endY;
		
			var fx:Number = vertexX - psy/(4*Math.SQRT2);
			var fy:Number = vertexY + psx/(4*Math.SQRT2);
			
			var side:Number = (psy*(startX - vertexX) - psx*(startY - vertexY))*(psy*(fx - vertexX) - psx*(fy - vertexY));

			if (side < 0) {
				fx = vertexX + psy/(4*Math.SQRT2);
				fy = vertexY - psx/(4*Math.SQRT2);
			}

			return new Point(fx, fy);
		}

		//**************************************************
		//		CURVE POINTS
		//**************************************************

		/**
		 * Реализация <a href="#formula1">формулы 1</a><BR/>
		 * Вычисляет и возвращает объект Point представляющий точку на кривой Безье, заданную параметром <code>time</code>.
		 * 
		 * @param time:Number итератор точки на кривой
		 * 
		 * @return Point точка на кривой Безье;<BR/>
		 * <I>
		 * Если передан параметр time равный 1 или 0, то будут возвращены объекты Point
		 * эквивалентные <code>start</code> и <code>end</code>, но не сами объекты <code>start</code> и <code>end</code> 
		 * </I> 
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 *	
		 *	var time:Number = Math.random();
		 *	var point:Point = bezier.getPoint(time);
		 *	
		 *	trace(point);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getPoint(time:Number):Point {
			if (isNaN(time)) {
				return undefined;
			}
			var f:Number = 1 - time;
			var x:Number = __start.x*f*f + __control.x*2*time*f + __end.x*time*time;
			var y:Number = __start.y*f*f + __control.y*2*time*f + __end.y*time*time;
			return new Point(x, y);
		}

		/**
		 * Поворачивает кривую относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0)
		 * @param value:Number угол вращения
		 * @param fulcrum:Point центр вращения. 
		 * Если параметр не определен, центром вращения является точка <code>start</code>
		 * 
		 */

		public function angleOffset(value:Number, fulcrum:Point = null):void {
			fulcrum = fulcrum || new Point();
			
			var startLine:Line = new Line(fulcrum, __start);
			startLine.angle += value;
			var controlLine:Line = new Line(fulcrum, __control);
			controlLine.angle += value;
			var endLine:Line = new Line(fulcrum, __end);
			endLine.angle += value;
		}

		/**
		 * Смещает кривую на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 * 
		 */		
		public function offset(dx:Number, dy:Number):void {
			__start.offset(dx, dy);
			__end.offset(dx, dy);
		}

		
		/**
		 * Вычисляет time-итератор точки, находящейся на заданной дистанции
		 * по кривой от точки <code>start</code><BR/>
		 * <BR/>
		 * 
		 * @param distance:Number дистанция по кривой до искомой точки.
		 * 
		 * @return Number time iterator of bezier point;
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 * 
		 *	trace(bezier.getTimeByDistance(-10); // negative value
		 *	trace(bezier.getTimeByDistance(bezier.length/2); // value between 0 and 1
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #getPoint
		 */

		public function getTimeByDistance(distance:Number):Number {
			if (isNaN(distance)) {
				return 0;
			}
			var arcLength:Number;
			var diffArcLength:Number;
			var curveLength:Number = length;
			var time:Number = distance/curveLength;
			
			if (isSegment) {
				if (distance <= 0) {
					return 0;
				}
				if (distance >= curveLength) {
					return 1;
				}
			}
			var csX:Number = __control.x - __start.x;
			var csY:Number = __control.y - __start.y;
			var ecX:Number = __end.x - __control.x;
			var ecY:Number = __end.y - __control.y;
			var nvX:Number = ecX - csX;
			var nvY:Number = ecY - csY;
	
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			var c0:Number = 4*(csX*csX + csY*csY);
			var c1:Number = 8*(csX*nvX + csY*nvY);
			var c2:Number = 4*(nvX*nvX + nvY*nvY);
			
			var c025:Number = c0 - 0.25*c1*c1/c2;
			var f0Base:Number = 0.25*c1*Math.sqrt(c0)/c2;
			var exp2:Number = 0.5*c1/Math.sqrt(c2) + Math.sqrt(c0);
	
			var c00sqrt:Number = Math.sqrt(c0);
			var c20sqrt:Number = Math.sqrt(c2);
			var c22sqrt:Number;
			
			var exp1:Number;
			var ft:Number;
			var ftBase:Number;
			
			var f0:Number;
			var maxIterations:Number = 100;
	
			if (c2 == 0) {
				if (c1 == 0) {
					do {
						arcLength = c00sqrt*time;
						diffArcLength = Math.sqrt(Math.abs((c2*time*time + c1*time + c0))) || PRECISION; 
						time = time - (arcLength - distance)/diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				} else {
					do {
						arcLength = (2/3)*(c1*time + c0)*Math.sqrt(c1*time + c0)/c1 - (2/3)*c0*c00sqrt/c1; 
						diffArcLength = Math.sqrt(Math.abs((c2*time*time + c1*time + c0))) || PRECISION;
						time = time - (arcLength - distance)/diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				}
			} else {
				do {
					c22sqrt = Math.sqrt(Math.abs(c2*time*time + c1*time + c0));
					exp1 = (0.5*c1 + c2*time)/c20sqrt + c22sqrt;
					ftBase = 0.25*(2*c2*time + c1)*c22sqrt/c2;
					if (exp1 < PRECISION) {
						ft = ftBase;
					} else {
						ft = ftBase + 0.5*Math.log((0.5*c1 + c2*time)/c20sqrt + c22sqrt)/c20sqrt*c025;
					}
					if (exp2 < PRECISION) {
						f0 = f0Base;
					} else {
						f0 = f0Base + 0.5*Math.log((0.5*c1)/c20sqrt + c00sqrt)/c20sqrt*c025;
					}
					arcLength = ft - f0;
					diffArcLength = c22sqrt || PRECISION; 
					time = time - (arcLength - distance)/diffArcLength;
				} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
			}
			
			return time;
		}

		/**  
		 * Вычисляет и возвращает массив time-итераторов точек, 
		 * находящихся друг от друга на дистанции по кривой,
		 * заданной параметром <code>step</code>.<BR/>
		 * Если задан параметр <code>startShift</code>, то расчет производится
		 * не от точки <code>start</code>, а от точки на кривой, находящейся на 
		 * заданнй этим параметром дистанции.<BR/>
		 * Значение startShift конвертируется в остаток от деления на step.<BR/> 
		 * 
		 * 
		 * @param step:Number шаг, дистанция по кривой между точками.
		 * @param startShift:Number дистанция по кривой, задающая смещение первой 
		 * точки последовательности относительно точки <code>start</code>
		 *  
		 * @return Array sequence of points on bezier curve;
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 *	
		 *	// TODO
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getTimesSequence(step:Number, startShift:Number = 0):Array {

			step = Math.abs(step);
			var distance:Number = startShift;
			
			var times:Array = new Array();
			var curveLength:Number = length;
			if (distance > curveLength) {
				return times;
			}
			
			if (distance < 0) {
				distance = distance%step + step;
			} else {
				distance = distance%step;
			}

			var csX:Number = __control.x - __start.x;
			var csY:Number = __control.y - __start.y;
			var ecX:Number = __end.x - __control.x;
			var ecY:Number = __end.y - __control.y;
			var nvX:Number = ecX - csX;
			var nvY:Number = ecY - csY;
			
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			var c0:Number = 4*(csX*csX + csY*csY);
			var c1:Number = 8*(csX*nvX + csY*nvY);
			var c2:Number = 4*(nvX*nvX + nvY*nvY);
	
			var arcLength:Number;
			var diffArcLength:Number;
			
			var time:Number = distance/curveLength;
			
			var c025:Number = c0 - 0.25*c1*c1/c2;
			var f0Base:Number = 0.25*c1*Math.sqrt(c0)/c2;
			var exp2:Number = 0.5*c1/Math.sqrt(c2) + Math.sqrt(c0);
	
			var c00sqrt:Number = Math.sqrt(c0);
			var c20sqrt:Number = Math.sqrt(c2);
			// var c21sqrt:Number = c20sqrt*(c025);
			var c22sqrt:Number;
			
			var exp1:Number;
			var ft:Number;
			var ftBase:Number;
			
			var f0:Number;
			
			while (distance <= curveLength) {
				var limiter:Number = 20;
		
				if (c2 == 0) {
					if (c1 == 0) {
						do {
							arcLength = c00sqrt*time;
							diffArcLength = Math.sqrt(Math.abs(c2*time*time + c1*time + c0)) || PRECISION; 
							time = time - (arcLength - distance)/diffArcLength;
						} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
					} else {
						do {
							arcLength = (2/3)*((c1*time + c0)*Math.sqrt(Math.abs(c1*time + c0)) - c0*c00sqrt)/c1; 
							diffArcLength = Math.sqrt(Math.abs(c2*time*time + c1*time + c0)) || PRECISION;
							time = time - (arcLength - distance)/diffArcLength;
						} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
					}
				} else {
					do {
						c22sqrt = Math.sqrt(Math.abs(c2*time*time + c1*time + c0));
						exp1 = (0.5*c1 + c2*time)/c20sqrt + c22sqrt;
						ftBase = 0.25*(2*c2*time + c1)*c22sqrt/c2;
						if (exp1 < PRECISION) {
							ft = ftBase;
						} else {
							ft = ftBase + 0.5*Math.log((0.5*c1 + c2*time)/c20sqrt + c22sqrt)/c20sqrt*c025;
						}
						if (exp2 < PRECISION) {
							f0 = f0Base;
						} else {
							f0 = f0Base + 0.5*Math.log((0.5*c1)/c20sqrt + c00sqrt)/c20sqrt*c025;
						}
						arcLength = ft - f0;
						diffArcLength = c22sqrt || PRECISION; 
						time = time - (arcLength - distance)/diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
				}
				 
				times[times.length] = time;
				distance += step;
			}
			
			return times;
		}

		
		
		
		//**************************************************
		//				CHANGE BEZIER
		//**************************************************
		
		
		/**
		 * Изменяет кривую таким образом, что заданная параметром time точка кривой <code>P<sub>t</sub></code>, 
		 * будет находиться в заданных параметрами <code>x</code> и <code>y</code> координатах.<BR/>
		 * Если один из параметров <code>x</code> или <code>y</code> не задан, 
		 * то точка <code>P<sub>t</sub></code> не изменит значение соответствующей координаты.
		 * 
		 * @param time:Number time-итератор точки кривой.
		 * @param x:Number новое значение позиции точки по оси X.
		 * @param y:Number новое значение позиции точки по оси Y.
		 * 
		 * @return void;
		 * 
		 * @example 
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 *	trace(bezier);
		 *	
		 *	bezier.setPoint(0, 0, 0);
		 *	bezier.setPoint(0.5, 100, 100);
		 *	bezier.setPoint(1, 200, 0);
		 *	
		 *	trace(bezier); // (start:(x=0, y=0), control:(x=100, y=200), end:(x=200, y=0))
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function setPoint(time:Number, x:Number = undefined, y:Number = undefined):void {
			if ((isNaN(x) && isNaN(y))) {
				return;
			}
			
			var f:Number = 1 - time;
			var tSquared:Number = time*time;
			var fSquared:Number = f*f;
			var tf:Number = 2*time*f;
			
			if (isNaN(x)) {
				x = __start.x*fSquared + __control.x*2*tf + __end.x*tSquared;
			}
			if (isNaN(y)) {
				y = __start.y*fSquared + __control.y*2*tf + __end.y*tSquared;
			}
			
			switch (time) {
				case 0:
					__start.x = x;
					__start.y = y; 
					break;
				case 1:
					__end.x = x; 
					__end.y = y; 
					break;
				default: 
					__control.x = (x - __end.x*tSquared - __start.x*fSquared)/tf;
					__control.y = (y - __end.y*tSquared - __start.y*fSquared)/tf;
			}
		}

		
		
		
		
		//**************************************************
		//				BEZIER AND EXTERNAL POINTS
		//**************************************************

		/**
		 * <P>Вычисляет и возвращает time-итератор точки на кривой, 
		 * ближайшей к точке <code>fromPoint</code>.<BR/>
		 * В зависимости от значения свойства <a href="#isSegment">isSegment</a>
		 * возвращает либо значение в пределах от 0 до 1 или от минус 
		 * бесконечности до плюс бесконечности.</P>
		 * 
		 * @param fromPoint:Point произвольная точка на плоскости.
		 * @return Number time-итератор точки на кривой.
		 * 
		 * @example
		 * Синим цветом обозначена кривая Безье, ограниченная точками __start, end, а также линия до ближайшей точки на ней. Свойство <code>isSegment=true;</code> <BR/>
		 * Красным цветом обозначена неограниченная кривая, а также линия до ближайшей точки на ней. Свойство <code>isSegment=false;</code>
		 * <P>
		 * <table width="100%" border=1><td>
		 * <a name="closest_point_demo"></a>
		 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 *			id="Step1Building" width="100%" height="500"
		 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		 *			<param name="movie" value="../../images/Step02ClosestPoint.swf" />
		 *			<param name="quality" value="high" />
		 *			<param name="bgcolor" value="#FFFFFF" />
		 *			<param name="allowScriptAccess" value="sameDomain" />
		 *			<embed src="../../images/Step02ClosestPoint.swf" quality="high" bgcolor="#FFFFFF"
		 *				width="100%" height="400" name="Step1Building"
		 * 				align="middle"
		 *				play="true"
		 *				loop="false"
		 *				quality="high"
		 *				allowScriptAccess="sameDomain"
		 *				type="application/x-shockwave-flash"
		 *				pluginspage="http://www.adobe.com/go/getflashplayer">
		 *			</embed>
		 *	</object>
		 * </td></table>
		 * </P>
		 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR>
		 * <I>Перемещайте мышью контрольные точки кривой.</I></P>
		 * <BR/>
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @see #isSegment
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 **/

		public function getClosest(fromPoint:Point):Number {
			if (!(fromPoint as Point)) {
				return NaN;
			}
			var sx:Number = __start.x;
			var sy:Number = __start.y;
			var cx:Number = __control.x;
			var cy:Number = __control.y;
			var ex:Number = __end.x;
			var ey:Number = __end.y;
	
			var lpx:Number = sx - fromPoint.x;
			var lpy:Number = sy - fromPoint.y;
			
			var kpx:Number = sx - 2*cx + ex;
			var kpy:Number = sy - 2*cy + ey;
			
			var npx:Number = -2*sx + 2*cx;
			var npy:Number = -2*sy + 2*cy;
			
			var delimiter:Number = 2*(kpx*kpx + kpy*kpy);
			
			var A:Number = 3*(npx*kpx + npy*kpy)/delimiter;
			var B:Number = ((npx*npx + npy*npy) + 2*(lpx*kpx + lpy*kpy))/delimiter;
			var C:Number = (npx*lpx + npy*lpy)/delimiter;
			
			var extremumTimes:Array = solveQubicEquation(A, B, C);
			
			if (isSegment) {
				extremumTimes.push(0);
				extremumTimes.push(1);
			}
			
			var extremumTime:Number;
			var extremumPoint:Point;
			var extremumDistance:Number;
			
			var nearestTime:Number;
			var nearestDistance:Number;
			
			var isInside:Boolean;
			
			var len:uint = extremumTimes.length;
			for (var i:uint = 0;i < len; i++) {
				extremumTime = extremumTimes[i];
				extremumPoint = getPoint(extremumTime);
				
				// PROBLEM!!!!!
				// trace("extremumDistance: "+extremumTime);
				extremumDistance = Point.distance(fromPoint, extremumPoint);
				
				isInside = (extremumTime >= 0) && (extremumTime <= 1);
				
				if (isNaN(nearestTime)) {
					if (!isSegment || isInside) {
						nearestTime = extremumTime;
						nearestDistance = extremumDistance;
					}
					continue;
				}
				
				if (extremumDistance < nearestDistance) {
					if (!isSegment || isInside) {
						nearestTime = extremumTime;
						nearestDistance = extremumDistance;
					}
				}
			}
			
			return nearestTime;
		}

		
		
		//**************************************************
		//				WORKING WITH SEGMENTS
		//**************************************************
		
		/**
		 * Вычисляет и возвращает сегмент кривой Безье.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Bezier;
		 * 
		 * @example 
		 * В данном примере на основе случайной кривой Безье создаются еще две.
		 * Первая из них - <code>segment1</code> 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 * var bezier:Bezier = randomBezier();
		 * var segment1:Bezier = bezier.getSegment(1/3, 2/3);
		 * var segment2:Bezier = bezier.getSegment(-1, 2);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */
		public function getSegment(fromTime:Number = 0, toTime:Number = 1):Bezier {
			var segmentStart:Point = getPoint(fromTime);
			var segmentEnd:Point = getPoint(toTime);
			var segmentVertex:Point = getPoint((fromTime + toTime)/2);
			var baseMiddle:Point = Point.interpolate(segmentStart, segmentEnd, 1/2);
			var segmentControl:Point = Point.interpolate(segmentVertex, baseMiddle, 2);
			return new Bezier(segmentStart, segmentControl, segmentEnd, true);
		}

		
		//**************************************************
		//				TANGENT OF BEZIER POINT
		//**************************************************


		/**
		 * Tangent is line that touches but does not intersect with bezier.
		 * Computes and returns the angle of tangent line in radians. 
		 * The return value is between positive pi and negative pi. 
		 * 
		 * @param t:Number time of bezier point
		 * @return Number angle in radians;
		 * 
		 * @example 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 * </listing>
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getTangentAngle(time:Number = 0):Number {
			var t0X:Number = __start.x + (__control.x - __start.x)*time;
			var t0Y:Number = __start.y + (__control.y - __start.y)*time;
			var t1X:Number = __control.x + (__end.x - __control.x)*time;
			var t1Y:Number = __control.y + (__end.y - __control.y)*time;
			
			var distanceX:Number = t1X - t0X;
			var distanceY:Number = t1Y - t0Y;
			return Math.atan2(distanceY, distanceX);
		}

		//**************************************************
		//				INTERSECTIONS 
		//**************************************************

		/**
		 * @param line:Line
		 * @return Intersection
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 * </listing>
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see Intersection
		 * @see Line
		 * 
		 */

		
		public function intersectionLine(line:Line):Intersection {
			var intersection:Intersection = new Intersection();
			
			var sX:Number = __start.x;
			var sY:Number = __start.y;
			var cX:Number = __control.x;
			var cY:Number = __control.y;
			var eX:Number = __end.x;
			var eY:Number = __end.y;
			var oX:Number = line.start.x;
			var oY:Number = line.start.y;
			var lineAngle:Number = line.angle;
			var cosa:Number = Math.cos(lineAngle);
			var sina:Number = Math.sin(lineAngle);
			//
			var time0:Number;
			var time1:Number;
			var lineTime0:Number;
			var lineTime1:Number;
			var intersectionPoint0:Point;
			var intersectionPoint1:Point;
			var distanceX:Number = line.end.x - line.start.x;
			var distanceY:Number = line.end.y - line.start.y;
			var checkByX:Boolean = Math.abs(distanceX) > Math.abs(distanceY);

			
			if (Math.abs(cosa) < 1e-6) {
				cosa = 0; 
			}
			if (Math.abs(sina) < 1e-6) {
				sina = 0;
			}
			
			
			
			var divider:Number = -2*sina*cX + sina*eX + sina*sX + 2*cosa*cY - cosa*eY - cosa*sY;
			if (Math.abs(divider) < 1e-6) {
				divider = 0;
			}
			
			
			if (divider == 0) {
				
				var divider2:Number = (-2*sX + 2*cX)*sina - (-2*sY + 2*cY)*cosa;
				if (divider2 == 0) {
					intersection.currentTimes[0] = 0;
					intersection.currentTimes[1] = 1;
					
					intersectionPoint0 = getPoint(0);
					intersectionPoint1 = getPoint(1);
					
					if (checkByX) {
						lineTime0 = (intersectionPoint0.x - line.start.x)/distanceX;
						lineTime1 = (intersectionPoint1.x - line.start.x)/distanceX;
					} else {
						lineTime0 = (intersectionPoint0.y - line.start.y)/distanceY;
						lineTime1 = (intersectionPoint1.y - line.start.y)/distanceY;
					}
				} else {
					time0 = -((sX - oX)*sina - (sY - oY)*cosa)/divider2;
					intersection.currentTimes[0] = time0;
					intersectionPoint0 = getPoint(time0);
				}
				
				return intersection;
			} 
			
			var discriminant:Number = +cosa*cosa*(sY*oY + cY*cY - eY*sY - 2*cY*oY + eY*oY) + sina*cosa*(-sY*oX - eY*oX - 2*cY*cX + eX*sY - sX*oY + 2*cY*oX + 2*cX*oY + eY*sX - eX*oY) + sina*sina*(eX*oX + sX*oX - 2*cX*oX + cX*cX - eX*sX);
			
			
			
			if (discriminant < 0) {
				return null;
			}
			
			var a:Number = -2*cosa*sY + 2*sina*sX + 2*cosa*cY - 2*sina*cX;
			var c:Number = 2*divider;
			
			var outsideBezier0:Boolean;
			var outsideLine0:Boolean;
			var outsideBezier1:Boolean;
			var outsideLine1:Boolean;
			
			if (discriminant == 0) {
				time0 = a/c;
				
				outsideBezier0 = time0 < 0 || time0 > 1;
				if (isSegment && outsideBezier0) {
					return null;
				}
				
				intersectionPoint0 = getPoint(time0);
				
				if (checkByX) {
					lineTime0 = (intersectionPoint0.x - line.start.x)/distanceX;
				} else {
					lineTime0 = (intersectionPoint0.y - line.start.y)/distanceX;
				}
				
				outsideLine0 = lineTime0 < 0 || lineTime0 > 1;
				
				if (line.isSegment && outsideLine0) {
					return null;
				}
				
				intersection.currentTimes[0] = time0;
				intersection.oppositeTimes[0] = lineTime0;
				
				return intersection;
			}
			
			// if discriminant > 0

			var b:Number = 2*Math.sqrt(discriminant);
			time0 = (a - b)/c;
			time1 = (a + b)/c;
			
			outsideBezier0 = time0 < 0 || time0 > 1;
			outsideBezier1 = time1 < 0 || time1 > 1;
			
			if (isSegment && outsideBezier0 && outsideBezier1) {
				return null;
			}
			
			intersectionPoint0 = getPoint(time0);
			intersectionPoint1 = getPoint(time1);
			
			
			if (distanceX) {
				lineTime0 = (intersectionPoint0.x - line.start.x)/distanceX;
				lineTime1 = (intersectionPoint1.x - line.start.x)/distanceX;
			} else {
				lineTime0 = (intersectionPoint0.y - line.start.y)/distanceY;
				lineTime1 = (intersectionPoint1.y - line.start.y)/distanceY;
			}
			
			outsideLine0 = lineTime0 < 0 || lineTime0 > 1;
			outsideLine1 = lineTime1 < 0 || lineTime1 > 1;

			if (line.isSegment && outsideLine0 && outsideLine1) {
				return null;
			}
			
			if (isSegment) {
				if (line.isSegment) {
					if (!outsideBezier0 && !outsideLine0) {
						intersection.currentTimes.push(time0);
						intersection.oppositeTimes.push(lineTime0);
					}
					if (!outsideBezier1 && !outsideLine1) {
						intersection.currentTimes.push(time1);
						intersection.oppositeTimes.push(lineTime1);
					}
				} else {
					if (!outsideBezier0) {
						intersection.currentTimes.push(time0);
						intersection.oppositeTimes.push(lineTime0);
					}
					if (!outsideBezier1) {
						intersection.currentTimes.push(time1);
						intersection.oppositeTimes.push(lineTime1);
					}
				}
				if (!intersection.currentTimes.length) {
					return null;
				}
				return intersection;
			}
			
			// if !this.isSegment

			if (line.isSegment) {
				if (!outsideLine0) {
					intersection.currentTimes.push(time0);
					intersection.oppositeTimes.push(lineTime0);
				}
				if (!outsideLine1) {
					intersection.currentTimes.push(time1);
					intersection.oppositeTimes.push(lineTime1);
				}
				if (!intersection.currentTimes.length) {
					return null;
				}
				return intersection;
			}
			
			// if !this.isSegment && !line.isSegment
			intersection.currentTimes.push(time0);
			intersection.oppositeTimes.push(lineTime0);
			intersection.currentTimes.push(time1);
			intersection.oppositeTimes.push(lineTime1);
			return intersection;
		}

		
		/**
		 * 
		 * @param target:Bezier
		 * @return Intersection
		 * 
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	var bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */		

		public function intersectionBezier(target:Bezier):Intersection {
			var vertexTime:Number = target.parabolaVertex;
			var targetParabolaVertex:Point = target.getPoint(vertexTime);
			var tpvX:Number = targetParabolaVertex.x;
			var tpvY:Number = targetParabolaVertex.y;
			
			var nX:Number = 2*vertexTime*(target.__start.x - 2*target.__control.x + target.__end.x) + 2*(target.__control.x - target.__start.x);
			var nY:Number = 2*vertexTime*(target.__start.y - 2*target.__control.y + target.__end.y) + 2*(target.__control.y - target.__start.y);

			var angle:Number = -Math.atan2(nY, nX);
			var angleSin:Number = Math.sin(angle);
			var angleCos:Number = Math.cos(angle);
			
			// target
			var teX:Number = tpvX - target.__end.x;
			var teY:Number = tpvY - target.__end.y;
			
			var e1_x:Number = teX*angleCos - teY*angleSin;
			var e1_y:Number = teX*angleSin + teY*angleCos;
			
			if (e1_y < 0) {
				return intersectionBezier(new Bezier(target.__end, target.__control, target.__start, isSegment));
			}
			
//			var tsX:Number = tpvX-target.__start.x;
//			var tsY:Number = tpvY-target.__start.y;
//			var tcX:Number = tpvX-target.__control.x;
//			var tcY:Number = tpvY-target.__control.y;
			
			// current
			var csX:Number = tpvX - __start.x;
			var csY:Number = tpvY - __start.y;
			var sX:Number = csX*angleCos - csY*angleSin;
			var sY:Number = csX*angleSin + csY*angleCos;
			
			var ccX:Number = tpvX - __control.x;
			var ccY:Number = tpvY - __control.y;
			var cX:Number = ccX*angleCos - ccY*angleSin;
			var cY:Number = ccX*angleSin + ccY*angleCos;
			
			var ceX:Number = tpvX - __end.x;
			var ceY:Number = tpvY - __end.y;
			var eX:Number = ceX*angleCos - ceY*angleSin;
			var eY:Number = ceX*angleSin + ceY*angleCos;
			
//			var sf2_x:Number = tsX*angleCos-tsY*angleSin;
//			var sf2_y:Number = tsX*angleSin+tsY*angleCos;
//			var sf2:Point = new Point(tsX*angleCos-tsY*angleSin, tsX*angleSin+tsY*angleCos);
//			var cf2:Point = new Point(tcX*angleCos-tcY*angleSin, tcX*angleSin+tcY*angleCos);
//			var ef2:Point = new Point(teX*angleCos-teY*angleSin, teX*angleSin+teY*angleCos);

			var k:Number = Math.sqrt(e1_y)/e1_x;
			sX *= k;
			cX *= k;
			eX *= k;
			
			var A:Number = (sX - 2*cX + eX)*(sX - 2*cX + eX);
			var B:Number = 4*(sX - 2*cX + eX)*(cX - sX);
			var C:Number = 4*(cX - sX)*(cX - sX) + 2*sX*(sX - 2*cX + eX) - (sY - 2*cY + eY);
			var D:Number = 4*sX*(cX - sX) - 2*(cY - sY);
			var E:Number = sX*sX - sY;
			
			var solves:Array = Equations.solveEquation(A, B, C, D, E);
			var intersection:Intersection = new Intersection();
			
			var i:uint;
			var len:uint = solves.length;
			var time:Number;
			if (!isSegment && !target.isSegment) {
				for (i = 0;i < len; i++) {
					intersection.currentTimes[i] = solves[i];
				}
				return intersection;
			}
			
			if (!target.isSegment) {
				for (i = 0;i < len; i++) {
					time = solves[i];
					if (time >= 0 && time <= 1) {
						intersection.currentTimes.push(time);
					}
				}
				return intersection;
			}
			
			// TODO: check if point on target segment
			for (i = 0;i < len; i++) {
				time = solves[i];
				intersection.currentTimes.push(time);
			}
			
			return intersection;
		}

		
		
		//**************************************************
		//				UTILS 
		//**************************************************
		/**
		 * 
		 * @return String 
		 * 
		 */
		public function toString():String {
			return 	"(start:" + __start + ", control:" + __control + ", end:" + __end + ")";
		}

		//**************************************************
		//				PRIVATE 
		//**************************************************

		protected function solveQubicEquation(a:Number, b:Number, c:Number):Array {
			var a_3:Number = -a/3;
			var aa:Number = a*a;
			var aaa:Number = aa*a;
	 
			var q:Number = (aa - 3*b)/9;
			var qqq:Number = q*q*q;
			
			var r:Number = (2*aaa - 9*a*b + 27*c)/54;
			var rr:Number = r*r;
			
			var x1:Number;
			var x2:Number;
			
			if (rr < qqq) {
				var t:Number = Math.acos(r/Math.sqrt(qqq))/3;
				var sqrt_q:Number = -2*Math.sqrt(q);
				x1 = sqrt_q*Math.cos(t) + a_3;
				x2 = sqrt_q*Math.cos(t + (2/3*Math.PI)) + a_3;
				var x3:Number = sqrt_q*Math.cos(t - (2/3*Math.PI)) + a_3;
				return [x1, x2, x3];
			} else {
				var abs_r:Number = Math.abs(r); 
				var a2:Number = -r/abs_r*Math.pow(abs_r + Math.sqrt(rr - qqq), 1/3);
				var b2:Number;
				if (a2 != 0) {
					b2 = q/a2;
				} else {
					b2 = 0;
				}
				x1 = (a2 + b2) + a_3;
				if (a2 == b2) {
					x2 = a_3 - a2;
					return [x1, x2];
				}
				return [x1];
			}
		};
	}
}
