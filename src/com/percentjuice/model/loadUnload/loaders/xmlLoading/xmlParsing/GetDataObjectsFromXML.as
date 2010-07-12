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
package com.percentjuice.model.loadUnload.loaders.xmlLoading.xmlParsing
{
	import com.percentjuice.model.objects.LoadObject;

	import flash.utils.Dictionary;

	public class GetDataObjectsFromXML
	{
		/* resources */
		private var parsingUtils:XMLParsingUtils;

		/* takes XML & returns Array of LoadObjects.
		 * each asset child should have 'source' and 'loadGroup' id's.
		 */
		public function GetDataObjectsFromXML()
		{
			init();
		}

		private function init():void
		{
			parsingUtils = XMLParsingUtils.gi();
		}

		/* returns Dictionary of Arrays of LoadObjects ID'd by Group */
		public function getLoadObjectsPerGroup(modelXML:XMLList):Dictionary
		{
			var assetGroup:Dictionary = new Dictionary(true);
			//for each (var prop:XML in modelXML.assets.asset)
			for each (var prop:XML in modelXML.group)
			{
				if (!prop.hasOwnProperty('@id'))
				{throw new Error(parsingUtils.ERROR_XMLFORMAT);}

				var groupName:String = prop.@id;
				if (!assetGroup[groupName])
				{
					assetGroup[groupName] = new Array();
				}

				for each (var child:XML in prop.asset)
				{
					var asset:LoadObject = getLoadObjectFromNode(child);
					assetGroup[groupName].push(asset);
				}
			}
			return assetGroup;
		}

		/* returns a Dictionary of LoadObjects ID'd by ID  */
		public function getLoadObjectsPerSource(modelXML:XMLList):Dictionary
		{
			var assetGroup:Dictionary = new Dictionary(true);
			for each (var child:XML in modelXML.asset)
			{
				var asset:LoadObject = getLoadObjectFromNode(child);
				assetGroup[asset.id] = asset;
			}
			return assetGroup;
		}

		private function getLoadObjectFromNode(node:XML):LoadObject
		{
			if (!node.hasOwnProperty('@source'))
			{throw new Error(parsingUtils.ERROR_XMLFORMAT);}

			var assetURL:String = node.@source;
			var assetID:String = parsingUtils.getNameFromSourceProp(assetURL);
			return new LoadObject(assetURL, assetID);
		}

	}
}

