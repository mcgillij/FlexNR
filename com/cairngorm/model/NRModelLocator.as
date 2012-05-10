package com.cairngorm.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	import com.Deck;
	
	[Bindable]
	public class NRModelLocator implements ModelLocator
	{
		private static var modelLocator:NRModelLocator;
		
		public var runnerDeck:Deck = new Deck(Deck.RUNNER);
		public var runnerHand:Deck = new Deck(Deck.RUNNER);
		public var corpDeck:Deck = new Deck(Deck.CORPORATION);
		public var corpHand:Deck = new Deck(Deck.CORPORATION);
		
		public static function getInstance():NRModelLocator
		{
			if (modelLocator == null) {
				modelLocator = new NRModelLocator;
			}
			
			return (modelLocator);
		}
		
		public function NRModelLocator():void
		{
			if (modelLocator != null) {
				throw new Error( "Only one model locator instance should be loaded at one time");
			}			
		}
		
		

	}
}