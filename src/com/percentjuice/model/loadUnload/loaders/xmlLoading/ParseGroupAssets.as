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
	import com.percentjuice.model.loadUnload.loaders.xmlLoading.xmlParsing.GetDataObjectsFromXML;

	import flash.utils.Dictionary;

	/* only runs once.  takes model from set destination.  parses XML to objects for future BulkLoader loading.  */
	public class ParseGroupAssets implements IParseXML
	{
		/* parsed resources */
		public var loadGroups:Dictionary;
		public var languageOptions:Dictionary;

		/* class used to load & parse XML.  discard after all XML parsing complete. */
		public function ParseGroupAssets()
		{
			super();
		}

		public function parseAssetsFromXML(bulkLoader:BulkLoader, bulkLoaderKey:String):void
		{
			var modelXML:XML = bulkLoader.getXML(bulkLoaderKey);

			var getData:GetDataObjectsFromXML = new GetDataObjectsFromXML();
			/* if XML contains <groups> with <group> child with <asset> child */
			if (modelXML.groups.length() && modelXML.groups.group.length() && modelXML.groups.group.asset.length())
			{
				loadGroups = getData.getLoadObjectsPerGroup(modelXML.groups);
			}
			/* if XML contains <languages> with <asset> child */
			if (modelXML.languages.length() && modelXML.languages.asset.length())
			{
				languageOptions = getData.getLoadObjectsPerSource(modelXML.languages);
			} 

			/* once XML is parsed, XML is irrelevant */
			bulkLoader.remove(bulkLoaderKey);
		}
	}
}

