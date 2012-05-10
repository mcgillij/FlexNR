package com
{
	import com.Card;
	import mx.collections.ArrayCollection;
	import mx.collections.SortField;
	import mx.collections.Sort;
	
	[Bindable]
	public class Deck
	{
		public var deck:ArrayCollection;
		public var type:String;
		public static var CORPORATION:String = "Corporation";
		public static var RUNNER:String = "Runner";
		
		/**
		 * Pick type 'Runner' or 'Corporation'
		 */
		function Deck(type:String)
		{
			trace ("[Initialize Deck]");
			this.type = type;
			deck = new ArrayCollection;
		}
		
		/**
		 * Add card to deck , duh
		 */
		public function addCard(card:Card):void
		{
			trace ("[Add Card]"+card.name);
			deck.addItem(card);	
		}
		
		/**
		 * Remove the top card of the deck and return it
		 */
		public function draw():Card
		{	
			var temp:Card;	
			temp = deck.removeItemAt(0) as Card;
			trace ("[Draw "+temp.name+"]");
			return (temp);
		}

		/**
		* Will place a card on top of the deck
		*/		
		public function putOnTop(card:Card):void
		{
			trace ("[PutOnTOP "+card.name+"]");
			deck.addItemAt(card,0);
		}
		
		/**
		 * Randomize deck
		 */
		public function shuffle():void
		{
			trace ("[Shuffle Deck]");
			var temp:Card;
			var pos:Number;
			temp = new Card;
			
			/* Swap cards at random positions for all cards in deck	 */
			for (var i:Number=0; i< deck.length; i++) {
				temp = deck[i];
				pos = Math.round(Math.random()*(deck.length-1));
				deck[i] = deck[pos];
				deck[pos] = temp;
			}
		}
		
		
		// This removes a specific card from the deck
		public function removeCard(card:Card):void {
			
			for (var i:uint=0; i<this.deck.length; i++) {
				if(this.deck[i] == card) {
					this.deck.removeItemAt(i);
				}
			}
			
		}
		
		
		/**
		 * Returns the first found instance of a card, if you
		 * set the doremove flag it will also remove it!
		 * Returns null if it cannot find the card
		 */
		public function findCard(cardName:String,doremove:Boolean=false):Card
		{
			for (var i:uint=0; i<this.deck.length; i++) {
				if (this.deck[i].name == cardName) {
					if (doremove) {
						return (this.deck.removeItemAt(i) as Card);
					}
					else {
						return (this.deck[i]);
					}
				}
			}
			return (null);			
		}
		
		/**
		 * Returns a deck with the first X cards from this one
		 * if you pass the flag doremove=true then it will also
		 * remove the cards from the current deck
		 * 
		 * ex. (bodyweight): myDeck.getTop(5,true);
		 */
		public function getTop(num:uint,doremove:Boolean=false):Deck {
			if (doremove) {
				trace ("[Removing top "+num+" from deck]");
			}
			else {
				trace ("[Showing top "+num+" from deck]");
			}

			var tempDeck:Deck = new Deck(this.type);
			
			/* if the number is greater then what remains in the deck
			   simply return the entire deck */
			if (num > this.deck.length) {
				tempDeck.deck = this.deck;
				if (doremove) {
					deck = new ArrayCollection;
				}
				return (tempDeck);
			}
			
			/* go through deck and either draw or show the cards */
			for (var i:uint=0; i<num; i++) {
				if (doremove) {
					tempDeck.addCard(this.draw());
				}	
				else {
					tempDeck.addCard(this.deck[i]);
				}
			}
			return (tempDeck);
		}
		
		/**
		 * Returns (this) deck which has been filtered based on type, 
		 * with optional filters subtype1 and subtype2
		 */
		public function getType(type:String,subtype1:String="",subtype2:String=""):Deck
		{
			trace ("[Extracting cards of type: "+type+" subtype1: "+subtype1+" subtype 2: "+subtype2+"]");
			var tempDeck:Deck = new Deck(this.type);
			for each (var card:Card in this.deck) {
				
				/* sort on type, subtype1 and subtype2 */
				if (subtype1 != "" && subtype2 != "" && card.type == type && card.subtype1 == subtype1 && card.subtype2 == subtype2) {
					tempDeck.addCard(card);
				}
				
				/* sort on type, and subtype1 */
				else if(subtype1 != "" && subtype2 == "" && card.type == type && card.subtype1 == subtype1) {
					tempDeck.addCard(card);
				}
				
				/* sort on type */
				else if(subtype1 == "" && subtype2 == "" && card.type == type) {
					tempDeck.addCard(card);
				}
			}
			return (tempDeck);
		}
		
		/**
		 * Loads the deck from an XML object, you must also 
		 * supply the cardlist for loading purposes.
		 */
		public function loadFromXML(deck:XML,cardList:XML,compact:Boolean=false):Deck
		{
			trace ("[Loading cards from XML]");
			var tempCard:Card;
			for each (var card:XML in cardList.card) {
				tempCard = new Card;
				tempCard.loadFromCardList(card.name,cardList);
				this.addCard(tempCard);
			}
			return (this);
		}
		
		/**
		 * Exports the deck in XML format
		 */
		public function toXML(compact:Boolean=false):XML
		{
			trace ("[Exporting deck to XML]");
			var deckXML:XML = <cardlist></cardlist>;
			
			if (compact) {
				var mySort:Sort = new Sort();
				var sortByName:SortField = new SortField("name");
				var tempDeck:Deck = new Deck(this.type);
				var count:uint = 0;
				var last:Card = new Card();
				
				mySort.fields = [sortByName];
				tempDeck = this;
				tempDeck.deck.sort = mySort;
				tempDeck.deck.refresh();
				
				for each (var current:Card in tempDeck.deck) {
					if (last.name == "") {
						count++;
					}
					else if (last.name != current.name) {
						deckXML.appendChild(<card><name>{last.name}</name><quantity>{count}</quantity></card>);
						count = 0;
					}
					else if (last.name == current.name) {
						count++;
					}			
					last = current;			
				}
				deckXML.appendChild(<card><name>{last.name}</name><quantity>{count}</quantity></card>);
			}
			else {
				for each (var card:Card in this.deck) {
						deckXML.appendChild(card.toXML(true));
				}				
			}
			return (deckXML);
		}
		
		public function toString():String
		{			
			var result:String = "[Deck "+type+"]\n";
			for (var i:Number=0; i< deck.length; i++) {
				result += deck[i].toString();
				result += "\n";
			}
			result += "[/Deck]";
			return result;
		}
	}
}