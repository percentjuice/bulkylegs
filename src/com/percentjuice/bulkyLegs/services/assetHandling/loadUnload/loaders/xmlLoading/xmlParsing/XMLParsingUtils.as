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
package com.percentjuice.bulkyLegs.services.assetHandling.loadUnload.loaders.xmlLoading.xmlParsing
{
	import flash.utils.Dictionary;	

	public class XMLParsingUtils
	{
		/* singleton */
		private static var inst:XMLParsingUtils;
		private static var allowInstantiation:Boolean;
		/* error messages */
		internal const ERROR_XMLFORMAT:String = 'check XML formatting';
		/* */ 
		private const numbersRE:RegExp = /\d/;

		public function XMLParsingUtils()
		{
			if (!allowInstantiation) {
				throw new Error("singleton.");
			}
		}

		/**
		 * Singleton Instance.
		 */
		public static function gi():XMLParsingUtils
		{
			if(!inst) 
			{
				allowInstantiation = true;
				inst=new XMLParsingUtils();
				allowInstantiation = false;
			}
			return inst;
		}		

		/* sets Dictionary props where prop exists in XMLList
		 * from http://lassieadventurestudio.wordpress.com/2008/12/
		 */
		private function parseAttributes($obj:Dictionary, $atts:XMLList):Dictionary
		{
			for (var j:int=0; j < $atts.length(); j++)
			{
				var $prop:String = $atts[j].name();
				if ($obj.hasOwnProperty($prop))
				{
					if ($obj[$prop] is Boolean) $obj[$prop] = ($atts[j] == "1" || $atts[j] == "true");
					else $obj[$prop] = $atts[j];
				}
			}
			return $obj;
		}		

		/* takes string and returns int value; also accepts 'preload' as 0 */
		public function getIntFromGroupProp(loadString:String):int
		{
			if (numbersRE.test(loadString))
			{
				return int(loadString);
			}
			else if (loadString == 'preload')
			{
				return 0;
			}
			else
			{
				throw new Error(ERROR_XMLFORMAT);
			}
		}

		/* returns true for 'true' or '1', else returns false */
		public function getBooleanFromXML(value:String):Boolean
		{
			return ((value == 'true' || value == '1') ? true : false);
		}

		/* takes source url such as 'directory/director/hawk.jpg' and returns 'hawk' to be used as identifier */
		public function getNameFromSourceProp(url:String):String
		{
			var folderSplit:Array = new Array();
			folderSplit = url.split('/');
			var extensionSplit:Array = new Array();
			extensionSplit = String(folderSplit[folderSplit.length-1]).split('.');
			var name:String = extensionSplit[0];
			if (name.length == 0) {throw new Error(ERROR_XMLFORMAT);}
			return name;				
		}

		/* takes array such as 1, 2, 4, and returns 0, 1, 2 */
		public function closeAnyGapsInArray(arr:Array):Array
		{
			var l:int = arr.length;
			for (var i:int=0;i<l;i++)
			{
				if (!arr[i])
				{
					arr.splice(i, 1);
				}
			}
			return arr;		
		}
	}
}

