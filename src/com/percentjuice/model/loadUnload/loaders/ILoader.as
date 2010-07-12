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
package com.percentjuice.model.loadUnload.loaders
{
	import br.com.stimuli.loading.BulkLoader;

	import com.percentjuice.model.IModelLoad;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public interface ILoader extends IEventDispatcher, IModelLoad
	{
		function get bulkLoader():BulkLoader;
		function set bulkLoader(bl:BulkLoader):void;
		function get requestName():String;
		function set requestName(rn:String):void;
		function get loadGroups():Dictionary;
		function set loadGroups(lg:Dictionary):void;
		function get languageOptions():Dictionary;
		function set languageOptions(lo:Dictionary):void;
		function get loadedRequest():Dictionary;
		function set loadedRequest(lr:Dictionary):void;
	}
}


