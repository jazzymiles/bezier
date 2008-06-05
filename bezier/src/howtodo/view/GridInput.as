package howtodo.view {
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;	

	public class GridInput extends TextField {

		private const GRID_CHANGED : Event = new Event(Event.CHANGE);

		public function GridInput() {
			initInstance();
		}

		private function initInstance() : void {
			type = TextFieldType.INPUT;
			border = true;
			borderColor = 0xCCCCCC;
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			restrict = "0-9";
			maxChars = 3;
			width = 80;
			height = 20;
		}

		private function onFocusIn(event : FocusEvent) : void {
			var currentGrid : uint = (PointView.grid || 10);
			text = currentGrid.toString();
			setSelection(0, 10);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}

		private function onStageMouseUp(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			setSelection(0, length);
		}

		private function onFocusOut(event : FocusEvent) : void {
			PointView.grid = Number(parseInt(text)) || 10;
			if (PointView.grid > 100) {
				PointView.grid = 100;
			} else if (PointView.grid < 10) {
				PointView.grid = 10;
			}
			text = "grid step: " + PointView.grid;
			dispatchEvent(GRID_CHANGED);
		}
	}
}
