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
	import br.com.stimuli.loading.BulkLoader;
	
	import com.percentjuice.bulkyLegs.events.LoadedEvent;
	import com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.Load;
	import com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.Unload;
	import com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaderHandlers.*;
	import com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaders.*;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	/*  as implementer of IModelUnload & IModelLoad: handles load/unoad requests for groups of assets
	 *
	 * 	takes load requests, sets state accordingly, creates responsible handlers, dispatches LoadedEvent when appropriate.
	 * 	takes unload requests, creates responsible handlers.
	 *	holds all loaded assets.  groups are in groupAssets, languageNodes are in languageText.
	 */
	public class LoadUnloadHandler extends ALoad implements IAssetUnload 
	{
		/* states for this + Unload + Load, all of which handle multiple asset types */
		public static const INIT:String = 'init'; // initializing assets
		public static const RUNGROUP:String = 'rungroup'; // asset loading from group options
		public static const RUNLANG:String = 'runlang'; // asset loading from lang options
		private var state:String;
		/* all options which were loaded; RunLoaders load increasing assets to these; unloadGroup removes assets from these */
		protected var groupAssets:Dictionary;
		protected var languageText:Dictionary;
		/* all options which can be loaded; InitLoaders load these; injected into RunLoaders  */
		private var languageOptions:Dictionary;
		private var loadGroups:Dictionary;
		/* tool used to handle loading.  (assets are not stored in bulkLoader.) */
		private var bulkLoader:BulkLoader;
		/* errors */
		private const ERROR_GROUP:String = ' is not a loaded group. check your assets.xml for group labels or wait for group loaded.';
		private var _assetsPath:String;
		private var _modelName:String;

		public function LoadUnloadHandler()
		{
			super();
			init();
		}

		public function set modelName(value:String):void
		{
			_modelName = value;
		}

		public function set assetsPath(value:String):void
		{
			_assetsPath = value;
		}

		private function init():void
		{
			groupAssets = new Dictionary(true);
			languageText = new Dictionary(true);
		}

		/* 	depending on state, chooses an appropriate Loader & LoadHandler
		 *	passes group request to loadHandler instance
		 */
		override public function loadAsset(assetId:String):void
		{
			state = getStatePerRequest(assetId);
			if (state == INIT)
			{
				var loadHandler:ILoaderHandler = new Load_InitHandler(new Load_InitLoader(_assetsPath, _modelName));
				loadHandler.addEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded, false, 0, true);
				loadHandler.loadAsset(assetId);
			}
			else
			{
				var load:Load = new Load(state, groupAssets, languageText, getLoaderPropsObject());
				bulkLoader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent, false, 0, true);
				load.addEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);
				load.loadAsset(assetId);
			}
		}

		/* depending on state, chooses an appropriate asset container
		 * passes unload request to local Unload instance
		 */
		public function unloadAsset(assetId:String):LoadedEvent
		{
			var unloadState:String = getStatePerRequest(assetId);
			var unloader:Unload = new Unload(unloadState, groupAssets, languageText);
			var unloadEvent:LoadedEvent = unloader.unloadAsset(assetId);
			unloader = null;
			/* provide notification */
			unloadEvent.requestName = assetId;
			unloadEvent.allAssetIds = returnObjectAsArray(loadGroups).concat(returnObjectAsArray(languageOptions));
			return unloadEvent;
		}

		/* handles request for an already loaded asset */
		public function getLoadedGroupEvent(group:String):LoadedEvent
		{
			var loadedDispatchState:String = getStatePerRequest(group);
			var load:Load = new Load(loadedDispatchState, groupAssets, languageText, getLoaderPropsObject());
			var eventCreated:LoadedEvent = load.getLoadedGroupEvent(group);
			eventCreated.requestName = group;
			eventCreated.allAssetIds = returnObjectAsArray(loadGroups).concat(returnObjectAsArray(languageOptions));
			load = null;
			return eventCreated;
		}

		/* handles loadHandler complete
		 * dispatches LoadEvent.LOAD_COMPLETE
		 * sets loading assets ready for garbage collection
		 */ 
		override protected function handleGroupLoaded(event:Event):void
		{
			event.target.removeEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);
			var loadedE:LoadedEvent = event as LoadedEvent;
			/* state will not have changed during load */
			if (state == INIT)
			{
				var loadHandler:Load_InitHandler = event.target as Load_InitHandler;
				/* on initialization complete:
				 *		establishes assets available to be loaded
				 *		creates bulkLoader instance to do the loading
				 *		loads originally requested asset group
				 */
				languageOptions=loadHandler.loader.languageOptions;
				loadGroups=loadHandler.loader.loadGroups;
				bulkLoader=loadHandler.loader.bulkLoader;

				loadAsset(loadedE.requestName);
			}
			else
			{
				var load:Load = event.target as Load;
				/* on group load complete:
				 *		stores assets in proper Dictionary
				 *		appends 'allUnloadedIds' data to LoadedEvent
				 */
				bulkLoader.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
				loadedE.allAssetIds = returnObjectAsArray(loadGroups).concat(returnObjectAsArray(languageOptions));
				dispatchEvent(loadedE);
			}
		}

		/* state depends on 1) initialization 2) group request is part of which asset category */
		private function getStatePerRequest(group:String):String
		{
			var properState:String;
			switch (true)
			{
				case !loadGroups:
					properState = INIT;
					break;
				case loadGroups.hasOwnProperty(group):
					properState = RUNGROUP;
					break;
				case languageOptions.hasOwnProperty(group):
					properState = RUNLANG;
					break;
				default:
					throw new Error(group+ERROR_GROUP);
			}
			return properState;
		}

		/* converts Dictionary Key to Array of Strings */
		private function returnObjectAsArray(object:Object):Array
		{
			var assetList:Array = [];
			for (var key:Object in object) 
			{
				assetList.push(key);
			}		
			return assetList;
			assetList = null;
		}

		private function getLoaderPropsObject():Object
		{
			return {languageOptions:languageOptions,loadGroups:loadGroups,bulkLoader:bulkLoader};
		}

	}
}


