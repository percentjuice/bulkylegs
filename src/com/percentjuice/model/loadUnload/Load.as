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
package com.percentjuice.model.loadUnload
{
	import com.percentjuice.controller.LoadedEvent;
	import com.percentjuice.model.IModelLoad;
	import com.percentjuice.model.loadUnload.loaderHandlers.*;
	import com.percentjuice.model.loadUnload.loaders.*;

	import flash.events.Event;
	import flash.utils.Dictionary;

	public class Load extends ALoad implements IModelLoad
	{
		private var state:String;
		/* props which change per state */
		private var loadHandler:ILoaderHandler;
		private var loaderProps:Object;
		/* all options which were loaded; RunLoaders load increasing assets to these; unloadGroup removes assets from these */
		private var groupAssets:Dictionary;
		private var languageText:Dictionary;

		public function Load(state:String, groupAssets:Dictionary, languageText:Dictionary, loaderProps:Object)
		{
			super();
			this.state = state;
			this.groupAssets = groupAssets;
			this.languageText = languageText;
			this.loaderProps = loaderProps;
		}

		/* handles request for an already loaded asset */
		public function getLoadedGroupEvent(group:String):LoadedEvent
		{
			var eventCreator:ILoaderHandler;
			var eventCreated:LoadedEvent;
			switch(state)
			{
				case LoadUnload.RUNGROUP:
					eventCreator = new Load_RunGroupHandler(null);
					eventCreated = eventCreator.createLoadedEvent(group, groupAssets[group]);
					break;
				case LoadUnload.RUNLANG:
					eventCreator = new Load_RunLangHandler(null);
					eventCreated = eventCreator.createLoadedEvent(group, languageText[group]);
					break;
			}
			eventCreator = null;
			return eventCreated;
		}

		/* 	depending on state, chooses an appropriate Loader & LoadHandler
		 *	passes group request to loadHandler instance
		 */
		override public function loadAsset(assetId:String):void
		{
			switch (state)
			{
				case LoadUnload.RUNGROUP:
					loadHandler = new Load_RunGroupHandler(new Load_RunGroupLoader(loaderProps));
					break;
				case LoadUnload.RUNLANG:
					loadHandler = new Load_RunLangHandler(new Load_RunLangLoader(loaderProps));
					break;
			}
			loadHandler.addEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);
			loadHandler.loadAsset(assetId);
		}

		/* handles loadHandler complete
		 * dispatches LoadEvent.LOAD_COMPLETE
		 * sets loading assets ready for garbage collection
		 */ 
		override protected function handleGroupLoaded(event:Event):void
		{
			loadHandler.removeEventListener(LoadedEvent.LOAD_COMPLETE, handleGroupLoaded);
			var loadedE:LoadedEvent = event as LoadedEvent;

			/* on group load complete:
			 *		stores assets in proper Dictionary
			 *		appends 'allUnloadedIds' data to LoadedEvent
			 */
			switch (state)
			{
				case LoadUnload.RUNGROUP:
					groupAssets[loadedE.requestName] = loadedE.loadedObject.loadedRequest;
					break;
				case LoadUnload.RUNLANG:
					languageText[loadedE.requestName] = loadedE.loadedObject.loadedRequest; 
					break;
			}
			loadHandler = null;
			dispatchEvent(loadedE);
		}

	}
}


