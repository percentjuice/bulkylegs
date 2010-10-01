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

	import com.percentjuice.bulkyLegs.services.assetHandling.ALoad;

	import flash.utils.Dictionary;

	public class ALoader extends ALoad implements ILoader 
	{
		/* ALoader types */
		public static const EMPTY:String = 'empty';
		public static const LOADED:String = 'loaded';
		/* errors */
		private const ERROR_TYPE:String = ' is not an available Loader type.';
		private const ERROR_WRONGTYPE:String = 'Choose LOADED Loader type if Loader has props set.';
		private const ERROR_MISSINGPROPS:String = 'LOADED Loader requires props: bulkLoader, loadGroups, LanguageOptions.';
		/* does loading */
		private var _bulkLoader:BulkLoader;
		/* reference to current group load */
		private var _requestName:String;
		/* loading groups */
		private var _loadGroups:Dictionary;
		private var _languageOptions:Dictionary;
		/* name/value pairs for the requested load */
		public var _loadedRequest:Dictionary;

		public function ALoader(type:String, props:Object=null)
		{
			super();
			setType(type, props);
		}

		private function setType(type:String, props:Object=null):void
		{
			switch(type)
			{
				case EMPTY:
					if (props)
					{
						throw new Error(ERROR_WRONGTYPE);	
					}
					break;
				case LOADED:
					if (props && props.bulkLoader && props.loadGroups && props.languageOptions)
					{
						bulkLoader = props.bulkLoader;
						loadGroups = props.loadGroups;
						languageOptions = props.languageOptions;
					}
					else
					{
						throw new Error(ERROR_MISSINGPROPS);
					}
					break;
				default:
					throw new Error(type+ERROR_TYPE);
			}
			props = null;
		}

		public function get bulkLoader():BulkLoader
		{
			return _bulkLoader;
		}
		public function set bulkLoader(bl:BulkLoader):void
		{
			_bulkLoader = bl;
		}
		public function get requestName():String
		{
			return _requestName;
		}
		public function set requestName(rn:String):void
		{
			_requestName = rn;
		}
		public function get loadGroups():Dictionary
		{
			return _loadGroups;
		}
		public function set loadGroups(lg:Dictionary):void
		{
			_loadGroups = lg;
		}
		public function get languageOptions():Dictionary
		{
			return _languageOptions;
		}
		public function set languageOptions(lo:Dictionary):void
		{
			_languageOptions = lo;
		}
		public function get loadedRequest():Dictionary
		{
			return _loadedRequest;
		}
		public function set loadedRequest(lr:Dictionary):void
		{
			_loadedRequest = lr;
		}

	}
}

