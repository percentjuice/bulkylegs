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
package com.percentjuice.bulkyLegs.services.assetHandling
{
	import com.percentjuice.bulkyLegs.events.LoadedEvent;
	import com.percentjuice.bulkyLegs.events.LoadingEvent;
	
	import flash.events.ProgressEvent;
	
	import org.robotlegs.mvcs.Actor;

	/*  as implementer of IModelUnload & IModelLoad: handles load/unoad requests for groups of assets
	 *
	 *  handles queing of requests.
	 *  assures load request is not already loaded.
	 *	assures unload request is a loaded group.
	 *  dispatches Load Progress + Load Complete
	 */
	public class AssetHandling extends Actor implements IAssetUnload, IAssetLoad
	{
		/* reference to current state */
		private var state:String;
		/* states */
		private const BUSY:String = 'busy'; // load in progress
		private const LOAD:String = 'load'; // available for load
		/* private */
		private var loadUnloadHandler:LoadUnloadHandler;
		private var queuedLoads:Array;
		private var allLoadedIds:Array;
		/* errors */
		public static const ERROR_NOTLOADED:String = 'cannot remove assets which aren\'t loaded';

		public function AssetHandling()
		{
			super();
			init();
		}

		private function init():void
		{
			state = LOAD;
			queuedLoads = [];
			allLoadedIds = [];
			loadUnloadHandler = new LoadUnloadHandler();
		}

		public function set assetsPath(value:String):void
		{
			loadUnloadHandler.assetsPath = value;
		}

		public function set modelName(value:String):void
		{
			loadUnloadHandler.modelName = value;
		}

		/* queues event if modelProxy busy, else passes load handling to /loadUnload/LoadUnload.as */
		public function loadAsset(assetId:String):void
		{
			/* if group is not already loaded */
			if (!groupLoaded(assetId))
			{
				switch(state)
				{
					case BUSY:
						queuedLoads.push(assetId);
						break;
					case LOAD:
						state = BUSY;
						/* Mediators can listen directly to the global dispatcher */
						loadUnloadHandler.addEventListener(ProgressEvent.PROGRESS, handleGroupLoading);
						loadUnloadHandler.addEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);
						loadUnloadHandler.loadAsset(assetId);
						break;
				}
			}
			/* send all group assets */
			else
			{
				dispatchLoadedGroup(assetId);
			}
		}

		/* removes the loaded asset groups, if it has already been loaded.
		 *	has no effect on in-progress loads.
		 */
		public function unloadAsset(assetId:String):LoadedEvent
		{
			if (groupLoaded(assetId))
			{
				allLoadedIds.splice(allLoadedIds.indexOf(assetId),1);
				var unloadEvent:LoadedEvent = loadUnloadHandler.unloadAsset(assetId);
				unloadEvent.allLoadedIds = allLoadedIds;
				dispatch(unloadEvent);
			}
			else
			{
				throw new Error(ERROR_NOTLOADED);
			}
			return null;
		}

		private function handleGroupLoading(event:ProgressEvent):void
		{
			var le:LoadingEvent = new LoadingEvent(event);
			var le2:ProgressEvent = le as ProgressEvent;
			dispatch(le);
		}

		/* adds groupName & loadedGroups to LoadEvent, dispatches, continues queued loads. */
		private function handleGroupLoaded(event:LoadedEvent):void
		{
			loadUnloadHandler.removeEventListener(ProgressEvent.PROGRESS, handleGroupLoading);
			loadUnloadHandler.removeEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);

			allLoadedIds.push(event.requestName);
			/* sending LOAD_COMPLETE event + (bulkLoader||LanguageText) assets */
			event.allLoadedIds = allLoadedIds;
			dispatch(event);
			event = null;

			state = LOAD;
			/* check for loads requested while loading */
			if (queuedLoads.length)
			{
				loadAsset(queuedLoads.pop() as String);
			}
		}

		/* returns true if group is already loaded */
		private function groupLoaded(group:String):Boolean
		{
			return (allLoadedIds.indexOf(group) != -1);
		}

		/* dispatches loaded group data. */
		private function dispatchLoadedGroup(groupName:String):void
		{
			var assetEvent:LoadedEvent = loadUnloadHandler.getLoadedGroupEvent(groupName);
			assetEvent.allLoadedIds = allLoadedIds;
			dispatch(assetEvent);
		}

	}
}

