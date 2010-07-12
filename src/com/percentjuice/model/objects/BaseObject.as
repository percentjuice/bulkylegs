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
package com.percentjuice.model.objects
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.display.Bitmap;
	import flash.media.Sound;

	/**
	 * @author chad
	 */
	public class BaseObject extends Dictionary 
	{
		/* local */
		private var varList:XMLList;
		private var i:int;
		private var l:int;

		/* create a weakly referenced dictionary by passing true as first param */
		public function BaseObject(populateProps:Object = null)
		{
			super(true);
			init();
			if (populateProps)
			{
				propsFromObject(populateProps);
			}
		}

		/* initializes all public vars of any Child class */
		private function init():void
		{		
			varList = describeType(this)..variable;
			i=0;
			l=varList.length();
			for(i; i < l; i++)
			{
				var type:String = varList[i].@type;
				var prop:* = String(varList[i].@name);
				switch (type)
				{
					case "Number":
						this[prop] = 0;
						break;
					case "Array":
						this[prop] = [];
						break;
					case "String":
						this[prop] = new String();
						break;
					case "flash.display::Bitmap":
						this[prop] = new Bitmap();
						break;
					default:
					//trace('BaseObject:: no instantiation for '+type);
				}
			}			
		}

		/* takes an Object and copies the value of any identical properties */
		public function propsFromObject($obj:Object):void
		{
			varList = describeType(this)..variable;
			i=0;
			l=varList.length();
			for(i; i < l; i++)
			{
				var prop:* = String(varList[i].@name);
				if ($obj.hasOwnProperty(prop))
				{
					this[prop] = $obj[prop];
				}
			}
		}

		/* traces out either all properties, or if (!showVars) just the existing/true/>0 properties */
		public function showVars(showAll : Boolean) : void
		{
			var word:String = (showAll) ? '' : ' not';
			trace(':: '+word+' incl [null/false/0]');

			varList = describeType(this)..variable;
			i=0;
			l=varList.length();
			for(i; i < l; i++)
			{
				var prop:* = String(varList[i].@name);
				if (showAll || ( !showAll && (this[prop] != false && this[prop] != null) ))
				{
					trace('\t'+varList[i].@name+' == '+this[prop]);
				}
			}						
		}

		public function resetVars():void
		{
			init();
		}

	}
}


