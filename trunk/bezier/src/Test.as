package {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.FocusEvent;
	import flash.geom.Intersection;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import howtodo.*;

	[SWF(backgroundColor="0xFFFFFF")]

	public class Test extends Sprite {
	
		
		public function Test() {
			
			// 
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 31;
			
			var interval:uint = setInterval(function ():void {
				addChild(new Step01Building());
//				addChild(new Step02ClosestPoint());
//				addChild(new Step03EditDrag());
//				addChild(new Step04EmulationCubic());
//				addChild(new Step05SmoothCurve());
//				addChild(new Step06PointOnBezier());
//				addChild(new Step07PointOnCurve());
//				addChild(new Step08Bounce());
//				addChild(new Step09DashedLine());
//				addChild(new IntersectionsTest());
				clearInterval(interval);
			},100)
			
			var ii:Intersection;
			
			var gridTxt:TextField = new TextField();
			addChild(gridTxt);
			gridTxt.text = PointView.GRID+" - grid step";
			gridTxt.type = TextFieldType.INPUT;
			gridTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			gridTxt.restrict = "0-9";
			
		}
		
		private function onFocusOut(event:FocusEvent):void {
			var gridTxt:TextField = event.target as TextField;
			PointView.GRID = Number(parseInt(gridTxt.text)) || 10;
			gridTxt.text = PointView.GRID+" - grid step";
		}
		
		
	}
}













