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
package com.percentjuice.bulkyLegs.services.assetHandling.loadUnload
{
	import com.percentjuice.bulkyLegs.events.LoadedEvent;
	import com.percentjuice.bulkyLegs.services.assetHandling.IAssetUnload;
	import com.percentjuice.bulkyLegs.vo.LoadedObject;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import com.percentjuice.bulkyLegs.services.assetHandling.ALoad;
	import com.percentjuice.bulkyLegs.services.assetHandling.LoadUnloadHandler;

	public class Unload extends ALoad implements IAssetUnload
	{
		private var state:String;
		/* all options which were loaded; RunLoaders load increasing assets to these; unloadGroup removes assets from these */
		private var groupAssets:Dictionary;
		protected var languageText:Dictionary;

		public function Unload(state:String, groupAssets:Dictionary, languageText:Dictionary)
		{
			this.state = state;
			this.groupAssets = groupAssets;
			this.languageText = languageText;
		}

		/* passes proper asset group to clearChildren; creates & returns LoadedEvent */
		public function unloadAsset(assetId:String):LoadedEvent
		{
			var eventCreated:LoadedEvent = new LoadedEvent(LoadedEvent.UNLOAD_COMPLETE);
			switch (state)
			{
				case LoadUnloadHandler.RUNGROUP:
					clearChildren(groupAssets[assetId]);
					eventCreated.loadedObject = new LoadedObject(LoadedObject.GROUP);
					break;
				case LoadUnloadHandler.RUNLANG:
					clearChildren(languageText[assetId]);
					eventCreated.loadedObject = new LoadedObject(LoadedObject.LANGUAGE);
					break;
			}
			return eventCreated;			
		}

		private function clearChildren(removeGroup:Dictionary):void
		{
			for (var child:* in removeGroup)
			{
				if (removeGroup[child] is Bitmap && removeGroup[child].bitmapData)
				{
					removeGroup[child].bitmapData.dispose();
				}
				removeGroup[child] = null;
			}
			removeGroup = null;
		}

	}
}

