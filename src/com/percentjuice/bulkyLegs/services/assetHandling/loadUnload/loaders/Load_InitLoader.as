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
package com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaders
{
	import br.com.stimuli.loading.BulkLoader;

	import com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaders.xmlLoading.*;

	import flash.events.Event;

	/* creates BulkLoader instance; loads MODEL_PATH XML; creates Dictionaries of Group & Language options; */
	public class Load_InitLoader extends ALoader 
	{
		/* asset paths & identifiers */
		private static const LOADER_ID:String = 'loader id';
		private static const MODEL_ID:String = 'model id';
		/**/
		private var assetsPath:String;
		private var modelName:String;

		/* instiates Init to load asset + language groups
		 */
		public function Load_InitLoader(assetsPath:String, modelName:String)
		{
			super(ALoader.EMPTY);
			this.assetsPath = assetsPath;
			this.modelName = modelName;
		}

		override public function loadAsset(assetId:String):void
		{
			requestName = assetId;

			bulkLoader = new BulkLoader(LOADER_ID);
			bulkLoader.allowsAutoIDFromFileName = false;

			var lgii:ILoadXML = new LoadXML(assetsPath.concat(modelName));
			lgii.addEventListener(Event.COMPLETE, handleGroupLoaded);
			lgii.loadXML(bulkLoader, MODEL_ID);
		}

		override protected function handleGroupLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, handleGroupLoaded);
			var pga:ParseGroupAssets = new ParseGroupAssets(assetsPath);
			pga.parseAssetsFromXML(bulkLoader, MODEL_ID);

			languageOptions = pga.languageOptions;
			loadGroups = pga.loadGroups;

			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}

