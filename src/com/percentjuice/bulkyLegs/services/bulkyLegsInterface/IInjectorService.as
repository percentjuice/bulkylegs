package com.percentjuice.bulkyLegs.services.bulkyLegsInterface
{
	import flash.events.IEventDispatcher;

	public interface IInjectorService extends IEventDispatcher
	{
		function loadAsset(value:String):void;
		function unloadAsset(value:String):void;
	}
}

