package com
{
	import mx.controls.Image;
	import mx.charts.chartClasses.StackedSeries;
	import flash.events.MouseEvent;
	import mx.core.DragSource;
	import mx.managers.DragManager;

	public class BlueToken extends Image
	{
		public var format:String;
		
		// constructor
		public function BlueToken(name:String="", source:String="", format:String="")
		{
			//TODO: implement function
			this.source = source;
			this.name = name;
			this.format = format;
			this.addEventListener(MouseEvent.MOUSE_MOVE, tokenMouseMoveHandler);
          
		}
		
		public function tokenMouseMoveHandler(event:MouseEvent):void 
            {
            	var dragSource:DragSource = new DragSource();
            	var dragInitiator:BlueToken=BlueToken(event.currentTarget); 
            	dragSource.addData("format", "token");
            	DragManager.doDrag(dragInitiator, dragSource, event);      
            	
            }   
		
		
	}
}