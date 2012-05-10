package com
{
	import mx.containers.Canvas;
	import mx.states.State;
	import mx.controls.Button;
	import mx.events.FlexEvent;
	import mx.controls.Alert;
	import flash.events.MouseEvent;
	import mx.containers.VBox;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.core.DragSource;
	import mx.effects.Rotate;
         
	
	[Bindable] 
	public class Card extends Canvas
	{
		// Variable Declaration
		
		public var cardFront:String; // this is the front of the card 
		public var cardBack:String;  // this is for the default card back
		public var runnerOrCorp:String; // faction of the card, used to determine the back image for the card
	//	public var angle:int=0;
		public var cardState:String = "faceDown"; // I may have to make this a :State
		public var isTapped:Boolean = false;
		public var rotate:Rotate = new Rotate(this);
		public var isFanned:Boolean = false;
		public var inHand:Boolean = false;
		
		// Getting ready for the XML file
		public var cid:String;
		public var type:String;
		public var subtype1:String;
		public var subtype2:String;
		public var cost:String;
		public var install_cost:String;
		public var rez_cost:String;
		public var trash_cost:String;
		public var strength:String;
		public var mu:String;
		public var rarity:String;
		public var artist:String;
		public var text:String;
		public var quote:String;
		public var release:String;
		public var difficulty:String;
		public var agenda_points:String;
	
// Constructor
		function Card (name:String="", type:String="", cardFront:String="",runnerOrCorp:String="")
		{
			this.height = 240;
			this.width = 170;
			this.name = name;	
			this.type = type;
			this.cardState = cardState;		
			
			if(runnerOrCorp == "runner") {
				this.cardBack = "images/runner_back.jpg";
			} else if (runnerOrCorp == "corp") {
				this.cardBack = "images/corp_back.jpg"; 
			}
			
			this.cardFront = cardFront;
			this.setStyle("backgroundImage", cardBack);
				
			var myFlipButton:Button = new Button;
			myFlipButton.id = "flipButton";
			myFlipButton.setStyle("fontWeight", "normal");
			myFlipButton.label = "Flip";
			myFlipButton.y = 210;
			myFlipButton.addEventListener(MouseEvent.CLICK, flipCard);
		
			var myTapButton:Button = new Button;
			myTapButton.label = "Tap";
			myTapButton.setStyle("fontWeight", "normal");
			myTapButton.x = 50;
			myTapButton.y = 210
			myTapButton.addEventListener(MouseEvent.CLICK, tapCard)
			
			var vbox:VBox = new VBox;
			var vbox2:VBox = new VBox;
			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, cardDragIt);
 	  		this.addChild(vbox.addChild(myFlipButton));
			this.addChild(vbox2.addChild(myTapButton));
		}	
	           
// Public Methods	
		// Brand New tapCard Function that takes advantage of rotate instead of rotation.	
		public function tapCard(event:MouseEvent):void {
			
			if( rotate.isPlaying ) { rotate.end(); }
			if(this.isTapped == false) {
        	
	        	rotate.angleFrom = 0;
	        	rotate.angleTo = -90;
	        	rotate.originX = this.width/2;
	        	rotate.originY = this.height/2;
	        	rotate.play();
        	this.isTapped = true;
        	} else if(this.isTapped == true) {
	        	rotate.angleFrom = -90;
	        	rotate.angleTo = 0;
	        	rotate.originX = this.width/2;
	        	rotate.originY = this.height/2;
	        	rotate.play();
	        	this.isTapped = false;
        	}
		}
		
		public function cardSizeUp(event:MouseEvent):void {
			this.scaleX = 1.5;
			this.scaleY = 1.5;
		}
		public function cardSizeDown(event:MouseEvent):void {
			this.scaleX = 1;
			this.scaleY = 1;
		}
		
		public function fanCards(event:MouseEvent, angle:Number):void {
			
			if( rotate.isPlaying ) { rotate.end(); }
			if(this.isFanned == false) {
            	rotate.angleFrom = 0;
	        	rotate.angleTo = angle;
	        	rotate.originX = 0; // this.width/2;
	        	rotate.originY = this.height;
	        	rotate.play();
        		this.isFanned = true;
        		this.addEventListener(MouseEvent.MOUSE_OVER, cardSizeUp);
        		this.addEventListener(MouseEvent.MOUSE_OUT, cardSizeDown);
        	} else if(this.isFanned == true) {
	        	rotate.angleFrom = angle;
	        	rotate.angleTo = 0;
	        	rotate.originX = 50;// this.width/2;
	        	rotate.originY = 100;
	     //		rotate.originX = this.width;
	     	//	rotate.originY = 0;
	        	rotate.play();
	        	this.isFanned = false;
	        	this.removeEventListener(MouseEvent.MOUSE_OVER, cardSizeUp);
	        	this.removeEventListener(MouseEvent.MOUSE_OVER, cardSizeDown);
	    	}
		}	
			
		public function loadFromXML(card:XML):Card {
			this.cid = card..cid;
			this.name = card..name;
			this.type = card..type;
			this.subtype1 = card..subtype1;
			this.subtype2 = card..subtype2;
			this.cost = card..cost;
			this.install_cost = card..install_cost;
			this.rez_cost = card..rez_cost;
			this.trash_cost = card..trash_cost;
			this.strength = card..strength;
			this.mu = card..mu;
			this.rarity = card..rarity;
			this.artist = card..artist;
			this.text = card..text;
			this.quote = card..quote;
			this.release = card..release;
			this.agenda_points = card..agenda_points;
			this.difficulty = card..difficulty;
			return (this);
		}

		/* this function loads a card from the cardlist with just the name */		
		public function loadFromCardList(cardName:String, cardList:XML):Card
		{			
				var tempCard:Card = new Card;
				var tempXML:XML = <cardlist></cardlist>
				tempXML.cardlist = cardList.card.(name == cardName)
				this.loadFromXML(tempXML);
				return (this);
		}
		

		/* if you set the flag nameonly to true then it will
		   export only the name of the card, useful for 
		   exporting smaller decks */
		public function toXML(nameonly:Boolean=false):XML
		{
			var cardXML:XML = <card></card>;
			cardXML.name = this.name;
			if (nameonly) {
				return (cardXML);
			}
			cardXML.cid = this.cid;
			cardXML.type = this.type;
			cardXML.subtype1 = this.subtype1;
			cardXML.subtype2 = this.subtype2;
			cardXML.cost = this.cost;
			cardXML.install_cost = this.install_cost;
			cardXML.rez_cost = this.rez_cost;
			cardXML.trash_cost = this.trash_cost;
			cardXML.strength = this.strength;
			cardXML.mu = this.mu;
			cardXML.rarity = this.rarity;
			cardXML.artist = this.artist;
			cardXML.text = this.text;
			cardXML.quote = this.quote;
			cardXML.release = this.release;
			cardXML.agenda_points = this.agenda_points;
			cardXML.difficulty = this.difficulty;			
			return (cardXML);
		}

		public function flipCard(event:MouseEvent):void {
			// This should probably be done with view states.
			// But I haven't got the time to check it out right now.
			
			if(this.cardState == "faceDown") {
				this.setStyle("backgroundImage", this.cardFront);
				this.cardState = "faceUp";
			} else if(this.cardState == "faceUp"){ // if the card is face up.
				this.setStyle("backgroundImage", this.cardBack);
				this.cardState = "faceDown";
			}
			
		}
			
		public function setCardFront(frontImage:String):void {
			this.cardFront = frontImage;
		}		
		
		public function cardDragIt(event:MouseEvent):void 
        {
// 			doDebug("Dragging the Card");
        	var text:String;
        	var format:String = "cardType";
        	
        	// Get the drag initiator component from the event object.
            var dragInitiator:Card = event.currentTarget as Card;

			text = dragInitiator.getStyle('backgroundImage');
     
            // Create a DragSource object.
            var dragSource:DragSource = new DragSource();

            // Add the data to the object.
		    dragSource.addData(text, format)
		   
            // Create a copy of the image to use as a drag proxy.
            // Might have to change this now that I redid the function to rotate the cards
            var dragProxy:Canvas = new Canvas();
     		//dragProxy. = event.currentTarget.source;

			if(dragInitiator.isTapped == true) {
				dragProxy.rotation += -90;
			} 
			
	  		dragProxy.width=170;
	       	dragProxy.height=240;
    	    dragProxy.setStyle('backgroundImage', dragInitiator.getStyle('backgroundImage'));

            // Call the DragManager doDrag() method to start the drag. 

            DragManager.doDrag(dragInitiator, dragSource, event, dragProxy, 0, 0, 1.00);
        }
        
          	
	}
}