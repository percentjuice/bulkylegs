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
package com.percentjuice.bulkyLegs.events
{
	import com.percentjuice.bulkyLegs.vo.LoadedObject;

	import flash.events.Event;

	public class LoadedEvent extends Event
	{
		/* event types */
		public static const LOAD_COMPLETE:String = 'load complete';
		public static const UNLOAD_COMPLETE:String = 'unload complete';
		/* payload */
		public var requestName:String;
		/* if LOAD_COMPLETE this object contains load */
		public var loadedObject:LoadedObject;
		/* all options which have/haven't been loaded (regardless of Loaded type) */
		public var allLoadedIds:Array;
		public var allAssetIds:Array;

		public function LoadedEvent(type:String)
		{
			super(type, false, false);
			allLoadedIds = [];
			allAssetIds = [];
		}

		/* override clone so the event can be redispatched */
		public override function clone():Event
		{
			var le:LoadedEvent = new LoadedEvent(type);
			le.requestName = requestName;
			le.loadedObject = loadedObject;
			le.allLoadedIds = allLoadedIds;
			le.allAssetIds = allAssetIds;
			return le;
		}

		/* 'utility function for implementing the toString() method' */
		public override function toString():String
		{
			return String(formatToString("LoadedEvent", "type") + "\r\tgroupName: " + requestName + "\r\t loadedObject inst: " + (loadedObject!=null));
		}

	}
}

