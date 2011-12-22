/**
 * @author cStuempges, percentjuice.com.
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 * http://www.opensource.org/licenses/mit-license.php
 */
package com.percentjuice.bulkyLegs.services.bulkyLegsInterface
{
	import com.percentjuice.bulkyLegs.events.LoadRequestEvent;
	import com.percentjuice.bulkyLegs.events.LoadedEvent;
	import com.percentjuice.bulkyLegs.events.LoadingEvent;

	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * This class is instantiated in BulkyLegsContext;
	 * This is the interface for communicating with bulkyLegs as a module.
	 *
	 * @author C Stuempges
	 */
	public class InjectorService extends Actor implements IInjectorService
	{
		public function InjectorService()
		{
			super();
		}

		[PostConstruct]
		public function handleInjection():void
		{
			eventMap.mapListener(eventDispatcher, LoadingEvent.REQUEST_LOADING, dispatchEvent);
			eventMap.mapListener(eventDispatcher, LoadedEvent.LOAD_COMPLETE, dispatchEvent);
			eventMap.mapListener(eventDispatcher, LoadedEvent.UNLOAD_COMPLETE, dispatchEvent);
		}

		private var _dispatcher:EventDispatcher;

		/**
		 * call to load asset group
		 * @param value: name of (group id || languages xml file) in your mapping xml file.
		 * 		for example: 'espanol' if your mapping xml reads:
		 *	<languages>
		 *		<asset source="xml/espanol.xml" />
		 *	</languages>
		 */
		public function loadAsset(value:String):void
		{
			dispatch(new LoadRequestEvent(LoadRequestEvent.REQUEST_LOAD, value));
		}

		/**
		 * call to unload asset group
		 * @param value: name of (group id || languages xml file) in your mapping xml file.
		 */
		public function unloadAsset(value:String):void
		{
			dispatch(new LoadRequestEvent(LoadRequestEvent.REQUEST_UNLOAD, value));
		}

		//* event dispatcher *//

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}

		/* lazy getter */
		private function get dispatcher():EventDispatcher
		{
			if (!_dispatcher)
			{
				_dispatcher = new EventDispatcher();
			}
			return _dispatcher;
		}
	}
}

