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
	import com.percentjuice.controller.LoadedEvent;
	import com.percentjuice.model.objects.LoadedObject;

	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Mediator;

	/* displays images from the loaded groups. */
	public class ImageViewMediator extends Mediator
	{
		[Inject]
		public var imageView:ImageView;
		[Bindable]
		private var imageColl:ArrayCollection;

		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, LoadedEvent.LOAD_COMPLETE, onAssetLoadUnload);
			eventMap.mapListener(eventDispatcher, LoadedEvent.UNLOAD_COMPLETE, onAssetLoadUnload);
			init();
		}

		private function init():void
		{
			imageColl = new ArrayCollection();
			imageView.r1.dataProvider = imageColl; 
		}

		/* handles newly loaded/unloaded asset */
		private function onAssetLoadUnload(event:LoadedEvent):void
		{
			switch (event.loadedObject.type)
			{
				/* page text */
				case LoadedObject.LANGUAGE:
					break;
				/* loaded groups list */
				case LoadedObject.GROUP:
					imageColl.removeAll();
					/* if this was a load request, display load */
					if (event.loadedObject)
					{
						imageColl.source = dictToObjectArray(event.loadedObject.loadedRequest);
					}
					break;
			}
		}

		/* creates Objects which are referenced in the view
		 * (alternatively, an ArrayCollection of Bindable Objects could be created originally in the Model.) */
		private function dictToObjectArray(dict:Dictionary):Array
		{
			var ivoA:Array = [];
			for (var prop:* in dict)
			{
				ivoA.push({id:prop,bmp:dict[prop]});
			}
			return ivoA;
		}

	}
}

