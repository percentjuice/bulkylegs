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
package com.percentjuice.model.loadUnload.loaders.xmlLoading
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	public class LoadAssetGroup extends EventDispatcher implements ILoadAssets
	{
		public var assetGroupName:String;
		public var loadedAssets:Dictionary;
		private var group:Array;

		public function LoadAssetGroup()
		{
			super();
		}

		/* group must be an Array of LoadObjects */
		public function loadAssets(bulkLoader:BulkLoader, groupName:String, group:Array):void
		{
			assetGroupName = groupName;
			this.group = [];
			var i:int = 0;
			var l:int = group.length;
			for (i; i<l; i++)
			{
				this.group.push(group[i].id);
				bulkLoader.add(group[i].url, {id: group[i].id});
			}
			bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, handleAssetsLoaded);
			bulkLoader.start();
		}

		/* create Dictionary [each prop has 'id'::bmp:Bitmap] & remove assets from bulkLoader */
		private function handleAssetsLoaded(event:ProgressEvent):void
		{
			var bulkLoader:BulkLoader = event.target as BulkLoader;
			bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE, handleAssetsLoaded);

			/* create asset Dictionary from bulkLoader */
			loadedAssets = new Dictionary(true);
			for each (var assetId:String in group)
			{
				loadedAssets[assetId] = bulkLoader.getContent(assetId, true);
			}

			group = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}

