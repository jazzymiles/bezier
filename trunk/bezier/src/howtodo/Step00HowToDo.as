package howtodo {
	
	
	public class Step00HowToDo extends BezierUsage {
		
		private static const DESCRIPTION:String = "Use 1-9 Keys to view examples";
		
		public function Step00HowToDo () {
			super();
		}
		
		override protected function init():void {
		//	super.init();
			initDescription(DESCRIPTION);
		}	
	}
}