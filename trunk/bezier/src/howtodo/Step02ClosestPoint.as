package howtodo {
	import flash.events.MouseEvent;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	
	/**
	 * @example
	 * Синим цветом обозначена кривая Безье, ограниченная точками start, end, а также линия до ближайшей точки на ней. Свойство <code>isSegment=true;</code> <BR/>
	 * Красным цветом обозначена неограниченная кривая, а также линия до ближайшей точки на ней. Свойство <code>isSegment=false;</code>
	 * <P><a name="closest_point_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../images/Step02ClosestPoint.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../images/Step02ClosestPoint.swf" quality="high" bgcolor="#FFFFFF"
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
	 * 	</td></table>
	 * </P>
	 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR>
	 * <I>Перемещайте мышью контрольные точки кривой.</I></P>
	 * <BR/>
	 * 
	 **/
	
	
	public class Step02ClosestPoint extends BezierUsage {
		
		private static const DESCRIPTION:String = "Red line - isSegment=false <BR/>Blue line - isSegment=true"
		
		private const closestUnlimited:PointView = new PointView();
		private const closestLimited:PointView = new PointView();
		private const mouse:Point = new Point();
		
		private var unlimited:Line;
		private var limited:Line;
		
		public function Step02ClosestPoint () {
			super();
		}
		
		override protected function init():void {
			super.init()
			
			initDescription(DESCRIPTION);
			
			unlimited = new Line(start.point, control.point);
			limited = new Line(control.point, end.point);
			
			start.x = stage.stageWidth*.1;
			start.y = stage.stageHeight*.9;
			control.x = stage.stageWidth*.7;
			control.y = stage.stageHeight*.1;
			end.x = stage.stageWidth*.7;
			end.y = stage.stageHeight*.2;
			
			addChild(closestUnlimited);
			addChild(closestLimited);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			redraw();
		}
		
		private function onMouseMove(event:MouseEvent=undefined):void {
			mouse.x = event.stageX;
			mouse.y = event.stageY;
			
			redraw();
		}
		
		private function redraw ():void {
			bezier.isSegment = false;
			var unlimitedTime:Number = bezier.getClosest(mouse);
			bezier.isSegment = true;
			var limitedTime:Number = bezier.getClosest(mouse);
			
			start.visible = unlimitedTime !=0 && limitedTime !=0;
			end.visible = unlimitedTime !=1 && limitedTime !=1;
			
			closestUnlimited.position = bezier.getPoint(unlimitedTime);
			closestLimited.position = bezier.getPoint(limitedTime);
			
			closestUnlimited.pointName = "P("+round(unlimitedTime, 3)+")";
			closestLimited.pointName = "P("+round(limitedTime, 3)+")";
			
			graphics.clear();
			
			graphics.lineStyle(0, 0xFF0000, .5)
			drawBezier(bezier.getSegment(-1, 2));
			graphics.lineStyle(0, 0x0000FF, 1)
			drawBezier(bezier);
			
			graphics.lineStyle(0, 0xFF0000, .5)
			drawLine(new Line(mouse, closestUnlimited.point));
			graphics.lineStyle(0, 0x0000FF, 1)
			drawLine(new Line(mouse, closestLimited.point));
		}


		

	}
}