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
package com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaders.xmlLoading
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	public class LoadAssetGroup extends EventDispatcher implements ILoadAssets
	{
		public function LoadAssetGroup()
		{
		}

		public var assetGroupName:String;
		public var loadedAssets:Dictionary;
		private var bulkLoader:BulkLoader;
		private var group:Array;
		private var loadFunctionMap:Dictionary;

		/* group must be an Array of LoadObjects */
		public function loadAssets(bulkLoader:BulkLoader, groupName:String, group:Array):void
		{
			assetGroupName = groupName;
			this.bulkLoader = bulkLoader;
			this.group = [];
			this.loadFunctionMap = new Dictionary(true);
			var l:int = group.length;
			for (var i:int=0; i<l; i++)
			{
				this.group.push(group[i].id);
				this.loadFunctionMap[group[i].id] = getLoadFunction(group[i].type);
				bulkLoader.add(group[i].url, {id: group[i].id, type: group[i].type});
			}
			bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, handleAssetsLoaded);
			bulkLoader.start();
		}

		private function getLoadFunction(type:String):Function
		{
			switch (type)
			{
				case BulkLoader.TYPE_BINARY:
					return bulkLoader.getBinary;
					break;
				case BulkLoader.TYPE_IMAGE:
					return bulkLoader.getBitmap;
					break;
				case BulkLoader.TYPE_MOVIECLIP:
					return bulkLoader.getMovieClip;
					break;
				case BulkLoader.TYPE_SOUND:
					return bulkLoader.getSound;
					break;
				case BulkLoader.TYPE_TEXT:
					return bulkLoader.getText;
					break;
				case BulkLoader.TYPE_XML:
					return bulkLoader.getXML;
					break;
				case BulkLoader.TYPE_VIDEO:
					return bulkLoader.getAVM1Movie;
					break;
				default:
					throw new Error('no Function declared for type '+type);
			}
		}

		/* create Dictionary [each prop has 'id'::bmp:Bitmap] & remove assets from bulkLoader */
		private function handleAssetsLoaded(event:ProgressEvent):void
		{
			bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE, handleAssetsLoaded);

			/* create asset Dictionary from bulkLoader */
			loadedAssets = new Dictionary(true);
			for each (var assetId:String in group)
			{
				var parseFunction:Function = loadFunctionMap[assetId];
				loadedAssets[assetId] = parseFunction(assetId, true);
			}

			group = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}

