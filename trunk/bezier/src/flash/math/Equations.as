package flash.math {

	//=============================================================================================================
	//
	//                                 class Equations 
	//                        from package ru.bezier.math
	//
	//                             by Alexander Sergeyev
	//                                   BEZIER.RU
	//                              a.sergeyev@gmail.com
	//
	//                           Russia  Samara  06.02.2007
	//==============================================================================================================
	
	/**
	 * В классе представлены методы для решения уравнений с 1 неизвестным.<BR/>
	 * Если в уравнении n-ой степени ведущие коэффициенты нулевые, то все равно можно 
	 * использовать метод для n-ой степени, нужный метод перевызовется автоматически.<BR/>
	 * Погрешность решения составляет порядка 10^-5. <BR/>
	 * Можно использовать универсальную функцию, при этом сдедует быть внимательным с параметрами.
	 * @author Alexander Sergeyev
	 * @since 2006
	 * @version 0.2 alpha
	 */

	public class Equations {
		private static var eps:Number = 0.00001;

		/** Универсальная функция для решения уравнений c одним неизвестным. <BR/>
		 * Осуществляет перевызов на соответствующий метод, в зависимости от количества параметров. <BR/>
		 * Параметры означают коэффициенты при степенях переменной, начиная от старшей степени и заканчивая свободным членом.<BR/>
		 * 
		 * @param _a:Number —  коэффициент при старшей степени.
		 * @param _b:Number — коэффициент при следующей степени.
		 * @param _c:Number — коэффициент при следующей степени.
		 * @param _d:Number — коэффициент при следующей степени.
		 * @param _e:Number — коэффициент при следующей степени.
		 *
		 * @return Array — Массив с корнями уравнения.
		 * Если действительных корней нет, либо их бесконечно много, возвращает пустой массив.
		 * 
		 * @example
		 * <pre>
		 *	import ru.bezier.math.Equations
		 *	
		 *	var solutions = Equations.solveEquation(1,0,3,4); // x^3+3*x+4=0
		 *	trace(solutions);
		 * </pre>
		 **/
		 

		public static function solveEquation(_a:Number, _b:Number, _c:Number, _d:Number, _e:Number):Array {
			var argsLength:uint = arguments["length"]; 
			switch (argsLength) {
				case 2 :
					return solveLinearEquation(_a, _b);
				case 3 :
					return solveQuadraticEquation(_a, _b, _c);
				case 4 :
					return solveCubicEquation(_a, _b, _c, _d);
				case 5 :
					return solveQuarticEquation(_a, _b, _c, _d, _e);
				default :
					return [];
			}
		}

		/** Функция для решения линейного уравнения, записанного в форме ax + b = 0
		 *
		 * @param _a:Number — коэффициент при x
		 * @param _b:Number — свободный член
		 * 
		 * @return Array — Массив с корнями уравнения.
		 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив.
		 *
		 * @example
		 * <pre>
		 *	import ru.bezier.math.Equations
		 *	var solutions = Equations.solveEquation(1,3); // x+3=0
		 *	trace(solutions);
		 * </pre>
		 * @see solveEquation
		 **/

		public static function solveLinearEquation(_a:Number, _b:Number):Array {
			
			if (Math.abs(_a) < eps*eps)
				_a = 0;
			
			if (_a != 0) {
				return [-_b/_a];
			}
			return [];
		}

		
		/** Функция для решения квадратичного уравнения, записанного в форме ax^2 + bx + c = 0 
		 *	
		 * @param _a:Number — коэффициент при x^2
		 * @param _b:Number — коэффициент при x
		 * @param _c:Number — свободный член
		 *
		 * @return Array — Возвращает массив с корнями уравнения. 
		 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
		 *
		 * @example
		 * <pre>
		 *	import ru.bezier.math.Equations
		 *	var solutions = Equations.solveEquation(3,4,1); // 3*x^2+4*x+1=0
		 *	trace(solutions);
		 * </pre>
		 * @see solveEquation
		 **/
		 
		public static function solveQuadraticEquation(_a:Number, _b:Number, _c:Number):Array {
			
			if (Math.abs(_a) < eps*eps)
				_a = 0;
							
			if (_a == 0) {
				return solveLinearEquation(_b, _c);
			}
			var b:Number = _b/_a;
			var c:Number = _c/_a;
			
			if (Math.abs(b) < eps*eps)
				b = 0;
			if (Math.abs(c) < eps*eps)
				c = 0;

			var d:Number = b*b - 4*c;
			
			if (Math.abs(d) < eps*eps)
				d = 0;
				
			if (d > 0) {
				d = Math.sqrt(d);
				return [(-b - d)/2, (-b + d)/2];
			} else if (d == 0) {
				return [-b/2];
			}
			return [];
		}

		/** Функция для решения кубического уравнения, записанного в форме ax^3 + bx^2 + cx + d = 0
		 * 
		 * @param _a:Number — коэффициент при x^3
		 * @param _b:Number — коэффициент при x^2
		 * @param _c:Number — коэффициент при x
		 * @param _d:Number — свободный член
		 *
		 * @return Array — массив с корнями уравнения. 
		 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
		 *
		 * @example
		 * <pre>
		 *	import ru.bezier.math.Equations
		 *	var solutions = Equations.solveEquation(1,0,3,4); // x^3+3*x+4=0
		 *	trace(solutions);
		 * </pre>
		 * @see solveEquation
		 **/
		 
		public static function solveCubicEquation(_a:Number, _b:Number, _c:Number, _d:Number):Array {
						
			if (Math.abs(_a) < eps*eps)
				_a = 0;
			
			if (_a == 0) {
				return solveQuadraticEquation(_b, _c, _d);
			}
			var b:Number = _b/_a;
			var c:Number = _c/_a;
			var d:Number = _d/_a;
			
			if (Math.abs(b) < eps*eps)
				b = 0;
			if (Math.abs(c) < eps*eps)
				c = 0;
			if (Math.abs(d) < eps*eps)
				d = 0;
			
			
			var p:Number, q:Number, u:Number, v:Number, d1:Number, X:Number;
			p = -b*b/3 + c;
			q = 2*b*b*b/27 - b*c/3 + d;
			d1 = q*q/4 + p*p*p/27;
			if (d1 >= 0) {
				d1 = Math.sqrt(d1);
				u = Power(-q/2 + d1, 1/3);
				v = Power(-q/2 - d1, 1/3);
				X = u + v - b/3;
			} else {
				X = 2*Math.sqrt(-p/3)*Math.cos(Arg(-q/2, Math.sqrt(Math.abs(d1)))/3) - b/3;
			}
			var quadratic_solve:Array = solveQuadraticEquation(1, X + b, X*X + b*X + c);
			if ((quadratic_solve[0] != X) && (quadratic_solve[1] != X)) {
				quadratic_solve.push(X);
			}
			return quadratic_solve;
		}

		/** Функция для решения уравнения четвертой степени, записанного в форме ax^4 + bx^3 + cx^2 + dx + e = 0
		 * 
		 * @param _a:Number — коэффициент при x^4
		 * @param _b:Number — коэффициент при x^3
		 * @param _c:Number — коэффициент при x^2
		 * @param _d:Number — коэффициент при x
		 * @param _e:Number — свободный член
		 *
		 * @return Array — массив с корнями уравнения. 
		 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
		 *
		 * @example
		 * <pre>
		 *	import ru.bezier.math.Equations
		 *	var solutions = Equations.solveEquation(1,0,3,4,2); // x^4+3*x^2+4*x+2=0
		 *	trace(solutions);
		 * </pre>
		 * @see solveEquation
		 **/
		 
		public static function solveQuarticEquation(_a:Number, _b:Number, _c:Number, _d:Number, _e:Number):Array {
			
			if (Math.abs(_a) < eps*eps)
				_a = 0;
														
			if (_a == 0) {
				return solveCubicEquation(_b, _c, _d, _e);
			}
			
			var b:Number = _b/_a;
			var c:Number = _c/_a;
			var d:Number = _d/_a;
			var e:Number = _e/_a;
			
			if (Math.abs(b) < eps*eps)
				b = 0;
			if (Math.abs(c) < eps*eps)
				c = 0;
			if (Math.abs(d) < eps*eps)
				d = 0;
			if (Math.abs(e) < eps*eps)
				e = 0;	
			
			var i:uint;
			var p:Number, q:Number, r:Number, M:Number, N:Number, K:Number, c1:Number, c2:Number;
			
			p = -c;
			q = b*d - 4*e;
			r = -b*b*e + 4*c*e - d*d;
			
			var cubic_solve:Array = solveCubicEquation(1, p, q, r);
			var quartic_solve:Array = new Array();
			M = b*b/4 - c + cubic_solve[0];
			N = b/2*cubic_solve[0] - d;
			K = cubic_solve[0]*cubic_solve[0]/4 - e;
			
//			var range_min2:Number = Math.abs(M)+Math.abs(N)+Math.abs(K);
			if (Math.abs(M) < eps*eps)
				M = 0;
			if (Math.abs(N) < eps*eps)
				N = 0;
			if (Math.abs(K) < eps*eps)
				K = 0;						

//			var ttttt:Number = N*N - 4*M*K;
			//if ((M >= -eps) && (Math.abs(N*N - 4*M*K) < eps*Math.abs(N*N))) {
			if ((M >= 0) && (K >= 0)/* && (Math.abs(N*N - 4*M*K) <= eps*N*N)*/) {
				c1 = b/2 - Math.sqrt(M);
				if (N > 0) {
					c2 = cubic_solve[0]/2 - Math.sqrt(K);
				} else {
					c2 = cubic_solve[0]/2 + Math.sqrt(K);
				}
				quartic_solve = solveQuadraticEquation(1, c1, c2);
				c1 = b/2 + Math.sqrt(M);
				if (N > 0) {
					c2 = cubic_solve[0]/2 + Math.sqrt(K);
				} else {
					c2 = cubic_solve[0]/2 - Math.sqrt(K);
				}
				var quadratic_solve:Array = solveQuadraticEquation(1, c1, c2);
				for (i = 0;i < quadratic_solve.length; i++) {
					quartic_solve.push(quadratic_solve[i]);
				}
			}
			return quartic_solve;
		}

		//-----------------------------------------------------------------------------------------------------------
		
		// PRIVATE
		
		// Функция для возведения в степень. Работает лучше, чем Math.pow, но все равно не идеально.
		// Идеальная функция возведения в произвольную действительную степень будет иметь комплексный результат.
		private static function Power(x:Number, p:Number):Number {
			if (x > 0) {
				return Math.exp(Math.log(x)*p);
			} else if (x < 0) {
				return -Math.exp(Math.log(-x)*p);
			} else {
				return 0;
			}
		}

		// Функция, аналогичная Math.atan2, только работает для произвольных параметров.
		private static function Arg(dx:Number, dy:Number):Number {
			var a:Number;
			if (dx == 0) {
				a = Math.PI/2;
			} else if (dx > 0) {
				a = Math.atan(Math.abs(dy/dx));
			} else {
				a = Math.PI - Math.atan(Math.abs(dy/dx));
			}
			if (dy >= 0) {
				return a;
			} else {
				return -a;
			}
		}
	}
}
