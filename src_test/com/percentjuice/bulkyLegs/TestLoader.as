package com.percentjuice.bulkyLegs
{
	import com.percentjuice.bulkyLegs.events.LoadedEvent;
	import com.percentjuice.bulkyLegs.events.TestResultsEvent;
	import com.percentjuice.bulkyLegs.services.bulkyLegsInterface.IInjectorService;
	import com.percentjuice.bulkyLegs.vo.TestResultsO;

	import flash.events.EventDispatcher;

	public class TestLoader extends EventDispatcher implements ITest
	{
		public static const LOAD:String = 'load';
		public static const UNLOAD:String = 'unload';

		private var preloadArray:Array;
		private var pc:BulkyLegsContext;
		private var inj:IInjectorService;
		private var listenerEvent:String;
		private var injectorFunction:Function;

		public function TestLoader(state:String, pc:BulkyLegsContext,inj:IInjectorService, preloadArray:Array)
		{
			this.pc = pc;
			this.inj = inj;
			this.preloadArray = preloadArray;
			setState(state);
		}

		private function setState(state:String):void
		{
			switch (state)
			{
				case LOAD:
					listenerEvent = LoadedEvent.LOAD_COMPLETE;
					injectorFunction = inj.loadAsset;
					break;
				case UNLOAD:
					listenerEvent = LoadedEvent.UNLOAD_COMPLETE;
					injectorFunction = inj.unloadAsset;
					break;
				default:
					throw new Error('invalid state set');
			}
		}

		public function run():void
		{
			inj.addEventListener(listenerEvent, handleLoad);
			for (var i:int=preloadArray.length-1; i>-1; --i)
			{
				injectorFunction(preloadArray[i]);
			}
		}

		private function handleLoad(e:LoadedEvent):void
		{
			preloadArray.splice(preloadArray.indexOf(e.requestName),1);
			if (!preloadArray.length)
			{
				inj.removeEventListener(listenerEvent, handleLoad);
				var tro:TestResultsO = new TestResultsO();
				tro.passed = true;
				this.dispatchEvent(new TestResultsEvent(tro));
			}
		}

	}
}

