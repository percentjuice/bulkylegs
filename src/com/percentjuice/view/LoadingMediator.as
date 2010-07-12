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
package com.percentjuice.view
{
	import com.percentjuice.controller.LoadRequestEvent;
	import com.percentjuice.controller.LoadedEvent;
	import com.percentjuice.model.objects.LoadedObject;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Mediator;

	public class LoadingMediator extends Mediator
	{
		[Inject]
		public var loading:Loading;

		[Bindable]
		public var loadedGroupsC:ArrayCollection;
		[Bindable]
		private var unloadedGroupsC:ArrayCollection;

		private var langs:Array;


		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, LoadedEvent.LOAD_COMPLETE, onStateLoaded);

			eventMap.mapListener(loading.unloadedList, MouseEvent.CLICK, handleListSelection);
			eventMap.mapListener(loading.loadedList, MouseEvent.CLICK, handleListSelection);
			eventMap.mapListener(loading.loadMoreButton, MouseEvent.CLICK, handleLoadUnloadRequest);
			eventMap.mapListener(loading.unloadButton, MouseEvent.CLICK, handleLoadUnloadRequest);

			init();
		}

		private function init():void
		{
			unloadedGroupsC = new ArrayCollection();
			loadedGroupsC = new ArrayCollection(); 
			loading.unloadedList.dataProvider = unloadedGroupsC;
			loading.loadedList.dataProvider = loadedGroupsC;
			langs = [];

			loading.loadMoreButton.enabled = false;
			loading.unloadButton.enabled = false;
		}

		private function handleListSelection(e:MouseEvent):void
		{
			{
				switch (e.currentTarget)
				{
					case loading.loadedList:
						if (loading.loadedList.selectedItem)
						{
							/* show selected group */
							dispatch(new LoadRequestEvent(LoadRequestEvent.REQUEST_LOAD, (loading.loadedList.selectedItem.label as String)));
							/* allow unload request */
							loading.unloadButton.enabled = true;
						}
						break;
					case loading.unloadedList:
						if (loading.unloadedList.selectedItem)
						{
							/* allow load request */
							loading.loadMoreButton.enabled = true;
							break;
						}
				}
			}
		}

		/* requests a group of assets added/removed */
		private function handleLoadUnloadRequest(e:MouseEvent):void
		{
			e.target.enabled = false;

			var chosenItem:Object;
			switch (e.target)
			{
				case loading.loadMoreButton:
					chosenItem = loading.unloadedList.selectedItem;
					dispatch(new LoadRequestEvent(LoadRequestEvent.REQUEST_LOAD, chosenItem as String));
					break;
				case loading.unloadButton:
					chosenItem = loading.loadedList.selectedItem;
					dispatch(new LoadRequestEvent(LoadRequestEvent.REQUEST_UNLOAD, chosenItem.label as String));
					unloadedGroupsC.addItem(chosenItem.label);
					loadedGroupsC.removeItemAt(loadedGroupsC.getItemIndex(chosenItem));
					if (chosenItem.type == LoadedObject.LANGUAGE)
					{
						setTextContent(new Dictionary(true));
					}
					break;
			}
		}

		/* handles newly loaded asset group */
		private function onStateLoaded(event:LoadedEvent):void
		{
			/* populate an empty unloaded groups list */
			if (!unloadedGroupsC.length)
			{
				unloadedGroupsC.source=event.allAssetIds;
			}
			/* update unloaded & loaded lists per new load */
			var ind:int = unloadedGroupsC.getItemIndex(event.requestName);
			if (ind != -1) 
			{
				unloadedGroupsC.removeItemAt(ind);
				loadedGroupsC.addItem(getListItem(event));
			}
			/* utilize data loaded */
			switch (event.loadedObject.type)
			{
				/* page text */
				case LoadedObject.LANGUAGE:
					setTextContent(event.loadedObject.loadedRequest);
					break;
				/* loaded groups list */
				case LoadedObject.GROUP:
					break;
			}

		}

		private function getListItem(event:LoadedEvent):Object
		{
			return {label:event.requestName, type:event.loadedObject.type}
		}

		private function setTextContent(languageD:Dictionary):void
		{
			loading.unloadedStatesLabel.text = languageD.l_unloaded1 || '';
			loading.loadedStatesLabel.text = languageD.l_loaded1 || '';
			loading.loadMoreButton.label = languageD.b_load1 || '';
			loading.unloadButton.label = languageD.b_unload1 || '';					
		}

	}
}

