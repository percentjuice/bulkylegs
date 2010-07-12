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
package com.percentjuice
{
	import com.percentjuice.controller.*;
	import com.percentjuice.model.*;
	import com.percentjuice.view.*;

	import flash.display.DisplayObjectContainer;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	public class ProjectContext extends Context
	{
		public function ProjectContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}

		override public function startup():void
		{
			commandMap.mapEvent(ContextEvent.STARTUP, PrepModelCommand, ContextEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP, PrepViewCommand, ContextEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP, PrepControllerCommand, ContextEvent, true);
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));

			/* init preload */
			dispatchEvent(new LoadRequestEvent(LoadRequestEvent.REQUEST_LOAD, 'english'));						
			dispatchEvent(new LoadRequestEvent(LoadRequestEvent.REQUEST_LOAD, 'preload'));						
		}

	}
}

