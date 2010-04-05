package howtodo 
{
	import flash.utils.clearInterval;	
	import flash.utils.setInterval;	
	import flash.events.Event;	
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextField;	
	import flash.events.MouseEvent;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	
	import howtodo.view.DragPoint;	

	
	public class Step14ClosestPointTimeTest extends BezierUsage 
	{
		
		private static const DESCRIPTION:String = "<B>Closest point time test</B><BR/> every frame does 1000 closest point searches";
		
		private const closestPoint:DragPoint = new DragPoint();
		private const mouse:Point = new Point();
		private var fpsTextField : TextField = new TextField();		
		private var framesCounter:int = 0;
		private var intervalCookie:int = 0;
				
		public function Step14ClosestPointTimeTest () {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedTotageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
		}
		
		override protected function init():void 
		{
			super.init();
			
			initDescription(DESCRIPTION);
									
			start.x = 100;
			start.y = 300;
			control.x = 300;
			control.y = 300;
			end.x = 700;
			end.y = 500;
									
			addTextField(fpsTextField, 100, 80);
			
			addChild(closestPoint);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
			redraw();
		}
		
		private function onAddedTotageHandler(event : Event) : void
		{
			intervalCookie = setInterval(updateFps, 1000);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		private function onRemoveFromStageHandler(event : Event) : void
		{
			clearInterval(intervalCookie);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		private function updateFps() : void
		{
			fpsTextField.text = "FPS: "+framesCounter+"/"+stage.frameRate;
			framesCounter = 0;
		}

		private function onEnterFrameHandler(event:Event) : void
		{
			redraw();
		}

		private function addTextField(textField:TextField, x:Number, y:Number) : void 
		{			
			textField.selectable = false;
			textField.wordWrap = false;
			textField.multiline = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.x = x;
			textField.y = y;
			addChild(textField);
		}		
		
		private function onMouseMoveHandler(event:MouseEvent=undefined):void 
		{
			mouse.x = event.stageX;
			mouse.y = event.stageY;
		}
		
		private function redraw ():void 
		{			
			framesCounter += 1;
						
			var i:int;
			var closestTime:Number;
						
			bezier.isSegment = false;	
			for(i=0; i<1000; i++)
			{
				closestTime = bezier.getClosest(mouse);		
			}
											
			closestPoint.position = bezier.getPoint(closestTime);						
			closestPoint.pointName = "P("+round(closestTime, 3)+")";
						
			graphics.clear();			
			graphics.lineStyle(0, 0xFF0000, .5);
			drawBezier(bezier.getSegment(-1, 2));			
			graphics.lineStyle(0, 0xFF0000, .5);
			drawLine(new Line(mouse, closestPoint.point));								
		}
		
		
		


		

	}
}