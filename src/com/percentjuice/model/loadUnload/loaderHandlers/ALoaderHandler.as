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
package com.percentjuice.model.loadUnload.loaderHandlers
{
	import com.percentjuice.controller.LoadedEvent;
	import com.percentjuice.model.loadUnload.ALoad;
	import com.percentjuice.model.loadUnload.loaders.ILoader;

	import flash.utils.Dictionary;
	import flash.events.Event;

	/* handles LoadedEvent.LOAD_COMPLETE creation; enforces proper Loader type */ 
	public class ALoaderHandler extends ALoad implements ILoaderHandler 
	{
		protected var _loader:ILoader;

		public function ALoaderHandler(loader:ILoader)
		{
			super();
			_loader = loader;
		}

		public function get loader():ILoader
		{
			return _loader;
		}
		public function set loader(l:ILoader):void
		{
			_loader = l;
		}

		override public function loadAsset(assetId:String):void
		{
			loader.addEventListener(Event.COMPLETE, handleGroupLoaded);
			loader.loadAsset(assetId);
		}

		override protected function handleGroupLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, handleGroupLoaded);
			dispatchEvent(createLoadedEvent(loader.requestName, loader.loadedRequest));
		}

		public function createLoadedEvent(requestName:String, loadedRequest:Dictionary=null):LoadedEvent
		{
			throw new Error(ERROR_ABSTRACT);
			return null;
		}

	}
}

