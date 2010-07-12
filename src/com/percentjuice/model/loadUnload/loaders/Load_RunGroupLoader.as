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
package com.percentjuice.model.loadUnload.loaders
{
	import com.percentjuice.model.loadUnload.loaders.xmlLoading.*;
	import com.percentjuice.model.objects.LoadObject;

	import flash.events.Event;

	public class Load_RunGroupLoader extends ALoader 
	{
		/* contains methods for loading/unloading asset groups */
		public function Load_RunGroupLoader(props:Object)
		{
			super(ALoader.LOADED, props);
		}

		override public function loadAsset(assetId:String):void
		{
			requestName = assetId;
			/* load new */
			var loadAssets:LoadAssetGroup = new LoadAssetGroup();
			loadAssets.addEventListener(Event.COMPLETE, handleGroupLoaded);
			loadAssets.loadAssets(bulkLoader, assetId, loadGroups[assetId] as Array);
		}

		override protected function handleGroupLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, handleGroupLoaded);
			var lag:LoadAssetGroup = event.target as LoadAssetGroup;
			loadedRequest = lag.loadedAssets; 
			lag = null;

			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}

