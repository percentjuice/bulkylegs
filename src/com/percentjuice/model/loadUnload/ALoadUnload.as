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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class ALoadUnload extends EventDispatcher
	{
		/* states */
		protected const INIT:String = 'initializing assets';
		protected const RUNGROUP:String = 'asset loading from group options';
		protected const RUNLANG:String = 'asset loading from lang options';
		protected var state:String;
		/* all options which were loaded; RunLoaders load increasing assets to these; unloadGroup removes assets from these */
		protected var groupAssets:Dictionary;
		protected var languageText:Dictionary;

		public function ALoadUnload(state:String, groupAssets:Dictionary, languageText:Dictionary)
		{
			super();
			this.state = state;
			this.groupAssets = groupAssets;
			this.languageText = languageText;
		}
	}
}

